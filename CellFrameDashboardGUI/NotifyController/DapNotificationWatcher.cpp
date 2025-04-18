#include "DapNotificationWatcher.h"


#ifdef Q_OS_WIN
#include <windows.h>
#endif


QByteArrayList DapNotificationWatcher::jsonListFromData(QByteArray data)
{
    return data.split('\x00');
}

DapNotificationWatcher::DapNotificationWatcher(QObject *parent)
{

}

void DapNotificationWatcher::run()
{
    m_initTimer = new QTimer(this);
    m_reconnectTimer = new QTimer(this);

    if(initWatcher())
        return;
    else
    {
        m_initTimer->start(5000);
        connect(m_initTimer, &QTimer::timeout, [=] {
            qDebug()<<"Reinit timer tick";
            if(initWatcher())
                m_initTimer->stop();
        });
    }
}

DapNotificationWatcher::~DapNotificationWatcher()
{
    delete m_initTimer;
    delete m_reconnectTimer;
}

bool DapNotificationWatcher::checkConfig()
{
    DapConfigReader configReader;
    bool configStatus = configReader.getConfigStatus();

    if(configStatus)
    {
        m_listenPath = configReader.getItemString("notify_server", "listen_path", "");
        m_listenAddr = configReader.getItemString("notify_server", "listen_address", "");
        m_listenPort = configReader.getItemInt("notify_server", "listen_port", 0);

        if(m_listenAddr.contains(":"))
        {
            m_listenPort = QString(m_listenAddr.split(":")[1]).toUInt();
            m_listenAddr = m_listenAddr.split(":")[0];
        }
    }

    qDebug()<<"----------------- Notify connect data -----------------"
            <<"Config status: " +  configStatus
            <<"Config path: "   +  configReader.getConfigPath()
            <<"Listen addr: "   +  m_listenAddr
            <<"Listen port: "   +  QString::number(m_listenPort)
            <<"Listen path: "   +  m_listenPath;

    return configStatus;
}

bool DapNotificationWatcher::initWatcher()
{
    if(checkConfig())
    {
        connect(m_reconnectTimer, SIGNAL(timeout()), this, SLOT(slotReconnect()));

        if (!m_listenPath.isEmpty())
        {
            m_socket = new QLocalSocket(this);
            connect((QLocalSocket*)m_socket, QOverload<QLocalSocket::LocalSocketError>::of(&QLocalSocket::errorOccurred),
                    this, &DapNotificationWatcher::slotError);

            connect((QLocalSocket*)m_socket, &QLocalSocket::connected,
                    this, &DapNotificationWatcher::socketConnected);

            connect((QLocalSocket*)m_socket, &QLocalSocket::disconnected,
                    this, &DapNotificationWatcher::socketDisconnected);

            connect((QLocalSocket*)m_socket, &QLocalSocket::stateChanged,
                    this, &DapNotificationWatcher::socketStateChanged);

            ((QLocalSocket*)m_socket)->connectToServer(m_listenPath);
            ((QLocalSocket*)m_socket)->waitForConnected();
        }
        else
        {
            m_socket = new QTcpSocket(this);
            connect((QTcpSocket*)m_socket, QOverload<QAbstractSocket::SocketError>::of(&QAbstractSocket::errorOccurred),
                    this, &DapNotificationWatcher::slotError);

            connect((QTcpSocket*)m_socket, &QTcpSocket::connected,
                    this, &DapNotificationWatcher::socketConnected);

            connect((QTcpSocket*)m_socket, &QTcpSocket::disconnected,
                    this, &DapNotificationWatcher::socketDisconnected);

            connect((QTcpSocket*)m_socket, &QTcpSocket::stateChanged,
                    this, &DapNotificationWatcher::tcpSocketStateChanged);

            connect(m_socket, &QTcpSocket::readyRead, this, &DapNotificationWatcher::socketReadyRead);

            ((QTcpSocket*)m_socket)->connectToHost(m_listenAddr, m_listenPort);
            ((QTcpSocket*)m_socket)->waitForConnected();
        }
        m_statusInitWatcher = true;
        return true;
    }
    m_statusInitWatcher = false;
    return false;
}

void DapNotificationWatcher::slotError()
{
    qWarning() << "Notify socket error" << m_socket->errorString();
    reconnectFunc();
}

void DapNotificationWatcher::slotReconnect()
{
    qInfo()<<"DapNotificationWatcher::slotReconnect()" << m_listenAddr << m_listenPort << "Socket state" << m_socketState;
    checkConfig();

    ((QTcpSocket*)m_socket)->connectToHost(m_listenAddr, m_listenPort);
    ((QTcpSocket*)m_socket)->waitForConnected(5000);

#ifdef Q_OS_WIN

    if(m_socketState != QAbstractSocket::SocketState::ConnectedState &&
       m_socketState != QAbstractSocket::SocketState::ConnectingState)
    {
        if(DapConfigToolController::getInstance().runNode())
            qInfo()<<"Succes restart node";
        else
            qWarning()<<"Error restart node";
    }

#endif
}

void DapNotificationWatcher::socketConnected()
{
    qInfo() << "Notify socket connected";
    m_reconnectTimer->stop();
    m_socket->waitForReadyRead(4000);
}

void DapNotificationWatcher::socketDisconnected()
{
    qWarning() << "Notify socket disconnected";
    reconnectFunc();
}

void DapNotificationWatcher::socketStateChanged(QLocalSocket::LocalSocketState socketState)
{
    qDebug() << "Local socket state changed" << socketState;
    m_socketState = socketState;
    emit changeConnectState(m_socketState);
}

void DapNotificationWatcher::socketReadyRead()
{
//    qDebug() << "Ready Read";
//    QByteArray data = m_socket->readLine();
    QByteArray data = m_socket->readAll();
    if (data[data.length() - 1] != '}')
        data = data.left(data.length() - 1);

    if (data[0] != '{')
        data = data.right(data.length() - 1);

    QByteArrayList list = jsonListFromData(data);

    for (int i = 0; i < list.length(); ++i)
    {
        QJsonParseError error;
        QJsonDocument reply = QJsonDocument::fromJson(list[i], &error);
        if (error.error != QJsonParseError::NoError) {
            qWarning()<<"Notify parse error. " << error.errorString(); // more logs
        }
        else
        {
            emit rcvNotify(reply.toVariant());
        }
    }
}

void DapNotificationWatcher::tcpSocketStateChanged(QAbstractSocket::SocketState socketState)
{
    qDebug() << "Notify socket state changed" << socketState;
    m_socketState = socketState;
    emit changeConnectState(m_socketState);
}

void DapNotificationWatcher::reconnectFunc()
{
    m_reconnectTimer->stop();

    if(m_socketState != QAbstractSocket::SocketState::ConnectedState &&
       m_socketState != QAbstractSocket::SocketState::ConnectingState && m_isStartNode)
    {
        m_reconnectTimer->start(10000);
        qWarning()<< "Notify socket reconnecting...";
    }
}

void DapNotificationWatcher::isStartNodeChanged(bool isStart)
{
    m_isStartNode = isStart;
}

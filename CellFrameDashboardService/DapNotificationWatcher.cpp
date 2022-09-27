#include "DapNotificationWatcher.h"
#include <QLocalSocket>
#include <QDebug>
#include <dap_config.h>
#include <QTcpSocket>
#include <QTimer>
#include <dapconfigreader.h>
#include <QJsonDocument>
#include <QProcess>
#ifdef Q_OS_WIN
#include <windows.h>
#endif


QByteArrayList DapNotificationWatcher::jsonListFromData(QByteArray data)
{
    return data.split('\x00');
}

DapNotificationWatcher::DapNotificationWatcher(QObject *parent)
{
    DapConfigReader configReader;

    m_listenPath = configReader.getItemString("notify_server", "listen_path", "");
    m_listenAddr = configReader.getItemString("notify_server", "listen_address", "");
    m_listenPort = configReader.getItemInt("notify_server", "listen_port", 0);

    qDebug() << "Tcp config: " << m_listenAddr << m_listenPort;

    m_reconnectTimer = new QTimer(this);
    connect(m_reconnectTimer, SIGNAL(timeout()), this, SLOT(slotReconnect()));

    if (!m_listenPath.isEmpty())
    {
        socket = new QLocalSocket(this);
        connect((QLocalSocket*)socket, QOverload<QLocalSocket::LocalSocketError>::of(&QLocalSocket::error),
                this, &DapNotificationWatcher::slotError);

        connect((QLocalSocket*)socket, &QLocalSocket::connected,
                this, &DapNotificationWatcher::socketConnected);

        connect((QLocalSocket*)socket, &QLocalSocket::disconnected,
                this, &DapNotificationWatcher::socketDisconnected);

        connect((QLocalSocket*)socket, &QLocalSocket::stateChanged,
                this, &DapNotificationWatcher::socketStateChanged);

        ((QLocalSocket*)socket)->connectToServer(m_listenPath);
        ((QLocalSocket*)socket)->waitForConnected();
    }
    else
    {
        socket = new QTcpSocket(this);
        connect((QTcpSocket*)socket, QOverload<QAbstractSocket::SocketError>::of(&QAbstractSocket::error),
                this, &DapNotificationWatcher::slotError);

        connect((QTcpSocket*)socket, &QTcpSocket::connected,
                this, &DapNotificationWatcher::socketConnected);

        connect((QTcpSocket*)socket, &QTcpSocket::disconnected,
                this, &DapNotificationWatcher::socketDisconnected);

        connect((QTcpSocket*)socket, &QTcpSocket::stateChanged,
                this, &DapNotificationWatcher::tcpSocketStateChanged);

        connect(socket, &QTcpSocket::readyRead, this, &DapNotificationWatcher::socketReadyRead);

        ((QTcpSocket*)socket)->connectToHost(m_listenAddr, m_listenPort);
        ((QTcpSocket*)socket)->waitForConnected();
    }
}

void DapNotificationWatcher::slotError()
{
    qWarning() << "Notify socket error" << socket->errorString();
    reconnectFunc();
}

void DapNotificationWatcher::slotReconnect()
{
    ((QTcpSocket*)socket)->connectToHost(m_listenAddr, m_listenPort);
    ((QTcpSocket*)socket)->waitForConnected(3000);

    sendNotifyState("Notify socket error");

#ifdef Q_OS_WIN
    HANDLE hEvent = OpenEventA(EVENT_MODIFY_STATE, 0, "Local\\" DAP_BRAND_BASE_LO "-node");
    if (!hEvent) {
        qInfo() << "Restarting the node: "
                << QProcess::startDetached("schtasks.exe", QStringList({"/run", "/I", "/TN", DAP_BRAND_BASE_LO "-node"}));
    } else {
        CloseHandle(hEvent);
    }
#endif
}

void DapNotificationWatcher::socketConnected()
{
    qInfo() << "Notify socket connected";
    m_reconnectTimer->stop();
    socket->waitForReadyRead(4000);
    sendNotifyState("Notify socket connected");
}

void DapNotificationWatcher::socketDisconnected()
{
    qWarning() << "Notify socket disconnected";
    reconnectFunc();
}

void DapNotificationWatcher::socketStateChanged(QLocalSocket::LocalSocketState socketState)
{
    qDebug() << "Local socket state changed" << socketState;
}

void DapNotificationWatcher::socketReadyRead()
{
//    qDebug() << "Ready Read";
    QByteArray data = socket->readLine();
//    QByteArray data = socket->readAll();
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
            qWarning()<<"Notify parse error. " << error.errorString();
        }
        else{
            QVariantMap map = reply.object().toVariantMap();
            map["connect_state"] = QVariant::fromValue(m_socketState);
            emit rcvNotify(map);
        }
    }
}

void DapNotificationWatcher::tcpSocketStateChanged(QAbstractSocket::SocketState socketState)
{
    qDebug() << "Notify socket state changed" << socketState;
    m_socketState = socketState;
    changeConnectState(m_socketState);
}

void DapNotificationWatcher::reconnectFunc()
{
    m_reconnectTimer->stop();

    if(m_socketState != QAbstractSocket::SocketState::ConnectedState &&
       m_socketState != QAbstractSocket::SocketState::ConnectingState)
    {
        m_reconnectTimer->start(5000);
        qWarning()<< "Notify socket reconnecting...";
    }
}

void DapNotificationWatcher::frontendConnected()
{
    if(m_socketState == QAbstractSocket::SocketState::ConnectedState)
        sendNotifyState("Notify socket connected");
    else
        sendNotifyState("Notify socket error");
}

void DapNotificationWatcher::sendNotifyState(QVariant msg)
{
    QVariantMap sendMsg = msg.toMap();
    sendMsg["connect_state"] = QVariant::fromValue(m_socketState);
    emit rcvNotify(sendMsg);
}

#include "DiagtoolConnectCotroller.h"

static uint16_t s_listenPort = 8040;

DiagtoolConnectCotroller::DiagtoolConnectCotroller(QObject *parent)
    : QObject{parent}
{
    qRegisterMetaType<QAbstractSocket::SocketState>();

    qDebug() << "Tcp diagtool config: 127.0.0.1:"  << s_listenPort;

    m_socket = new QTcpSocket();
    connect(m_socket, QOverload<QAbstractSocket::SocketError>::of(&QAbstractSocket::errorOccurred),
            this, &DiagtoolConnectCotroller::slotError);

    connect(m_socket, &QTcpSocket::stateChanged,
            this, &DiagtoolConnectCotroller::slotStateChanged);

    connect(m_socket, &QTcpSocket::readyRead,
            this, &DiagtoolConnectCotroller::slotReadyRead);

    m_socket->connectToHost(QHostAddress("127.0.0.1"), s_listenPort);
    m_socket->waitForConnected();

}

quint64 DiagtoolConnectCotroller::writeSocket(QByteArray data)
{
    quint64 resBytes = m_socket->write(data);
    m_socket->flush();
    return resBytes;
}

void DiagtoolConnectCotroller::slotError()
{
    qWarning() << "Diagtool socket error" << m_socket->errorString();
}

void DiagtoolConnectCotroller::slotStateChanged(QAbstractSocket::SocketState socketState)
{
    qDebug() << "Diagtool socket state changed" << socketState;

    if (socketState == QTcpSocket::SocketState::UnconnectedState)
    {
        qWarning() << "Diagtool socket disconnected";

        QTimer::singleShot(5000, [this](){
            qDebug() << "=== Diagtool try reconnect "<<"127.0.0.1:"<<s_listenPort;
            m_socket->connectToHost(QHostAddress("127.0.0.1"), s_listenPort);
        });
    }

    if(socketState != QTcpSocket::SocketState::ConnectedState)
    {
        qWarning() << "Diagtool socket connected";
        m_connectStatus = false;
    }
    else
        m_connectStatus = true;

    signalSocketChangeStatus(m_connectStatus);
}

void DiagtoolConnectCotroller::slotReadyRead()
{
    if(!m_connectStatus) return;

//    qDebug() << "[slotReadyRead] ready read diagostic data";
    QByteArray rcvData = m_socket->readAll();
//    qDebug() << "[slotReadyRead] data size = " << rcvData.size();

    QJsonParseError error;
    QJsonDocument diagData = QJsonDocument::fromJson(rcvData, &error);

    if (error.error != QJsonParseError::NoError)
        qWarning()<<"Diagtool json parse error";

    emit signalDataRcv(diagData);
}

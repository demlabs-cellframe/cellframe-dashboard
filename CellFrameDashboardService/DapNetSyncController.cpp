#include "DapNetSyncController.h"

DapNetSyncController::DapNetSyncController(DapNotificationWatcher* watcher, QObject *parent)
    : QObject{parent}
{
    m_notifWatch = watcher;
    m_nodeState = watcher->getSocketState();
    updateTick();

    m_timerSync = new QTimer(this);
    connect(m_timerSync, SIGNAL(timeout()), this, SLOT(updateTick()));
    m_timerSync->start(m_syncTime);

    connect(m_notifWatch, SIGNAL(changeConnectState(QString)), this, SLOT(rcvNotifState(QString)));
}

void DapNetSyncController::updateTick()
{
    QStringList netList;
    netList = getNetworkList();

    for(QString net: netList)
        goSyncNet(net);

}

QStringList DapNetSyncController::getNetworkList()
{
    QProcess process;
    process.start(QString(CLI_PATH), QStringList()<<"net"<<"list");
    process.waitForFinished(1000);
    QString result = QString::fromLatin1(process.readAll());

    QStringList list;

    if (!result.contains("Socket connection err") &&
        result.contains("Networks:"))
    {
        result.remove(' ');
        result.remove('\r');
        result.remove('\t');
        result.remove("Networks:");
        if(!(result.isEmpty() || result.isNull() || result.contains('\'')))
            list = result.split('\n', QString::SkipEmptyParts);
    }
    else
        qWarning() << "Net list ERROR! Result:" << result;

    if (list.isEmpty())
        qWarning()<<"Empty network lsit";

    return list;
}

void DapNetSyncController::goSyncNet(QString net)
{
    QProcess process;
    process.start(QString(CLI_PATH), QStringList()<<"net"<<"-net"<<net<<"go"<< "sync");
    process.waitForFinished(1000);
    QString result = QString::fromLatin1(process.readAll());
    qInfo() << "result:" << result;
}

void DapNetSyncController::rcvNotifState(QString state)
{
    if(state == QAbstractSocket::SocketState::ConnectedState)
    {
        if(state != m_nodeState)
        {
            m_timerSync->stop();
            updateTick();
            m_timerSync->start(m_syncTime);
        }
    }
    m_nodeState = state;
}

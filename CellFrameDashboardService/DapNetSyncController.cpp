#include "DapNetSyncController.h"

DapNetSyncController::DapNetSyncController(DapNotificationWatcher* watcher, QObject *parent)
    : QObject{parent}
{
    m_notifWatch = watcher;
    m_nodeState = watcher->m_socketState;
    updateTick();

    m_timerSync = new QTimer(this);
    connect(m_timerSync, SIGNAL(timeout()), this, SLOT(updateTick()));
    m_timerSync->start(1000 * 60 * 5); //5 min timer

    connect(m_notifWatch, SIGNAL(changeConnectState(QString)), this, SLOT(rcvNotifState(QString)));
}

void DapNetSyncController::updateTick()
{
    QStringList netList;
    netList = getNetworkList();

    for(int i = 0; i < netList.length(); i++)
        goSyncNet(netList[i]);

}

QStringList DapNetSyncController::getNetworkList()
{
    QProcess process;
    QString command = QString("%1 net list").arg(CLI_PATH);
    process.start(command);
    process.waitForFinished(-1);
    QString result = QString::fromLatin1(process.readAll());

    QStringList list;

    result.remove(' ');
    result.remove('\r');
    result.remove('\t');
    result.remove("Networks:");

    if(!(result.isEmpty() || result.isNull() || result.contains('\'')))
        list = result.split('\n', QString::SkipEmptyParts);
    else
        qWarning()<<"Empty network lsit";

    return list;
}

void DapNetSyncController::goSyncNet(QString net)
{
    QProcess process;
    QString command(QString("%1 net -net %2 go sync").arg(CLI_PATH).arg(net));
    process.start(command);
    process.waitForFinished(10);
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
            m_timerSync->start(1000 * 60 * 5);
        }
    }
    m_nodeState = state;
}

#include "DapNetSyncController.h"

DapNetSyncController::DapNetSyncController(QObject *parent)
    : QObject{parent}
{
    updateTick();

    m_timerSync = new QTimer(this);
    connect(m_timerSync, SIGNAL(timeout()), this, SLOT(updateTick()));
    m_timerSync->start(1000 * 60 * 20); //20 min timer

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
    process.waitForFinished(-1);
    QString result = QString::fromLatin1(process.readAll());
    qInfo() << "result:" << result;

}

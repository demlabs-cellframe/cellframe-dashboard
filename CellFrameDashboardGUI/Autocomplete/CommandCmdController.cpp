#include "CommandCmdController.h"
#include <QFile>

CommandCmdController::CommandCmdController(QObject *parent) : QObject(parent)
{
}

void CommandCmdController::dapServiceControllerInit(DapServiceController *_dapServiceController)
{

    dapServiceController = _dapServiceController;

//    dapServiceController->requestToService("DapGetWordBook", "init");
    rcvDataBuffer = false;
    isOpenPage = false;

    connect(dapServiceController, &DapServiceController::rcvWordBook, [=] (const QVariant& rcvData)
    {
        buffer.clear();
        QByteArray byteData = QByteArray::fromHex(rcvData.toByteArray());
        QDataStream streamer(&byteData, QIODevice::ReadOnly);
        streamer >> buffer;
        if(!buffer.isEmpty())
            rcvDataBuffer = true;
    });

    updateValuesTimer = new QTimer(this);
    connect(updateValuesTimer, &QTimer::timeout, [=] (){
        if(isOpenPage)
            dapServiceController->requestToService("DapGetWordBook", QStringList()<<"init");
    });
    updateValuesTimer->start(10000);
}

int CommandCmdController::maxLengthText(QVariantList list)
{
    int max = 0;
    int idx = 0;
    for (int i = 0; i < list.length(); ++i)
        if (list[i].toMap()["word"].toString().length() > max)
        {
             max = list[i].toMap()["word"].toString().length();
             idx = i;
        }
    return idx;
}

QVariantList CommandCmdController::getTreeWords(QString value)
{
    dapServiceController->requestToService("DapGetWordBook", QStringList()<<value);
    rcvDataBuffer = false;
    buffer.clear();
    quint64 savedTime = QDateTime::currentMSecsSinceEpoch();

    while(!rcvDataBuffer)
    {
        if(QDateTime::currentMSecsSinceEpoch() - savedTime >= 30)
            break;
        QCoreApplication::processEvents(QEventLoop::AllEvents);
    }
    return buffer;
}

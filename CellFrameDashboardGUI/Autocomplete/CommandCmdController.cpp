#include "CommandCmdController.h"
#include <QFile>

CommandCmdController::CommandCmdController(QObject *parent) : QObject(parent)
{

}

void CommandCmdController::dapServiceControllerInit(DapServiceController *_dapServiceController)
{

    dapServiceController = _dapServiceController;

    dapServiceController->requestToService("DapGetWordBook", "init");
    rcvDataBuffer = false;

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
        dapServiceController->requestToService("DapGetWordBook", "init");
    });
    updateValuesTimer->start(10000);

}

QVariantList CommandCmdController::getTreeWords(QString value)
{
    dapServiceController->requestToService("DapGetWordBook", value);
    rcvDataBuffer = false;
    buffer.clear();
    quint64 savedTime = QDateTime::currentMSecsSinceEpoch();

    while(!rcvDataBuffer)
    {
        if(QDateTime::currentMSecsSinceEpoch() - savedTime >= 40)
            break;
        QCoreApplication::processEvents(QEventLoop::AllEvents);
    }

//    if(value.contains("create") || value.contains("new"))
//        dapServiceController->requestToService("DapGetWordBook", "init");

    return buffer;
}

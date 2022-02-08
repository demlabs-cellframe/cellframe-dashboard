#include "commandcmdcontroller.h"

CommandCmdController::CommandCmdController(QObject *parent) : QObject(parent)
{
}

void CommandCmdController::dapServiceControllerInit(DapServiceController *_dapServiceController)
{
    dapServiceController = _dapServiceController;

    if (dapServiceController)
    {
        dapServiceController->requestToService("DapRunCmdCommand", "help");
        connect(dapServiceController, &DapServiceController::cmdRunned, this, &CommandCmdController::parseAllCommands);
    }
    else
        qDebug() << "NOOOOOOOOOOOOOO!!!";
}

void CommandCmdController::parseAllCommands(const QVariant &asAnswer)
{
    QString str = asAnswer.toList()[1].toString();
    str = str.right(str.size() - 21);
    qDebug() << "aaaaaaaaaaaaaaaaaaa" << str;
}

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
    disconnect(dapServiceController, &DapServiceController::cmdRunned, this, &CommandCmdController::parseAllCommands);
    connect(dapServiceController, &DapServiceController::cmdRunned, this, &CommandCmdController::parseAllCommandsParams);
    QString str = asAnswer.toList()[1].toString();
    str = str.right(str.size() - 21);

    QStringList _commands = str.split("\n");

    for (int i = 0; i < _commands.length(); ++i)
    {
        QStringList tmp = _commands[i].split(":");
        if (!tmp.empty() && tmp[0] != "" && tmp[0] != "\r")
        {
            commands.append(tmp[0]);
            dapServiceController->requestToService("DapRunCmdCommand", QString("help " + tmp[0]));
        }
    }
}

/*
Private token update"
aaaaaaaaaaaaaaaaaaaaaa "==Params=="
aaaaaaaaaaaaaaaaaaaaaa "General:"
aaaaaaaaaaaaaaaaaaaaaa "Datum type allowed/blocked updates:"
aaaaaaaaaaaaaaaaaaaaaa "Tx receiver addresses allowed/blocked updates:"
aaaaaaaaaaaaaaaaaaaaaa "Tx sender addresses allowed/blocked updates:"
aaaaaaaaaaaaaaaaaaaaaa "==Flags==\t ALL_BLOCKED:\t Blocked all permissions, usefull add it first and then add allows what you want to allow"
aaaaaaaaaaaaaaaaaaaaaa "Simple token declaration:"
aaaaaaaaaaaaaaaaaaaaaa "Extended private token declaration"
aaaaaaaaaaaaaaaaaaaaaa "==Flags==\t ALL_BLOCKED:\t Blocked all permissions, usefull add it first and then add allows what you want to allow"
aaaaaaaaaaaaaaaaaaaaaa "==Params=="
aaaaaaaaaaaaaaaaaaaaaa "General:"
aaaaaaaaaaaaaaaaaaaaaa "Datum type allowed/blocked:"
aaaaaaaaaaaaaaaaaaaaaa "Tx receiver addresses allowed/blocked:"
aaaaaaaaaaaaaaaaaaaaaa "Tx sender addresses allowed/blocked:"
 */

void CommandCmdController::parseAllCommandsParams(const QVariant &asAnswer)
{
    QString command = asAnswer.toList()[0].toString();
    command = command.right(command.length() - 5);

    QString str = asAnswer.toList()[1].toString();
    str = str.right(str.size());

    QStringList _commands = str.split("\n");
    QStringList commandParams;

    for (int i = 1; i < _commands.length(); ++i)
    {
        if (!_commands[i].startsWith("\t") && _commands[i] != "" && _commands[i] != "\r" && _commands[i][0].isLower())
        {
            qDebug() << "aaaaaaaaaaaaaaaaaaaaaa" << _commands[i];
            commandParams.append(_commands[i]);
        }
    }

    commandsParams[command] = QVariant::fromValue(commandParams);
}

QString CommandCmdController::getCommandByValue(const QString &value)
{
    for (int i = 0; i < commands.length(); ++i)
    {
        if (commands[i].startsWith(value))
            return commands[i];
    }
    return value;
}

QString CommandCmdController::getCommandParams(const QString &value, int count)
{
    QStringList splitList = value.split(" ");
    QString val = splitList[0];
    QStringList list = commandsParams[val].toStringList();
    QStringList resList;
    for (int i = 0; i < list.length(); ++i)
        if (list[i].startsWith(value))
        {
            resList.append(list[i]);
        }

    if (count < 0)
        count = resList.length() - ((count * -1) % resList.length());

    if (!resList.isEmpty())
        return resList[count % (resList.length())];
    return value;
}

bool CommandCmdController::isOneWord(const QString &value)
{
    return !value.contains(" ");
}

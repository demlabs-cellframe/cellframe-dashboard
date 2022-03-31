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
        qDebug() << "dapServiceController not connected";
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
            commandParams.append(_commands[i]);
            /*qDebug() << "LLLLLLLLLLLLLL" << _commands[i];
            QString _command = _commands[i];
            QVariantList parseList;
            QVector<int> startPosVector;
            for (int j = 0; j < _command.length(); ++j)
            {
                if (_command[j] == '[')
                    startPosVector.push_back(j);

                if (_command[j] == ']')
                {
                    QVariantMap map;
                    int _start = startPosVector[startPosVector.length() - 1];
                    startPosVector.pop_back();
                    map["start"] = QVariant::fromValue(_start);
                    map["end"] = QVariant::fromValue(j);
                    QString s = _command.left(j);
                    s = s.right(s.length() - _start - 1);
                    map["data"] = QVariant::fromValue(s);
                    qDebug() << "PPPPPPPPPPPPP" << s;
                }
            }*/
        }
    }

    commandsParams[command] = QVariant::fromValue(commandParams);
}

QString CommandCmdController::getCommandByValue(const QString &value)
{
    if (!isDisconnect)
    {
        disconnect(dapServiceController, &DapServiceController::cmdRunned, this, &CommandCmdController::parseAllCommandsParams);
        isDisconnect = true;
    }
    for (int i = 0; i < commands.length(); ++i)
    {
        if (commands[i].startsWith(value))
            return commands[i];
    }
    return "";
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

    if (count < 0 && !resList.isEmpty())
        count = resList.length() - ((count * -1) % resList.length());

    if (!resList.isEmpty())
        return resList[count % (resList.length())];
    return "";
}

bool CommandCmdController::isOneWord(const QString &value)
{
    return !value.contains(" ");
}

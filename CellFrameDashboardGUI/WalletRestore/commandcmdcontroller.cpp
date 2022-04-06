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

QString rightOrCommand(QString command, int i)
{
    int count = 0;
    int k = i;
    while (true)
    {
        if (command[i] == '>' || command[i] == ']' || command[i] == '}')
            ++count;

        if (command[i] == '<' || command[i] == '[' || command[i] == '{')
        {
            if (count == 0)
                break;
            --count;
        }
        --i;
    }
    command = command.remove(i + 1, k - i);
    return command;
}

QString leftOrCommand(QString command, int i)
{
    int count = 0;
    int k = i;
    while (true)
    {
        if (command[i] == '>' || command[i] == ']' || command[i] == '}')
        {
            if (count == 0)
                break;
            --count;
        }

        if (command[i] == '<' || command[i] == '[' || command[i] == '{')
            ++count;
        ++i;
    }

    command = command.remove(k, i - k);
    return command;
}

//bbbb { jjjj [kkk] | kkkk } hhh 18

/*void CommandCmdController::parseTree(QString command)
{
    if (!command.contains("[") && !command.contains("|"))
    {
        qDebug() << "command: " << command << "\n";
        //commands.add(command);
        return;
    }
    else if (command.contains("|"))
    {
        int count = 0;
        for (int i = 0; i < command.length(); ++i)
        {
            if (command[i] == '|' && count == 0)
            {
                //parseTree(left(i));
                //parseTree(right(i));
            }

            if (command[i] == '[')
                ++count;

            if (command[i] == ']')
                --count;
        }
    }
    else
        {
            int count = 0;
            int leftIndex = 0;
            for (int i = 0; i < command.length(); ++i)
            {
                if (command[i] == '[' && count == 0)
                    leftIndex = i;

                if (command[i] == ']' && count == 1)
                {
                    //parseTree(command.delete(from leftIndex to i));
                    //parseTree(command.delete(command[leftIndex], command[i]));
                }

                if (command[i] == '[')
                    ++count;

                if (command[i] == '[')
                    --count;
            }
        }
    }
}*/

//"dag -net <chain net name> -chain <chain name>
//event dump -event <event hash> -from < events | events_lasts | round.new  | round.<Round id in hex> > [-H hex|base58(default)]"

//"dag_poa -net <chain net name> -chain <chain name> event sign -event <event hash> [-H hex|base58(default)]"

//net -net <chain net name> link {list | add | del | info | establish}

void CommandCmdController::parseAllCommandsParams(const QVariant &asAnswer)
{
    QString command = asAnswer.toList()[0].toString();
    command = command.right(command.length() - 5);

    QString str = asAnswer.toList()[1].toString();
    str = str.right(str.size());

    QStringList _commands = str.split("\n");
    QStringList commandParams;

    qDebug() << "kkkkkkkkkkkkk\n\n\n\n\n" << leftOrCommand("bbbb { jjjj [kkk] | kkkk } hhh", 18) << "\n\n\n\n\n\n\n";

    for (int i = 1; i < _commands.length(); ++i)
    {
        if (!_commands[i].startsWith("\t") && _commands[i] != "" && _commands[i] != "\r" && _commands[i][0].isLower())
        {
            commandParams.append(_commands[i]);
            //qDebug() << "llllllllllllllllllll " << _commands[i];
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

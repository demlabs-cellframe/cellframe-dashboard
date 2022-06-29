#include "commandcmdcontroller.h"
#include <QFile>

CommandCmdController::CommandCmdController(QObject *parent) : QObject(parent)
{
    values = new AutocompleteValues();
}

void CommandCmdController::dapServiceControllerInit(DapServiceController *_dapServiceController)
{
    if (isFirstInit)
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
        if (i < 0)
            return "";
        if (command[i] == ']' || command[i] == '}')
            ++count;

        if (command[i] == '[' || command[i] == '{')
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
    int j = 0;
    while (true)
    {
        if (i > command.length())
            return "";
        if (command[i] == ']' || command[i] == '}')
        {
            if (count == 0)
                break;
            --count;
        }

        if (command[i] == '[' || command[i] == '{')
            ++count;
        ++i;
    }

    command = command.remove(k, i - k);
    return command;
}

void CommandCmdController::parseTree(QString command)
{
    if (!command.contains("[") && !command.contains("|") && !command.contains("<cert name>"))
    {
        command = command.remove('{');
        command = command.remove('}');

        if (!(!command.contains(" ") || (command.count(" ") == 1 && command.endsWith(" "))))
        {
            for (int i = 0; i < command.length(); ++i)
                if (command[i] == ' ' && command[i - 1] == ' ')
                {
                    command.remove(i, 1);
                    --i;
                }

            parsedCommands.append(command);
        }
        return;
    }
    else if (command.contains("|"))
    {
        for (int i = 0; i < command.length(); ++i)
        {
            if (command[i] == '|'/* && count == 0*/)
            {
                parseTree(leftOrCommand(command, i));
                parseTree(rightOrCommand(command, i));
            }
        }
    }
    else if (command.contains("[") || command.contains("]"))
    {
        int count = 0;
        int leftIndex = 0;
        for (int i = 0; i < command.length(); ++i)
        {
            if (command[i] == '[' && count == 0)
                leftIndex = i;

            if (command[i] == ']' && count == 1)
            {
                QString delCommand = command;
                delCommand = delCommand.remove(leftIndex, i - leftIndex + 1);
                parseTree(delCommand);

                QString isCommand = command.remove(i, 1);
                isCommand = isCommand.remove(leftIndex, 1);
                parseTree(isCommand);
            }

            if (command[i] == '[')
                ++count;

            if (command[i] == ']')
                --count;
        }
    }
    else if (command.contains("<") || command.contains(">"))
    {
        if (command.contains("<cert name>"))
        {
            QStringList certsList = values->getCerts();
            QString sCommand = command;
            int idx = sCommand.indexOf("<cert name>");
            QString s = sCommand.remove(idx, 11);
            for (int i = 0; i < certsList.length(); ++i)
            {
                QString rS = s;
                rS = rS.insert(idx, certsList[i]);
                parseTree(rS);
            }
        }
    }
    else
        return;
}

void CommandCmdController::parseAllCommandsParams(const QVariant &asAnswer)
{
    QString command = asAnswer.toList()[0].toString();
    command = command.right(command.length() - 5);

    QString str = asAnswer.toList()[1].toString();

    str = str.right(str.size());

    QStringList _commands = str.split("\n");

    for (int i = 1; i < _commands.length(); ++i)
    {
        if (!_commands[i].startsWith("\t") && _commands[i] != "" && _commands[i] != "\r" && _commands[i][0].isLower() && _commands[i] != "s" && _commands[i] != "g" && _commands[i] != "n")
        {
            if (_commands[i].contains("\t"))
                _commands[i] = _commands[i].split('\t')[0];

            if (_commands[i].contains("\r"))
                _commands[i] = _commands[i].split('\r')[0];
            {
                //qDebug() << "command:" << _commands[i];

                parsedCommands.clear();
                parseTree(_commands[i]);
                parsedCommands.removeDuplicates();

                for (int j = 0; j < parsedCommands.length(); ++j)
                {
                    QStringList s = parsedCommands[j].split(" ");
                    s.removeAll("");
                    words[command].append(s);
                }
            }
        }
    }
    isFirstInit = false;
}

QVariantList CommandCmdController::getTreeWords(QString value)
{
    if (!isDisconnect)
    {
        disconnect(dapServiceController, &DapServiceController::cmdRunned, this, &CommandCmdController::parseAllCommandsParams);
        isDisconnect = true;
    }

    QStringList list = value.split(" ");

    QVariantList res;

    if (value == "")
        return res;

    QVariantMap map;

    if (list.length() == 1)
    {
        for (int i = 0; i < commands.length(); ++i)
            if (commands[i].startsWith(value))
            {
                map["word"] = QVariant::fromValue(commands[i]);
                map["str"] = QVariant::fromValue(commands[i] + " ");
                res.append(map);
            }
        return res;
    }

    QString key = list[0];
    commandTree *tree = &words[key];

    for (int i = 1; i < list.length(); ++i)
    {
        for (int j = 0; j < tree->children.length(); ++j)
            if (tree->children[j]->data == list[i])
            {
                tree = tree->children[j];
                break;
            }
    }

    if (tree->data != list[list.length() - 1] && list[list.length() - 1] != "")
        return res;

    for (int i = 0; i < tree->children.length(); ++i)
    {
        QString str = tree->children[i]->data;
        if (str.startsWith(" "))
            str.remove(0, 1);

        if (str != "" && str != " ")
        {
            map["word"] = QVariant::fromValue(str);
            if (!value.endsWith(" "))
                value += " ";
            map["str"] = QVariant::fromValue(value + str);
            res.append(map);
        }
    }

    return res;
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

CommandCmdController::commandTree CommandCmdController::commandTree::append(QStringList command)
{
    int i = 1;
    if (this->data == "")
    {
        this->data = command[0];
    }

    commandTree *tree = this;
    bool flag = true;

    while (flag)
    {
        if (tree->children.length() == 0 || i == command.length())
            break;
        for (int j = 0; j < tree->children.length(); ++j)
            if (tree->children[j]->data == command[i])
            {
                tree = tree->children[j];
                ++i;
                break;
            }
            else
                if (j == tree->children.length() - 1)
                    flag = false;
    }

    for (int j = i; j < command.length(); ++j)
    {
        commandTree *tmp = new commandTree;
        tmp->data = command[j];
        tree->children.append(tmp);
        tree = tmp;
    }

    return *this;
}

void CommandCmdController::commandTree::debugTree(commandTree *tree)
{
    qDebug() << "papa" << tree->data;

    if (tree->children.length() == 0)
    {
        return;
    }

    for (int i = 0; i < tree->children.length(); ++i)
    {
        qDebug() << "chichi" << tree->children[i]->data;
    }

    for (int i = 0; i < tree->children.length(); ++i)
    {
        debugTree(tree->children[i]);
    }
}

#include "commandcmdcontroller.h"
#include <QFile>

CommandCmdController::CommandCmdController(QObject *parent) : QObject(parent)
{
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
            values = new AutocompleteValues(dapServiceController);
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
    bool containsValue = command.contains("<chain name>") || command.contains("<priv_cert_name>") || command.contains("<pub_cert_name>") || command.contains("<net_name>") || command.contains("<wallet_name>") || command.contains("<token_ticker>");
    if (!command.contains("[") && !command.contains("|") && !containsValue)
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
    else
    if (command.contains("|"))
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
    else
    if (command.contains("[") || command.contains("]"))
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
    else
    if (command.contains("<") || command.contains(">"))
    {
        if (command.contains("<priv_cert_name>"))
        {
            QStringList certsList = values->getPrivCerts();
            QString sCommand = command;
            int idx = sCommand.indexOf("<priv_cert_name>");
            QString s = sCommand.remove(idx, 16);
            for (int i = 0; i < certsList.length(); ++i)
            {
                QString rS = s;
                rS = rS.insert(idx, certsList[i]);
                parseTree(rS);
            }
        }
        else
        if (command.contains("<pub_cert_name>"))
        {
            QStringList certsList = values->getPubCerts();
            QString sCommand = command;
            int idx = sCommand.indexOf("<pub_cert_name>");
            QString s = sCommand.remove(idx, 15);
            for (int i = 0; i < certsList.length(); ++i)
            {
                QString rS = s;
                rS = rS.insert(idx, certsList[i]);
                parseTree(rS);
            }
        }
        else
        if (command.contains("<net_name>"))
        {
            QStringList netList = values->getNetworks();
            QString sCommand = command;
            int idx = sCommand.indexOf("<net_name>");
            QString s = sCommand.remove(idx, 10);
            for (int i = 0; i < netList.length(); ++i)
            {
                QString rS = s;
                rS = rS.insert(idx, netList[i]);
                parseTree(rS);
            }
        }
        else
        if (command.contains("<wallet_name>"))
        {
            QStringList walletList = values->getWallets();
            QString sCommand = command;
            int idx = sCommand.indexOf("<wallet_name>");
            QString s = sCommand.remove(idx, 13);
            for (int i = 0; i < walletList.length(); ++i)
            {
                QString rS = s;
                rS = rS.insert(idx, walletList[i]);
                parseTree(rS);
            }
        }
        else
        if (command.contains("<token_ticker>"))
        {
            QStringList tokenList = values->getWallets();
            QString sCommand = command;
            int idx = sCommand.indexOf("<token_ticker>");
            QString s = sCommand.remove(idx, 14);
            for (int i = 0; i < tokenList.length(); ++i)
            {
                QString rS = s;
                rS = rS.insert(idx, tokenList[i]);
                parseTree(rS);
            }
        }
        else
        if (command.contains("<chain name>"))
        {
            QStringList chaintList = values->getAllChains();
            QString sCommand = command;
            int idx = sCommand.indexOf("<chain name>");
            QString s = sCommand.remove(idx, 12);
            for (int i = 0; i < chaintList.length(); ++i)
            {
                QString rS = s;
                rS = rS.insert(idx, chaintList[i]);
                parseTree(rS);
            }
        }
        else return;
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
               // if (_commands[i].contains("-token <"))
                    //qDebug() << "llllllllllllllllllll command:" << _commands[i];

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

    QStringList checkChainList;

    if (list.length() == 1)
    {
        for (int i = 0; i < commands.length(); ++i)
            if (commands[i].startsWith(value))
            {
                map["word"] = QVariant::fromValue(commands[i]);
                checkChainList.append(commands[i]);
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
            checkChainList.append(str);
            if (!value.endsWith(" "))
                value += " ";
            map["str"] = QVariant::fromValue(value + str);
            res.append(map);
        }
    }

    QStringList chainsList = values->getAllChains();
    bool isEqual = false;

    if (checkChainList.length() == chainsList.length() && checkChainList.length() != 0 && value.contains("-net"))
    {
        isEqual = true;
        for (int k = 0; k < checkChainList.length(); ++k)
            if (!checkChainList.contains(chainsList[k]))
                isEqual = false;
    }

    if (isEqual)
    {
        int idx = value.indexOf("-net") + 5;
        while (value[idx] == " ")
            ++idx;

        QString netName = "";
        while (value[idx] != " ")
        {
            netName.push_back(value[idx]);
            ++idx;
        }

        QStringList netChains = values->getChainsByNetwork(netName);
        QVariantList chainsRes;

        for (int k = 0; k < res.length(); ++k)
        {
            if (netChains.contains(res[k].toMap()["word"].toString()))
                chainsRes.append(res[k]);
        }

        return chainsRes;

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

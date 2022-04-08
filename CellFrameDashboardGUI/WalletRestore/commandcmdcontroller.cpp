#include "commandcmdcontroller.h"

CommandCmdController::CommandCmdController(QObject *parent) : QObject(parent)
{
    qDebug() << "lelelelelelelelelele";
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

    qDebug() << "rrrrrrrrrrrrrrrrrr" << command;

    return command;
}

QString leftOrCommand(QString command, int i)
{
    int count = 0;
    int k = i;
    while (true)
    {
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

    qDebug() << "lelelelelelele" << command;

    return command;
}

void CommandCmdController::parseTree(QString command)
{
    if (!command.contains("[") && !command.contains("|"))
    {
        command = command.remove('{');
        command = command.remove('}');
        parsedCommands.append(command);
        qDebug() << "cccccccommand: " << command << "\n";
        return;
    }
    else if (command.contains("|"))
    {
        int count = 0;
        for (int i = 0; i < command.length(); ++i)
        {
            if (command[i] == '|' && count == 0)
            {
                parseTree(leftOrCommand(command, i));
                parseTree(rightOrCommand(command, i));
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
                qDebug() << "pppppppppppppppp " << command;

                QString delCommand = command;
                delCommand = delCommand.remove(leftIndex, i - leftIndex + 1);

                qDebug() << "kkkkkkkkkkkkkkkkk " << command;// << delCommand << leftIndex << i;

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
}

/*



lelelelelelele "wallet {new -w <wallet_name> [-sign <sign_type>] [-restore <hex value>] [-net <net_name>] [-force] }"
kkkkkkkkkkkkkkkkk  "wallet {new -w <wallet_name> ] [-restore <hex value>] [-net <net_name>] [-force] }"                    "wallet {new -w <wallet_name> ] [-restore <hex value>] [-net <net_name>] [-force] }" 29 47





llllllllllllllllllll  "dag -net <chain net name> -chain <chain name> event create -datum <datum hash> [-H {hex | base58(default)}]"
llllllllllllllllllll  "dag -net <chain net name> -chain <chain name> event cancel -event <event hash>"
llllllllllllllllllll  "dag -net <chain net name> -chain <chain name> event sign -event <event hash>"
llllllllllllllllllll  "dag -net <chain net name> -chain <chain name> event dump -event <event hash> -from {events | events_lasts | round.new  | round.<Round id in hex>} [-H {hex | base58(default)}]"
llllllllllllllllllll  "dag -net <chain net name> -chain <chain name> event list -from {events | events_lasts | round.new  | round.<Round id in hex>} "
llllllllllllllllllll  "dag -net <chain net name> -chain <chain name> round complete"

llllllllllllllllllll  "dag_poa -net <chain net name> -chain <chain name> event sign -event <event hash> [-H hex | base58(default)]"
llllllllllllllllllll  "block_poa -net <chain net name> -chain <chain name> block sign [-cert <cert name>] "
llllllllllllllllllll  "n"
llllllllllllllllllll  "net -net <chain net name> get status"
llllllllllllllllllll  "net -net <chain net name> stats tx [-from <From time>] [-to <To time>] [-prev_sec <Seconds>] "
llllllllllllllllllll  "net -net <chain net name> [-mode {update | all}] sync {all | gdb | chains}"
llllllllllllllllllll  "net -net <chain net name> link {list | add | del | info | establish}"
llllllllllllllllllll  "net -net <chain net name> ca add {-cert <cert name> | -hash <cert hash>}"
llllllllllllllllllll  "net -net <chain net name> ca list"
llllllllllllllllllll  "net -net <chain net name> ca del -hash <cert hash> [-H {hex | base58(default)}]"

llllllllllllllllllll  "net -net <chain net name> ledger reload"
llllllllllllllllllll  "net_srv -net <chain net name> order find [-direction {sell | buy}] [-srv_uid <Service UID>] [-price_unit <price unit>]"
llllllllllllllllllll  "net_srv -net <chain net name> order delete -hash <Order hash>"
llllllllllllllllllll  "net_srv -net <chain net name> order dump -hash <Order hash>"
llllllllllllllllllll  "net_srv -net <chain net name> order create -direction {sell | buy} -srv_uid <Service UID> -price <Price>"
llllllllllllllllllll  "srv_xchange price create -net_sell <net name> -token_sell <token ticker> -net_buy <net_name> -token_buy <token ticker>-wallet <name> -coins <value> -rate <value>"
llllllllllllllllllll  "srv_xchange price remove -net_sell <net name> -token_sell <token ticker> -net_buy <net_name> -token_buy <token ticker>"
llllllllllllllllllll  "srv_xchange price list"
llllllllllllllllllll  "srv_xchange price update -net_sell <net name> -token_sell <token ticker> -net_buy <net_name> -token_buy <token ticker>{-coins <value> | rate <value> | -wallet <name>}"
llllllllllllllllllll  "srv_xchange orders -net <net name>"

llllllllllllllllllll  "srv_xchange purchase -order <order hash> -net <net name> -wallet <wallet_name> -coins <value>"
llllllllllllllllllll  "srv_xchange enable"
llllllllllllllllllll  "srv_xchange disable"
llllllllllllllllllll  "srv_stake order create -net <net name> -addr_hldr <addr> -token <ticker> -coins <value> -cert <name> -fee_percent <value>"
llllllllllllllllllll  "s"
llllllllllllllllllll  "srv_stake order remove -net <net name> -order <order hash> [-H {hex | base58(default)}]"
llllllllllllllllllll  "srv_stake order update -net <net name> -order <order hash> {-cert <name> | -wallet <name>} [-H <hex | base58(default)>]{[-addr_hldr <addr>] [-token <ticker>] [-coins <value>] [-fee_percent <value>] | [-token <ticker>] [-coins <value>] [-fee_percent <value>]}"
llllllllllllllllllll  "srv_stake order list -net <net name>"
llllllllllllllllllll  "srv_stake delegate -order <order hash> -net <net name> -wallet <name> -fee_addr <addr>"
llllllllllllllllllll  "srv_stake approve -net <net name> -tx <transaction hash> -cert <root cert name>"

llllllllllllllllllll  "srv_stake invalidate -net <net name> -tx <transaction hash> -wallet <wallet name>"
llllllllllllllllllll  "global_db cells add -cell <cell id> "
llllllllllllllllllll  "global_db flush "
llllllllllllllllllll  "node add  -net <net name> {-addr <node address> | -alias <node alias>} -port <port> -cell <cell id>  {-ipv4 <ipv4 external address> | -ipv6 <ipv6 external address>}"
llllllllllllllllllll  "node del  -net <net name> {-addr <node address> | -alias <node alias>}"
llllllllllllllllllll  "node link {add | del}  -net <net name> {-addr <node address> | -alias <node alias>} -link <node address>"
llllllllllllllllllll  "node alias -addr <node address> -alias <node alias>"
llllllllllllllllllll  "node connect {<node address> | -alias <node alias> | auto}"
llllllllllllllllllll  "node handshake {<node address> | -alias <node alias>}"
llllllllllllllllllll  "node dump -net <net name> [ -addr <node address> | -alias <node alias>] [-full]"

llllllllllllllllllll  "ping [-c <count>] host"
llllllllllllllllllll  "traceroute host"
llllllllllllllllllll  "tracepath host"
llllllllllllllllllll  "version"
llllllllllllllllllll  "help [<command>]"
llllllllllllllllllll  "wallet {new -w <wallet_name> [-sign <sign_type>] [-restore <hex value>] [-net <net_name>] [-force] | list | info -addr <addr> -w <wallet_name> -net <net_name>}"
llllllllllllllllllll  "token_decl_sign -net <net name> -chain <chain name> -datum <datum_hash> -certs <certs list>"
llllllllllllllllllll  "token_emit -net <net name> -chain_emission <chain for emission> -chain_base_tx <chain for base tx> -addr <addr> -token <token ticker> -certs <cert> -emission_value <val>"
llllllllllllllllllll  "mempool_list -net <net name>"
llllllllllllllllllll  "mempool_proc -net <net name> -datum <datum hash>"

llllllllllllllllllll  "mempool_delete -net <net name> -datum <datum hash>"
llllllllllllllllllll  "mempool_add_ca -net <net name> [-chain <chain name>] -ca_name <Certificate name>"
llllllllllllllllllll  "chain_ca -net <net name> [-chain <chain name>] -ca_name <Certificate name>"
llllllllllllllllllll  "chain_ca -net <net name> [-chain <chain name>] -ca_name <Public certificate name>"
llllllllllllllllllll  "tx_create -net <net name> -chain <chain name> -from_wallet <name> -to_addr <addr> -token <token ticker> -value <value> [-fee <addr> -value_fee <val>]"
llllllllllllllllllll  "tx_cond_create -net <net name> -token <token ticker> -wallet <from wallet> -cert <public cert>-value <value datoshi> -unit {mb | kb | b | sec | day} -srv_uid <numeric uid>"
llllllllllllllllllll  "tx_verify -net <net name> -chain <chain name> -tx <tx_hash>"
llllllllllllllllllll  "tx_history  [-addr <addr> | -w <wallet name> | -tx <tx_hash>] -net <net name> -chain <chain name>"
llllllllllllllllllll  "ledger list coins -net <network name>"
llllllllllllllllllll  "ledger list coins_cond -net <network name>"

llllllllllllllllllll  "ledger list addrs -net <network name>"
llllllllllllllllllll  "ledger tx [all | -addr <addr> | -w <wallet name> | -tx <tx_hash>] [-chain <chain name>] -net <network name>"
llllllllllllllllllll  "token list -net <network name>"
llllllllllllllllllll  "token info -net <network name> -name <token name>"
llllllllllllllllllll  "token tx [all | -addr <wallet_addr> | -wallet <wallet_name>] -name <token name> -net <network name> [-page_start <page>] [-page <page>]"
llllllllllllllllllll  "print_log [ts_after <timestamp >] [limit <line numbers>]"
llllllllllllllllllll  "stats cpu"
llllllllllllllllllll  "exit"
llllllllllllllllllll  "gdb_export filename <filename without extension>"
llllllllllllllllllll  "gdb_import filename <filename without extension>"






wallet list -------- OK
wallet info -addr <addr> -w <wallet_name> -net <net_name> -------- OK
wallet new -w <wallet_name> -sign <sign_type> -restore <hex value> -net <net_name> -force -------- OK
wallet new -w <wallet_name> -sign <sign_type> -restore <hex value> -net <net_name> -------- OK
wallet new -w <wallet_name> -sign <sign_type> -restore <hex value> -force -------- OK
wallet new -w <wallet_name> -sign <sign_type> -restore <hex value> -------- OK
wallet new -w <wallet_name> -sign <sign_type> -net <net_name> -force -------- OK
wallet new -w <wallet_name> -sign <sign_type> -net <net_name> -------- OK
wallet new -w <wallet_name> -sign <sign_type> -force -------- OK
wallet new -w <wallet_name> -sign <sign_type> -------- OK
wallet new -w <wallet_name> -restore <hex value> -net <net_name> -force -------- OK
wallet new -w <wallet_name> -restore <hex value> -net <net_name> -------- OK
wallet new -w <wallet_name> -restore <hex value> -force -------- OK
wallet new -w <wallet_name> -restore <hex value> -------- OK
wallet new -w <wallet_name> -net <net_name> -force -------- OK
wallet new -w <wallet_name> -net <net_name> -------- OK
wallet new -w <wallet_name> -force -------- OK
wallet new -w <wallet_name> -------- OK



cccccccommand:  "wallet new -w <wallet_name>     "
cccccccommand:  "wallet new -w <wallet_name>    -force "
cccccccommand:  "wallet new -w <wallet_name>   -net <net_name>  "
cccccccommand:  "wallet new -w <wallet_name>   -net <net_name> -force "
cccccccommand:  "wallet new -w <wallet_name>  -restore <hex value>   "
cccccccommand:  "wallet new -w <wallet_name>  -restore <hex value>  -force "
cccccccommand:  "wallet new -w <wallet_name>  -restore <hex value> -net <net_name>  "
cccccccommand:  "wallet new -w <wallet_name>  -restore <hex value> -net <net_name> -force "
cccccccommand:  "wallet new -w <wallet_name> -sign <sign_type>    "
cccccccommand:  "wallet new -w <wallet_name> -sign <sign_type>   -force "
cccccccommand:  "wallet new -w <wallet_name> -sign <sign_type>  -net <net_name>  "
cccccccommand:  "wallet new -w <wallet_name> -sign <sign_type>  -net <net_name> -force "
cccccccommand:  "wallet new -w <wallet_name> -sign <sign_type> -restore <hex value>   "
cccccccommand:  "wallet new -w <wallet_name> -sign <sign_type> -restore <hex value>  -force "
cccccccommand:  "wallet new -w <wallet_name> -sign <sign_type> -restore <hex value> -net <net_name>  "
cccccccommand:  "wallet new -w <wallet_name> -sign <sign_type> -restore <hex value> -net <net_name> -force "
cccccccommand:  "wallet  list "
cccccccommand:  "wallet  info -addr <addr> -w <wallet_name> -net <net_name>"






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
            if (_commands[i].contains("\t"))
                _commands[i] = _commands[i].left(_commands[i].count('\t'));

            if (_commands[i].contains("\r"))
                _commands[i] = _commands[i].left(_commands[i].count('\r'));

            commandParams.append(_commands[i]);
            parseTree(_commands[i]);
            qDebug() << "llllllllllllllllllll " << _commands[i];
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

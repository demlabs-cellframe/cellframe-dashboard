#include "commandcmdcontroller.h"
#include <QFile>

#ifdef Q_OS_WIN
#include "registry.h"
#define PUB_CERT_PATH QString("%1/cellframe-node/var/lib/ca").arg(regGetUsrPath())
#define PRIV_CERT_PATH QString("%1/cellframe-node/share/ca").arg(regGetUsrPath())
#endif

#ifdef Q_OS_MAC
#define PUB_CERT_PATH QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/share/ca/").arg(getenv("USER"))
#define PRIV_CERT_PATH QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/var/lib/ca/").arg(getenv("USER"))
#endif

#ifdef Q_OS_LINUX
#define PUB_CERT_PATH QString("/opt/cellframe-node/var/lib/ca")
#define PRIV_CERT_PATH QString("/opt/cellframe-node/share/ca")
#endif

CommandCmdController::CommandCmdController(QObject *parent) : QObject(parent)
{
    QDir pubDir(PUB_CERT_PATH);
    QStringList files = pubDir.entryList();
    for (int i = 0; i < files.length(); ++i)
    {
        QString s = files[i].remove(".dcert");
        if (s != "." && s != "..")
            certNames.append(s);
    }

    QDir privDir(PRIV_CERT_PATH);
    files = privDir.entryList();
    for (int i = 0; i < files.length(); ++i)
    {
        QString s = files[i].remove(".dcert");
        if (s != "." && s != "..")
            certNames.append(s);
    }
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
    return command;
}

void CommandCmdController::parseTree(QString command)
{
    //qDebug() << "cccccccccccccommand: " << command;
    if (!command.contains("[") && !command.contains("|"))
    {
        command = command.remove('{');
        command = command.remove('}');

       // qDebug() << "cocococommand" << command << (!command.contains(" ") || (command.count(" ") == 1 && command.endsWith(" ")));
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

        //qDebug() << "cccccccccccccommand||||||||||: " << command;
        //int count = 0;
        for (int i = 0; i < command.length(); ++i)
        {
            if (command[i] == '|'/* && count == 0*/)
            {
                parseTree(leftOrCommand(command, i));
                parseTree(rightOrCommand(command, i));
            }

           /* if (command[i] == '[')
                ++count;

            if (command[i] == ']')
                --count;*/
        }
    }
    else if (command.contains("[") || command.contains("]"))
    {
        //qDebug() << "cccccccccccccommand[[[[[[[[[[: " << command;
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
        return;
}

/*


  <chain net name>
  <chain name>
  <datum hash>
  <event hash>
  <Round id in hex>
  <cert name>
  <From time>
  <To time>
  <Seconds>
  <cert hash>
  <Service UID>
  <price unit>
  <Order hash>
  <Price>
  <net name>
  <token ticker>
  <wallet_name>
  <coins value>
  <rate value>
  <addr_hldr>
  <fee_percent value>
  <fee_addr>
  <transaction hash>
  <root cert name>
  <addr from>
  <cell id>
  <filename>
  <SIGNER_FILENAME,SIGNER_FILENAME_SHORT,SIGNER_FILESIZE,SIGNER_DATE,SIGNER_MIME_MAGIC>
  <hash>
  <node address>
  <node alias>
  <port>
  <ipv4 external address>
  <ipv6 external address>
  <count>
  <command>
  <sign_type>
  <hex value>
  <addr>
  <certs list>
  <emission_value>
  <chain for emission>
  <chain for base tx>
  <Public certificate name>
  <emission_hash>
  <value datoshi>
  <numeric uid>
  <tx_hash>
  <tx_treshold_hash>
  <token name>
  <wallet_addr>
  <page_start>
  <page>
  <timestamp >
  <line numbers>



    "dag -net event create <chain net name> -chain <chain name> -datum <datum hash> [-H {hex | base58(default)}]"
    "dag event cancel -net <chain net name> -chain <chain name> -event <event hash>"
    "dag event sign -net <chain net name> -chain <chain name> -event <event hash>"
    "dag event dump -net <chain net name> -chain <chain name> -event <event hash> -from {events | events_lasts | round.new  | round.<Round id in hex>} [-H {hex | base58(default)}]"
    "dag event list -net <chain net name> -chain <chain name> -from {events | events_lasts | threshold | round.new | round.<Round id in hex>}"
    "dag round complete -net <chain net name> -chain <chain name>"
    "dag_poa event sign -net <chain net name> -chain <chain name> -event <event hash> [-H {hex | base58(default)}]"
    "block_poa -net <chain net name> -chain <chain name> block sign [-cert <cert name>]"
    "net -net <chain net name> get status"
    "net -net <chain net name> stats tx [-from <From time>] [-to <To time>] [-prev_sec <Seconds>] "
    "net -net <chain net name> [-mode {update | all}] sync {all | gdb | chains}"
    "net -net <chain net name> link {list | add | del | info | establish}"
    "net -net <chain net name> ca add {-cert <cert name> | -hash <cert hash>}"
    "net -net <chain net name> ca list"
    "net -net <chain net name> ca del -hash <cert hash> [-H {hex | base58(default)}]"
    "net -net <chain net name> ledger reload"
    "net_srv -net <chain net name> order find [-direction {sell | buy}] [-srv_uid <Service UID>] [-price_unit <price unit>]"
    "net_srv -net <chain net name> order delete -hash <Order hash>"
    "net_srv -net <chain net name> order dump -hash <Order hash>"
    "net_srv -net <chain net name> order create -direction {sell | buy} -srv_uid <Service UID> -price <Price>"
    "srv_xchange price create -net_sell <net name> -token_sell <token ticker> -net_buy <net_name> -token_buy <token ticker> -wallet <name> -coins <value> -rate <value>"
    "srv_xchange price remove -net_sell <net name> -token_sell <token ticker> -net_buy <net_name> -token_buy <token ticker>"
    "srv_xchange price list"
    "srv_xchange price update -net_sell <net name> -token_sell <token ticker> -net_buy <net_name> -token_buy <token ticker> {-coins <value> | rate <value> | -wallet <name>}"
    "srv_xchange orders -net <net name>"
    "srv_xchange purchase -order <order hash> -net <net name> -wallet <wallet_name> -coins <value>"
    "srv_xchange enable"
    "srv_xchange disable"
    "srv_stake order create -net <net name> -addr_hldr <addr> -token <ticker> -coins <value> -cert <name> -fee_percent <value>"
    "srv_stake order remove -net <net name> -order <order hash> [-H {hex | base58(default)}]"
    "srv_stake order update -net <net name> -order <order hash> {-cert <name> | -wallet <name>} [-H {hex | base58(default)}]{[-addr_hldr <addr>] [-token <ticker>] [-coins <value>] [-fee_percent <value>] | [-token <ticker>] [-coins <value>] -fee_percent <value>]}"
    "srv_stake order list -net <net name>"
    "srv_stake delegate -order <order hash> -net <net name> -wallet <name> -fee_addr <addr>"
    "srv_stake approve -net <net name> -tx <transaction hash> -cert <root cert name>"
    "srv_stake transactions -net <net name> [-addr <addr from>]"
    "srv_stake invalidate -net <net name> -tx <transaction hash> -wallet <wallet name>"
    "srv_datum -net <chain net name> -chain <chain name> datum save -datum <datum hash>"
    "srv_datum -net <chain net name> -chain <chain name> datum load -datum <datum hash>"
    "global_db cells add -cell <cell id>"
    "global_db flush"
    "mempool sign -cert <cert name> -net <net name> -chain <chain name> -file <filename> [-mime {<SIGNER_FILENAME,SIGNER_FILENAME_SHORT,SIGNER_FILESIZE,SIGNER_DATE,SIGNER_MIME_MAGIC> | <SIGNER_ALL_FLAGS>}]"
    "mempool check -cert <cert name> -net <net name> {-file <filename> | -hash <hash>} [-mime {<SIGNER_FILENAME,SIGNER_FILENAME_SHORT,SIGNER_FILESIZE,SIGNER_DATE,SIGNER_MIME_MAGIC> | <SIGNER_ALL_FLAGS>}]"
    "node add  -net <net name> -addr {<node address> | -alias <node alias>} -port <port> -cell <cell id>  {-ipv4 <ipv4 external address> | -ipv6 <ipv6 external address>}"
    "node del -net <net name> {-addr <node address> | -alias <node alias>}"
    "node link {add | del}  -net <net name> {-addr <node address> | -alias <node alias>} -link <node address>"
    "node alias -addr <node address> -alias <node alias>"
    "node connect -net <net name> {-addr <node address> | -alias <node alias> | auto}"
    "node handshake -net <net name> {-addr <node address> | -alias <node alias>}"
    "node dump -net <net name> [ -addr <node address> | -alias <node alias>] [-full]"
    "ping [-c <count>] host"
    "traceroute host"
    "tracepath host"
    "version"
    "help [<command>]"
    "wallet [new -w <wallet_name> [-sign <sign_type>] [-restore <hex value>] [-net <net_name>] [-force]| list | info -addr <addr> -w <wallet_name> -net <net_name>]"
    "token_decl_sign -net <net name> -chain <chain name> -datum <datum_hash> -certs <certs list>"
    "token_emit {sign | -token <token ticker> -emission_value <val>} -net <net name> [-chain_emission <chain for emission>] [-chain_base_tx <chain for base tx> -addr <addr>] -certs <cert list>"
    "mempool_list -net <net name>"
    "mempool_proc -net <net name> -datum <datum hash>"
    "mempool_delete -net <net name> -datum <datum hash>"
    "mempool_add_ca -net <net name> [-chain <chain name>] -ca_name <Certificate name>"
    "chain_ca -net <net name> [-chain <chain name>] -ca_name <Certificate name>"
    "chain_ca -net <net name> [-chain <chain name>] -ca_name <Public certificate name>"
    "tx_create -net <net name> -chain <chain name> {-from_wallet <name> -token <token ticker> -value <value> -to_addr <addr> | -from_emission <emission_hash>}[-fee <addr> -value_fee <val>]"
    "tx_cond_create -net <net name> -token <token ticker> -wallet <from wallet> -cert <public cert> -value <value datoshi> -unit {mb | kb | b | sec | day} -srv_uid <numeric uid>"
    "tx_verify -net <net name> -chain <chain name> -tx <tx_hash>"
    "tx_history  [-addr <addr> | -w <wallet name> | -tx <tx_hash>] -net <net name> -chain <chain name>"
    "ledger list coins -net <network name>"
    "ledger list threshold [-hash <tx_treshold_hash>] -net <network name>"
    "ledger list balance -net <network name>"
    "ledger info -hash <tx_hash> -net <network name> [-unspent]"
    "ledger tx -all -net <network name>"
    "ledger tx [-addr <addr> | -w <wallet name> | -tx <tx_hash>] [-chain <chain name>] -net <network name>"
    "token list -net <network name>"
    "token info -net <network name> -name <token name>"
    "token tx [all | -addr <wallet_addr> | -wallet <wallet_name>] -name <token name> -net <network name> [-page_start <page>] [-page <page>]"
    "print_log [ts_after <timestamp >] [limit <line numbers>]"
    "exit"


*/

void CommandCmdController::parseAllCommandsParams(const QVariant &asAnswer)
{
    QString command = asAnswer.toList()[0].toString();
    command = command.right(command.length() - 5);

    QString str = asAnswer.toList()[1].toString();

    qDebug() << "help output1" << str;

    str = str.right(str.size());

    qDebug() << "help output2" << str;

    QStringList _commands = str.split("\n");

    for (int i = 1; i < _commands.length(); ++i)
    {
        qDebug() << "help output3" << _commands[i];
        if (!_commands[i].startsWith("\t") && _commands[i] != "" && _commands[i] != "\r" && _commands[i][0].isLower() && _commands[i] != "s" && _commands[i] != "g" && _commands[i] != "n")
        {
            if (_commands[i].contains("\t"))
                _commands[i] = _commands[i].left(_commands[i].count('\t'));

            if (_commands[i].contains("\r"))
                _commands[i] = _commands[i].left(_commands[i].count('\r'));
            {


                qDebug() << "command:" << _commands[i];

                parsedCommands.clear();
                parseTree(_commands[i]);
                parsedCommands.removeDuplicates();

                QStringList list = commandsParams[command].toStringList();
                list.append(parsedCommands);
                //qDebug() << "parsedCommands" << command << parsedCommands;
                commandsParams[command] = QVariant::fromValue(list);
            }

        }
    }
    isFirstInit = false;
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

    //qDebug() << "command list" << val << count << list;

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

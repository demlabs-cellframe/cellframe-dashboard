#include "DapChainWalletHandler.h"
#include <QDebug>

DapChainWalletHandler::DapChainWalletHandler(QObject *parent) : QObject(parent)
{

}

QString DapChainWalletHandler::parse(const QByteArray &aWalletAddress)
{
    qDebug() << aWalletAddress;
    QStringList result = QString::fromLatin1(aWalletAddress).split(" ");
    return result.at(result.size()-1).trimmed();
}

QStringList DapChainWalletHandler::createWallet(const QString &asNameWallet)
{
    QByteArray result;
    QProcess process;
    process.start(QString("%1 wallet new -w %2").arg(CLI_PATH).arg(asNameWallet));
    process.waitForFinished(-1);
    result = process.readAll();
    QStringList list;
    list.append(asNameWallet);
    list.append(parse(result));
    return result.isEmpty() ? QStringList() : list;
}

void DapChainWalletHandler::removeWallet(const QString &asNameWallet)
{
    QByteArray result;
    QProcess process;
    process.start(QString("rm %1%2.dwallet").arg("/opt/kelvin-node/var/lib/wallet/").arg(asNameWallet));
    qDebug() << (QString("rm %1%2.dwallet").arg("/opt/kelvin-node/var/lib/wallet/").arg(asNameWallet));
    process.waitForFinished(-1);
    result = process.readAll();
}

QMap<QString, QVariant> DapChainWalletHandler::getWallets()
{
    QMap<QString, QVariant> map;
    QProcess process;
    process.start(QString("%1 wallet list").arg(CLI_PATH));
    process.waitForFinished(-1);
    QString str = QString::fromLatin1(process.readAll());
    qDebug() << "ZDES`" << str;
    QRegExp rx(":{1,1}([\\s\\w\\W]+)(\\n|\\r){1,1}" );
    rx.setMinimal(true);
    int pos = 0;
    int x {0};
    QString tempName;
    while ((pos = rx.indexIn(str, pos)) != -1)
    {
        if(x == 0)
        {
            tempName = rx.cap(1);
            ++x;
        }
        else
        {
            map.insert(tempName, rx.cap(1));
            x = 0;
        }
        pos += rx.matchedLength();
    }

    return map;
}

QStringList DapChainWalletHandler::getWalletInfo(const QString &asNameWallet)
{
    QProcess process;
    process.start(QString("%1 wallet info -w %2 -net kelvin-testnet").arg(CLI_PATH).arg(asNameWallet));
    process.waitForFinished(-1);
    char* response = process.readAll().data();
    //qDebug() << response;
    QStringList list;
#ifdef Q_OS_WIN32
    char *context = nullptr;
    char *data = nullptr;
    data = strtok_r(response, ":", &context);
    if (strcmp(data, "wallet") != 0) {
        data = strtok_r(response, ":", &context);
    }
    data = strtok_r(context+1, "\r", &context);
    list.append(QString(data));
    data = strtok_r(context+1, ":", &context);
    data = strtok_r(context+1, "\r", &context);
    list.append(QString(data));
    data = strtok_r(context+1, ":", &context);
    list.append(QString(data));
    data = strtok_r(context+4, "\r", &context);

    char *subctx;
    char *subdata;
    if (strlen(data) > 2) {
        subdata = strtok_r(data+1, " ", &subctx);
    } else {
        subdata = strtok_r(data, " ", &subctx);
    }
    list.append(QString(subdata));
    subdata = strtok_r(subctx, " ", &subctx);
    list.append(QString(subdata));
    subdata = strtok_r(subctx, "\r", &subctx);
    list.append(QString(subdata));
#else
    QString str = QString::fromLatin1(process.readAll()).replace("\\", "\\\\");

    QRegExp rx("[(:\\)\\t]{1,1}([^\\\\\\n\\t]+)[\\\\(|\\n|\\r]{1,1}");
    rx.setMinimal(true);

    int pos{0};
    while((pos = rx.indexIn(str, pos)) != -1)
    {
        list.append(rx.cap(1));
        pos += rx.matchedLength();
    }
#endif
    qDebug() << list;
    return list;
}

QString DapChainWalletHandler::sendToken(const QString &asSendWallet, const QString &asAddressReceiver, const QString &asToken, const QString &aAmount)
{
    QString answer;
    qInfo() << QString("sendTokenTest(%1, %2, %3, %4)").arg(asSendWallet).arg(asAddressReceiver).arg(asToken).arg(aAmount);
    QProcess processCreate;
    processCreate.start(QString("%1 tx_create -net kelvin-testnet -chain gdb -from_wallet %2 -to_addr %3 -token %4 -value %5")
                  .arg(CLI_PATH)
                  .arg(asSendWallet)
                  .arg(asAddressReceiver)
                  .arg(asToken)
                  .arg(aAmount));
    processCreate.waitForFinished(-1);
    QString resultCreate = QString::fromLatin1(processCreate.readAll());
    qDebug() << resultCreate;
    if(!(resultCreate.isEmpty() || resultCreate.isNull()))
    {
        QProcess processMempool;
        processMempool.start(QString("%1 mempool_proc -net kelvin-testnet -chain gdb").arg(CLI_PATH));
        processMempool.waitForFinished(-1);
        answer = QString::fromLatin1(processMempool.readAll());
        qDebug() << answer;
    }
    return answer;
}

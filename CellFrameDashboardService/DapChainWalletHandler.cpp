#include "DapChainWalletHandler.h"
#include <QDebug>
#include <QRegularExpression>

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
    process.start(QString("rm %1%2.dwallet").arg("/opt/cellframe-node/var/lib/wallet/").arg(asNameWallet));
    qDebug() << (QString("rm %1%2.dwallet").arg("/opt/cellframe-node/var/lib/wallet/").arg(asNameWallet));
    process.waitForFinished(-1);
    result = process.readAll();
}

QMap<QString, QVariant> DapChainWalletHandler::getWallets()
{
    QMap<QString, QVariant> map;
    QProcess process;
    process.start(QString("%1 wallet list").arg(CLI_PATH));
    process.waitForFinished(-1);
    QByteArray result = process.readAll();
    QRegularExpression rx("wallet:\\s(.+)\\s+addr:\\s(.+)", QRegularExpression::MultilineOption);
    QRegularExpressionMatchIterator itr = rx.globalMatch(result);
    while (itr.hasNext()) {
        QRegularExpressionMatch match = itr.next();
        map[match.captured(1)] = match.captured(2);
    }


//    QString str = QString::fromLatin1(process.readAll());
//    QRegExp rx(":{1,1}([\\s\\w\\W]+)(\\n|\\r){1,1}" );
//    rx.setMinimal(true);
//    int pos = 0;
//    int x {0};
//    QString tempName;
//    while ((pos = rx.indexIn(str, pos)) != -1)
//    {
//        if(x == 0)
//        {
//            tempName = rx.cap(1);
//            ++x;
//        }
//        else
//        {
//            map.insert(tempName, rx.cap(1));
//            x = 0;
//        }
//        pos += rx.matchedLength();
//    }

    return map;
}

QStringList DapChainWalletHandler::getWalletInfo(const QString &asNameWallet)
{
    QProcess process;
    process.start(QString("%1 wallet info -w %2 -net private").arg(CLI_PATH).arg(asNameWallet));
    process.waitForFinished(-1);
    QByteArray result = process.readAll();
    QRegExp rx("wallet: (.+)\\s+addr:\\s+(\\w+)\\s+(balance)|(\\d+.\\d+)\\s(\\(\\d+\\))\\s(\\w+)");
    QStringList list;

    int pos = 0;
    while((pos = rx.indexIn(result, pos)) != -1)
    {
        if(rx.cap(1).isEmpty())
            list << rx.cap(4) << rx.cap(5) << rx.cap(6);
        else
            list << rx.cap(1) << rx.cap(2) << rx.cap(3);

        pos += rx.matchedLength();
    }

    return list;
}

QString DapChainWalletHandler::sendToken(const QString &asSendWallet, const QString &asAddressReceiver, const QString &asToken, const QString &aAmount)
{
    QString answer;
    qInfo() << QString("sendTokenTest(%1, %2, %3, %4)").arg(asSendWallet).arg(asAddressReceiver).arg(asToken).arg(aAmount);
    QProcess processCreate;
    processCreate.start(QString("%1 tx_create -net %2 -chain gdb -from_wallet %3 -to_addr %4 -token %5 -value %6")
                  .arg(CLI_PATH)
                  .arg(m_CurrentNetwork)
                  .arg(asSendWallet)
                  .arg(asAddressReceiver)
                  .arg(asToken)
                  .arg(aAmount) );
    processCreate.waitForFinished(-1);
    QString resultCreate = QString::fromLatin1(processCreate.readAll());
    qDebug() << resultCreate;
    if(!(resultCreate.isEmpty() || resultCreate.isNull()))
    {
        QProcess processMempool;
        processMempool.start(QString("%1 mempool_proc -net " + m_CurrentNetwork +" -chain gdb").arg(CLI_PATH));
        processMempool.waitForFinished(-1);
        answer = QString::fromLatin1(processMempool.readAll());
        qDebug() << answer;
    }
    return answer;
}

void DapChainWalletHandler::setCurrentNetwork(const QString& aNetwork)
{
    if(m_CurrentNetwork != aNetwork) return;
    m_CurrentNetwork = aNetwork;
}

#include "DapChainWalletHandler.h"
#include <QDebug>
#include <QRegularExpression>

DapChainWalletHandler::DapChainWalletHandler(QObject *parent) : QObject(parent)
{
    m_timeout = new QTimer(this);
    QObject::connect(m_timeout, &QTimer::timeout, this, &DapChainWalletHandler::onReadWallet);
    m_timeout->setInterval(5000);
    m_timeout->start();
}

bool DapChainWalletHandler::appendWallet(const QString& aWalletName)
{
    QProcess process;
    process.start(QString("%1 wallet new -w %2").arg(CLI_PATH).arg(aWalletName));
    process.waitForFinished(-1);
    QByteArray result = process.readAll();

    QRegExp rx("new address\\s(\\w+)");
    return rx.indexIn(result, 0);
}

bool DapChainWalletHandler::createTransaction(const QString& aFromAddress, const QString& aToAddress, const QString& aTokenName, const QString& aNetwork, const quint64 aValue) const
{
    QString fromWalletName;
    for(int i = 0; i < m_walletList.count(); i++)
    {
        if(m_walletList[i].first.Address == aFromAddress)
            fromWalletName = m_walletList[i].first.Name;
    }

    if(fromWalletName.isEmpty() || !m_networkList.contains(aNetwork)) return false;
    QProcess processCreate;
    processCreate.start(QString("%1 tx_create -net %2 -chain gdb -from_wallet %3 -to_addr %4 -token %5 -value %6")
                  .arg(CLI_PATH)
                  .arg(aNetwork)
                  .arg(fromWalletName)
                  .arg(aToAddress)
                  .arg(aTokenName)
                  .arg(QString::number(aValue)));
    processCreate.waitForFinished(-1);
    QByteArray result = processCreate.readAll();
    QRegExp rx("transfer=(\\w+)");
    rx.indexIn(result, 0);

    if(rx.cap(1) == "Ok") {

        QProcess processMempool;
        processMempool.start(QString("%1 mempool_proc -net " + aNetwork +" -chain gdb").arg(CLI_PATH));
        processMempool.waitForFinished(-1);
        processMempool.readAll();
        return true;
    }

    return false;
}

QByteArray DapChainWalletHandler::walletData() const
{
    QByteArray data;
    QDataStream out(&data, QIODevice::WriteOnly);
    out << m_walletList;

    return data;
}

void DapChainWalletHandler::onReadWallet()
{
    QList<QPair<DapChainWalletData, QList<DapChainWalletTokenData>>> walletList;

    QProcess process;
    process.start(QString("%1 wallet list").arg(CLI_PATH));
    process.waitForFinished(-1);
    QByteArray result = process.readAll();
    QRegularExpression rx("wallet:\\s(.+)\\s+addr:\\s(.+)", QRegularExpression::MultilineOption);
    QRegularExpressionMatchIterator itr = rx.globalMatch(result);
    while (itr.hasNext())
    {
        QRegularExpressionMatch match = itr.next();
        QString walletName = match.captured(1);

        for(int i = 0; i < m_networkList.count(); i++)
        {
            DapChainWalletData wallet;
            wallet.Name = walletName;
            wallet.Network = m_networkList.at(i);
            QPair<DapChainWalletData, QList<DapChainWalletTokenData>> walletPair(wallet, QList<DapChainWalletTokenData>());

            QProcess process_token;
            process_token.start(QString("%1 wallet info -w %2 -net %3")
                                .arg(CLI_PATH)
                                .arg(walletName)
                                .arg(m_networkList.at(i)));

            process_token.waitForFinished(-1);
            QByteArray result_tokens = process_token.readAll();
            QRegExp regex("wallet: (.+)\\s+addr:\\s+(.+)\\s+(balance)|(\\d+.\\d+)\\s\\((\\d+)\\)\\s(\\w+)");

            int pos = 0;
            while((pos = regex.indexIn(result_tokens, pos)) != -1)
            {
                DapChainWalletTokenData token;
                if(!regex.cap(2).isEmpty())
                {
                    walletPair.first.Address = regex.cap(2);
                }
                else
                {
                    token.Balance = regex.cap(4).toDouble();
                    token.Emission = regex.cap(5).toUInt();
                    token.Name = regex.cap(6);
                    walletPair.second.append(token);
                }

                pos += regex.matchedLength();
            }

            walletList.append(walletPair);
        }

    }

    if(m_walletList != walletList)
    {
        m_walletList = walletList;
        emit walletDataChanged(walletData());
    }
}

void DapChainWalletHandler::setNetworkList(const QStringList& aNetworkList)
{
    if(m_networkList == aNetworkList) return;
    m_networkList = aNetworkList;
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

#include "DapGetListWalletsCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
/// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
DapGetListWalletsCommand::DapGetListWalletsCommand(const QString &asServicename, QObject *parent)
    : DapAbstractCommand(asServicename, parent)
{

}

/// Send a response to the client.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
/// @return Reply to client.
QVariant DapGetListWalletsCommand::respondToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                              const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                              const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                              const QVariant &arg10)
{
    Q_UNUSED(arg1)
    Q_UNUSED(arg2)
    Q_UNUSED(arg3)
    Q_UNUSED(arg4)
    Q_UNUSED(arg5)
    Q_UNUSED(arg6)
    Q_UNUSED(arg7)
    Q_UNUSED(arg8)
    Q_UNUSED(arg9)
    Q_UNUSED(arg10)

    DapWallet wallet;
    wallet.setName("MyWallet5");
    wallet.addNetwork("Kelvin-testnet");
    wallet.addNetwork("Private");
    wallet.addAddress("ar4th4t4j6tyj7utjk45u654kuj4kl6ui4l54k5lu5u4il5i34l35", "Kelvin-testnet");
    wallet.addAddress("ar4th4t4j6tyj7utjk45u654kuj4kl6ui4l54k5lu5u4il5i34l35", "Private");
    DapWalletToken token1("KLV", &wallet);
    token1.setBalance(5.5);
    token1.setNetwork("Kelvin-testnet");
    token1.setEmission(464645646546);
    DapWalletToken token2("CELL", &wallet);
    token2.setBalance(100);
    token2.setNetwork("Private");
    token2.setEmission(121212121);
    wallet.addToken(&token1);
    wallet.addToken(&token2);

    QByteArray datas;
    QDataStream out(&datas, QIODevice::WriteOnly);
    out << wallet;
//    std::string s = datas.toStdString();
//    QString str = QString::fromStdString(s);

//    DapWallet w;
//    QByteArray d;
//    QDataStream in(&datas, QIODevice::ReadOnly);
//    in>>w;

    return QVariant(QString::fromStdString(datas.toStdString()));
//    QList<DapWallet> wallets;

//    QStringList list = arg1.toStringList();
//    QProcess process;
//    process.start(QString("%1 wallet list").arg(CLI_PATH));
//    process.waitForFinished(-1);
//    QString res = QString::fromLatin1(process.readAll());
//    QRegularExpression rx("wallet:\\s(.+)\\s", QRegularExpression::MultilineOption);
//    QRegularExpressionMatchIterator itr = rx.globalMatch(res);
//    while (itr.hasNext())
//    {
//        QRegularExpressionMatch match = itr.next();
//        QString walletName = match.captured(1);

//        auto begin = list.begin();
//        auto end = list.end();
//        for(; begin != end; ++begin)
//        {
//            DapWallet wallet (walletName);
//            wallet.addNetwork(*begin);

//            QProcess process_token;
//            process_token.start(QString("%1 wallet info -w %2 -net %3")
//                                .arg(CLI_PATH)
//                                .arg(walletName)
//                                .arg(*begin));

//            process_token.waitForFinished(-1);
//            QByteArray result_tokens = process_token.readAll();
//            QRegExp regex("wallet: (.+)\\s+addr:\\s+(.+)\\s+(balance)|(\\d+.\\d+)\\s\\((\\d+)\\)\\s(\\w+)");

//            int pos = 0;
//            while((pos = regex.indexIn(result_tokens, pos)) != -1)
//            {
//                DapWalletToken token;
//                if(!regex.cap(2).isEmpty())
//                {
//                    wallet.setAddress(regex.cap(2), *begin);
//                }
//                else
//                {

//                    token.setName(regex.cap(6));
//                    token.setBalance(regex.cap(4).toDouble());
//                    token.setEmission(regex.cap(5).toUInt());
//                    token.setNetwork(*begin);
//                }
//                pos += regex.matchedLength();
//            }
//            wallets.append(wallet);
//        }
//    }
//    if(m_walletList != walletList)
//    {
//        m_walletList = walletList;
//        emit walletDataChanged(walletData());
//    }
//    return QVariant();
}

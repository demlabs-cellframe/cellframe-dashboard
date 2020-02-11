#include "DapGetListWalletsCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
/// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
/// @param asCliPath The path to cli nodes.
DapGetListWalletsCommand::DapGetListWalletsCommand(const QString &asServicename, QObject *parent, const QString &asCliPath)
    : DapAbstractCommand(asServicename, parent, asCliPath)
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

//    DapWallet wallet;
//    wallet.setName("VASY");
//    wallet.setBalance(25.5);
//    wallet.setIcon("/fsghdhjghjufkigl");
//    wallet.addNetwork("Kelvin-testnet");
//    wallet.addNetwork("Private");
//    wallet.addAddress("ar4th4t4j6tyj7utjk45u654kuj4kl6ui4l54k5lu5u4il5i34l35", "Kelvin-testnet");
//    wallet.addAddress("ar4th4t4j6tyj7utjk45u654kuj4kl6ui4l54k5lu5u4il5i34l35", "Private");

//    DapWalletToken token1("KLV", &wallet);
//    token1.setBalance(5.5);
//    token1.setNetwork("Kelvin-testnet");
//    token1.setEmission(464645646546);
//    DapWalletToken token2("CELL", &wallet);
//    token2.setBalance(100);
//    token2.setNetwork("Private");
//    token2.setEmission(121212121);
//    wallet.addToken(&token1);
//    wallet.addToken(&token2);

//    QByteArray datas;
//    QDataStream out(&datas, QIODevice::WriteOnly);
//    out << wallet;

//        qDebug() << "balance after:\t" << wallet.getBalance();
//        qDebug() << "icon after:\t" << wallet.getIcon();
//        qDebug() << "networks after:\t" << wallet.getNetworks();
//        qDebug() << "m_aAddresses after:\t" << wallet.getAddresses();
//        qDebug() << "m_aTokens after:\t" << wallet.getTokens();


//        DapWallet   wallet2;
//        QByteArray d (datas);
//        QDataStream in(&d, QIODevice::ReadOnly);
//        in >> wallet2;

//        qDebug() << endl;
//        qDebug() << "name before:\t" << wallet2.getName();
//        qDebug() << "balance before:\t" << wallet2.getBalance();
//        qDebug() << "icon before:\t" << wallet2.getIcon();
//        qDebug() << "networks before:\t" << wallet2.getNetworks();
//        qDebug() << "m_aAddresses before:\t" << wallet2.getAddresses();
//    //    qDebug() << "m_aTokens before:\t" << wallet2.m_aTokens;

//        foreach (auto w, wallet2.getTokens()) {
//            qDebug() << static_cast<DapWalletToken*>(w)->getName() << endl;
//            qDebug() << static_cast<DapWalletToken*>(w)->getBalance() << endl;
//            qDebug() << static_cast<DapWalletToken*>(w)->getEmission() << endl;
//            qDebug() << static_cast<DapWalletToken*>(w)->getNetwork() << endl;

//        }


//        QJsonValue str = QJsonValue::fromVariant(datas.toHex());



//        QByteArray b = QByteArray::fromHex(str.toVariant().toByteArray());
//    std::string s = datas.toStdString();
//    QString str = QString::fromStdString(s);

//    DapWallet w;
//    QByteArray d;
//    QDataStream in(&datas, QIODevice::ReadOnly);
//    in>>w;

    QList<DapWallet> wallets;

    QStringList list;
    QProcess processN;
    processN.start(QString("%1 net list").arg(m_sCliPath));
    processN.waitForFinished(-1);
    QString result = QString::fromLatin1(processN.readAll());
    result.remove(' ');
    if(!(result.isEmpty() || result.isNull() || result.contains('\'')))
    {
        list = result.remove("\n").remove("\r").split(":").at(1).split(",");
    }

    QProcess process;
    process.start(QString("%1 wallet list").arg(m_sCliPath));
    process.waitForFinished(-1);
    QString res = QString::fromLatin1(process.readAll());
    QRegularExpression rx("wallet:\\s(.+)\\s", QRegularExpression::MultilineOption);
    QRegularExpressionMatchIterator itr = rx.globalMatch(res);
    while (itr.hasNext())
    {
        QRegularExpressionMatch match = itr.next();
        QString walletName = match.captured(1);
        DapWallet wallet;
        wallet.setName(walletName);
        auto begin = list.begin();
        auto end = list.end();
        for(; begin != end; ++begin)
        {

            wallet.addNetwork(*begin);

            QProcess process_token;
            process_token.start(QString("%1 wallet info -w %2 -net %3")
                                .arg(m_sCliPath)
                                .arg(walletName)
                                .arg(*begin));

            process_token.waitForFinished(-1);
            QByteArray result_tokens = process_token.readAll();
            QRegExp regex("wallet: (.+)\\s+addr:\\s+(.+)\\s+(balance)|(\\d+.\\d+)\\s\\((\\d+)\\)\\s(\\w+)");

            int pos = 0;
            DapWalletToken *token {nullptr};
            while((pos = regex.indexIn(result_tokens, pos)) != -1)
            {

                if(!regex.cap(2).isEmpty())
                {
                    wallet.addAddress(regex.cap(2), *begin);
                }
                else
                {
                    token = new DapWalletToken();
                    token->setName(regex.cap(6).trimmed());
                    token->setBalance(regex.cap(4).toDouble());
                    QString str = regex.cap(5);
                    token->setEmission(regex.cap(5).toULongLong());
                    token->setNetwork(*begin);
                    wallet.addToken(token);
                }

                pos += regex.matchedLength();
            }

        }
        wallets.append(wallet);
    }

    QByteArray datas;
    QDataStream out(&datas, QIODevice::WriteOnly);
    out << wallets;

    return QJsonValue::fromVariant(datas.toHex());
}


/// Reply from service.
/// @details Performed on the service side.
/// @return Service reply.
QVariant DapGetListWalletsCommand::replyFromService()
{
    QObject * s = sender();
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());

    emit serviceResponded(reply->response().toJsonValue().toVariant().toByteArray());

    return reply->response().toJsonValue().toVariant();
}

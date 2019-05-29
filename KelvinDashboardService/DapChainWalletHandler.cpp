#include "DapChainWalletHandler.h"

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
    process.start(QString("%1 wallet new -w %2").arg("/home/andrey/Project/build-kelvin-node/kelvin-node-cli").arg(asNameWallet));
    process.waitForFinished(-1);
    result = process.readAll();
    QStringList list;
    list.append(asNameWallet);
    list.append(parse(result));
    return result.isEmpty() ? QStringList() : list;
}

QMap<QString, QVariant> DapChainWalletHandler::getWallets()
{
    QMap<QString, QVariant> map;
    QProcess process;
    process.start(QString("%1 wallet list").arg("/home/andrey/Project/build-kelvin-node/kelvin-node-cli"));
    process.waitForFinished(-1);
    QString str = QString::fromLatin1(process.readAll()).remove(" ");
    QRegExp rx( ":\\b([a-zA-Z0-9]+)\\n" );
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

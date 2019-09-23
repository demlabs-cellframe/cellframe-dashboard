#include "DapChainNetworkHandler.h"

DapChainNetworkHandler::DapChainNetworkHandler(QObject *parent) : QObject(parent)
{

}

QStringList DapChainNetworkHandler::getNetworkList()
{
    QStringList network;
    QProcess process;
    process.start(QString(CLI_PATH) + " net list");
    process.waitForFinished(-1);
    QByteArray result = process.readAll();

    QString data = QString::fromStdString(result.toStdString());
    network = data.split("\n").at(0).split(": ").at(1).split(", ");

    return network;
}

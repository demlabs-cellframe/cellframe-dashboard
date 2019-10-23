#include "DapChainNetworkHandler.h"
#include <QDebug>

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

    if(!result.isEmpty())
    {
        QString data = QString::fromStdString(result.toStdString());
        data = data.remove("\n");
        QStringList list = data.split(": ");
        if(list.count() > 1)
        {
            network = list.at(1).split(", ");
        }
    }

    return network;
}

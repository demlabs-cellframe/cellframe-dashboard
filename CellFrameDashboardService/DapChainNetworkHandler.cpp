#include "DapChainNetworkHandler.h"

DapChainNetworkHandler::DapChainNetworkHandler(QObject *parent) : QObject(parent)
{

}

QStringList DapChainNetworkHandler::getNetworkList() const
{
    return QStringList();
}

void DapChainNetworkHandler::setCurrentNetwork(const QString& aNetwork)
{
    emit changeCurrentNetwork(aNetwork);
}

#include "DapChainNetworkHandler.h"

DapChainNetworkHandler::DapChainNetworkHandler(QObject *parent) : QObject(parent),
    m_CurrentNetwork(-1)
{

}

QStringList DapChainNetworkHandler::getNetworkList()
{
    QStringList network;
    /// TODO: It's test. We should change it later
    QFile file("network.txt");
    if(file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        QString data = QString::fromStdString(file.readAll().toStdString());
        network = data.split(": ").at(1).split(", ");
    }

    if(!network.isEmpty())
    {
        if(m_CurrentNetwork.isEmpty() || !m_NetworkList.contains(m_CurrentNetwork))
            m_CurrentNetwork = network.at(0);
        emit changeCurrentNetwork(m_CurrentNetwork);
    }

    return network;
}

void DapChainNetworkHandler::setCurrentNetwork(const QString& aNetwork)
{
    if(m_NetworkList.contains(aNetwork))
        emit changeCurrentNetwork(aNetwork);
}

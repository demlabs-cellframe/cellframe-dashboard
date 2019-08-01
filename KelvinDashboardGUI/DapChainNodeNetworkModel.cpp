#include "DapChainNodeNetworkModel.h"
#include <QDebug>

#define DEFAULT_TIMER_MS 1000

DapChainNodeNetworkModel::DapChainNodeNetworkModel(QObject *parent) : QObject(parent)
{
    m_timerRequest = new QTimer(this);
    QObject::connect(m_timerRequest, SIGNAL(timeout()), this, SIGNAL(requestNodeNetwork()));
    m_timerRequest->start(DEFAULT_TIMER_MS);
}

DapChainNodeNetworkModel& DapChainNodeNetworkModel::getInstance()
{
    static DapChainNodeNetworkModel instance;
    return instance;
}

const DapNodeMap* DapChainNodeNetworkModel::getDataMap() const
{
    return &m_nodeMap;
}

const DapNodeData* DapChainNodeNetworkModel::getNodeData(const QString& aAddress) const
{
    const DapNodeData* nodeData = nullptr;
    if(m_nodeMap.contains(aAddress))
        nodeData = const_cast<const DapNodeData*>(&m_nodeMap.find(aAddress).value());

    return nodeData;
}

bool DapChainNodeNetworkModel::isNodeOnline(const QString& aAddress) const
{
    if(m_nodeMap.contains(aAddress))
        return m_nodeMap[aAddress].Status;

    return false;
}

void DapChainNodeNetworkModel::setStatusNode(const QString& aAddress, const bool aIsOnline)
{
    if(m_nodeMap.contains(aAddress))
    {
        m_nodeMap[aAddress].Status = aIsOnline;
        emit changeStatusNode(aAddress, aIsOnline);
    }
}

void DapChainNodeNetworkModel::startRequest()
{
    if(m_timerRequest->isActive()) m_timerRequest->stop();
    m_timerRequest->start();
}

void DapChainNodeNetworkModel::startRequest(const int aTimeout)
{
    if(m_timerRequest->isActive()) m_timerRequest->stop();
    m_timerRequest->start(aTimeout);
}

void DapChainNodeNetworkModel::stopRequest()
{
    m_timerRequest->stop();
}

void DapChainNodeNetworkModel::setData(const QVariant& aData)
{
    if (m_data == aData) return;
    m_data = aData;
    QMap<QString, QVariant> dataMap = m_data.toMap();

    QList<QString> addressList = dataMap.keys();
    foreach(auto address, addressList)
        m_nodeMap[address] = DapNodeData();

    for(auto node = m_nodeMap.begin(); node != m_nodeMap.end(); node++)
    {
        DapNodeData* nodeData = &node.value();
        QStringList nodeDataList = dataMap[node.key()].toStringList();
        nodeData->Cell = nodeDataList.at(0).toUInt();
        nodeData->Ipv4 = nodeDataList.at(1);
        nodeData->Alias = nodeDataList.at(2);

        if(nodeDataList.at(3).toUInt() > 0)
        {
            for(int i = 4; i < nodeDataList.count(); i++)
                nodeData->Link.append(nodeDataList.at(i));
        }
    }

    emit changeNodeNetwork();
}

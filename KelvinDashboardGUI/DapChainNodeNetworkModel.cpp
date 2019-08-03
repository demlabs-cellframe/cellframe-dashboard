#include "DapChainNodeNetworkModel.h"
#include <QDataStream>
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

QString DapChainNodeNetworkModel::getCurrentAddress() const
{
    for (auto node = m_nodeMap.constBegin(); node != m_nodeMap.constBegin(); node++) {
        if(node.value().isCurrentNode) return node.key();
    }

    return QString();
}

bool DapChainNodeNetworkModel::isNodeOnline(const QString& aAddress) const
{
    if(m_nodeMap.contains(aAddress))
        return m_nodeMap[aAddress].Status;

    return false;
}

void DapChainNodeNetworkModel::sendRequestNodeStatus(const bool aIsOnline)
{
    QString address = getCurrentAddress();
    if(m_nodeMap[address].Status != aIsOnline)
        emit requestNodeStatus(aIsOnline);
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

void DapChainNodeNetworkModel::receiveNewNetwork(const QVariant& aData)
{
    if (m_data == aData) return;
    m_data = aData;
    m_nodeMap.clear();

    QMap<QString, QVariant> dataMap = m_data.toMap();

    QList<QString> addressList = dataMap.keys();
    foreach(auto address, addressList)
    {
        if(address == "current")
        {
            QStringList args = dataMap["current"].toStringList();
            if(m_nodeMap.contains(args.at(0)))
            {
                m_nodeMap[args.at(0)].Status = (args.at(1) == "NET_STATE_OFFLINE" ? false : true);
                m_nodeMap[args.at(0)].isCurrentNode = true;
            }
            else continue;
        }
        m_nodeMap[address] = DapNodeData();
    }

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

void DapChainNodeNetworkModel::receiveNodeStatus(const QVariant& aData)
{
    QByteArray data = aData.toByteArray();
    QDataStream out(&data, QIODevice::ReadOnly);

    QString address;
    bool status;

    out >> address >> status;

    if(m_nodeMap.contains(address))
    {
        DapNodeData* nodeData = &m_nodeMap[address];
        nodeData->Status = status;
        nodeData->isCurrentNode = true;
        emit changeStatusNode(address, status);
    }
}

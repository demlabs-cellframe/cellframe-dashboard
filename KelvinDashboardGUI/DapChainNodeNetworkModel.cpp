#include "DapChainNodeNetworkModel.h"
#include <QDebug>

DapChainNodeNetworkModel::DapChainNodeNetworkModel(QObject *parent) : QObject(parent)
{
}

DapChainNodeNetworkModel& DapChainNodeNetworkModel::getInstance()
{
    static DapChainNodeNetworkModel instance;
    return instance;
}

QVariant DapChainNodeNetworkModel::getData() const
{
    return m_data;
}

void DapChainNodeNetworkModel::setData(const QVariant& AData)
{
    if (m_data == AData) return;
    m_data = AData;
    emit dataChanged(m_data);
}

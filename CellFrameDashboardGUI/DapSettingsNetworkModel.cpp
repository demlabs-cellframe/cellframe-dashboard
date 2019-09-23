#include "DapSettingsNetworkModel.h"

DapSettingsNetworkModel::DapSettingsNetworkModel(QObject *parent) : QAbstractListModel(parent),
    m_CurrentIndex(-1)
{
    m_NetworkList  = QStringList() << "First" << "Second" << "Third" << "Forth";
}

DapSettingsNetworkModel& DapSettingsNetworkModel::getInstance()
{
    static DapSettingsNetworkModel instance;
    return instance;
}

int DapSettingsNetworkModel::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)

    return m_NetworkList.count();
}

QVariant DapSettingsNetworkModel::data(const QModelIndex& index, int role) const
{
    if(!index.isValid()) return QVariant();
    if(role == DisplayName)
        return m_NetworkList.at(index.row());

    return QVariant();
}

QHash<int, QByteArray> DapSettingsNetworkModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[DisplayName] = "network";

    return roles;
}

QString DapSettingsNetworkModel::getCurrentNetwork() const
{
    return m_CurrentNetwork;
}

int DapSettingsNetworkModel::getCurrentIndex() const
{
    return m_CurrentIndex;
}

void DapSettingsNetworkModel::setNetworkList(const QStringList& aNetworkList)
{
    if(m_NetworkList == aNetworkList) return;
    beginResetModel();
    m_NetworkList = aNetworkList;
    endResetModel();
}

void DapSettingsNetworkModel::setCurrentNetwork(QString CurrentNetwork, int CurrentIndex)
{
    if (m_CurrentNetwork == CurrentNetwork)
        return;

    m_CurrentNetwork = CurrentNetwork;
    m_CurrentIndex = CurrentIndex;
    emit currentNetworkChanged(m_CurrentNetwork);
}

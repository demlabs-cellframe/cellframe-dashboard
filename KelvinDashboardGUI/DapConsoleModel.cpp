#include "DapConsoleModel.h"

DapConsoleModel::DapConsoleModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

DapConsoleModel& DapConsoleModel::getInstance()
{
    static DapConsoleModel instance;
    return instance;
}

void DapConsoleModel::receiveResponse(const QString& aResponse)
{
    emit sendResponse(aResponse);
}

int DapConsoleModel::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)

    return m_CommandList.count();
}

QVariant DapConsoleModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid()) return QVariant();

    if(role == LastCommand)
        return m_CommandList.at(index.row());

    return QVariant();
}

QHash<int, QByteArray> DapConsoleModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[LastCommand] = "lastCommand";
    return roles;
}

QString DapConsoleModel::getCommandUp()
{
    if(m_CommandList.isEmpty()) return QString();
    if(m_CommandIndex > m_CommandList.begin()) m_CommandIndex--;
    return *m_CommandIndex;
}

QString DapConsoleModel::getCommandDown()
{
    if(m_CommandList.isEmpty()) return QString();
    if(m_CommandIndex < m_CommandList.end() -1) m_CommandIndex++;
    else return QString();
    return *m_CommandIndex;
}

void DapConsoleModel::receiveRequest(const QString& aCommand)
{
    beginResetModel();
    m_CommandList.append(aCommand);
    endResetModel();
    m_CommandIndex = m_CommandList.end();
    emit sendRequest(aCommand);
}

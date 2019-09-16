#include "DapUiQmlWidgetConsole.h"

DapUiQmlWidgetConsoleModel::DapUiQmlWidgetConsoleModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

DapUiQmlWidgetConsoleModel& DapUiQmlWidgetConsoleModel::getInstance()
{
    static DapUiQmlWidgetConsoleModel instance;
    return instance;
}

void DapUiQmlWidgetConsoleModel::receiveResponse(const QString& aResponse)
{
    emit sendResponse(aResponse);
}

int DapUiQmlWidgetConsoleModel::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)

    return m_CommandList.count();
}

QVariant DapUiQmlWidgetConsoleModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid()) return QVariant();

    if(role == LastCommand)
    {
        qDebug() << "data:" << m_CommandList.at(index.row());
        return m_CommandList.at(index.row());
    }

    return QVariant();
}

QHash<int, QByteArray> DapUiQmlWidgetConsoleModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[LastCommand] = "lastCommand";
    return roles;
}

QString DapUiQmlWidgetConsoleModel::getCommandUp()
{
    if(m_CommandList.isEmpty()) return QString();
    if(m_CommandIndex > m_CommandList.begin()) m_CommandIndex--;
    return *m_CommandIndex;
}

QString DapUiQmlWidgetConsoleModel::getCommandDown()
{
    if(m_CommandList.isEmpty()) return QString();
    if(m_CommandIndex < m_CommandList.end() -1) m_CommandIndex++;
    else return QString();
    return *m_CommandIndex;
}

void DapUiQmlWidgetConsoleModel::receiveRequest(const QString& aCommand)
{
    beginResetModel();
    m_CommandList.append(aCommand);
    endResetModel();
    m_CommandIndex = m_CommandList.end();
    emit sendRequest(aCommand);
}

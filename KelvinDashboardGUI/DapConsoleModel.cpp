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
    m_History.append(aResponse);
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
    if(!m_CommandList.contains(aCommand))
        m_CommandList.append(aCommand);
    endResetModel();
    m_CommandIndex = m_CommandList.end();

    QString returnSymbol = "\n";

#ifdef Q_OS_WIN
    returnSymbol.prepend("\r");
#endif

    m_History.append(returnSymbol + "> " + aCommand + returnSymbol);
    emit sendRequest(aCommand);
}

QString DapConsoleModel::getCmdHistory()
{
    return m_History;
}

void DapConsoleModel::receiveCmdHistory(const QString& aHistory)
{
    m_History.append(aHistory);
    QRegExp rx("^([\\w+\\s+])$");

    int pos = 0;
    while ((pos = rx.indexIn(m_History, pos)) != -1)
    {
        if(!m_CommandList.contains(rx.cap(1)))
            m_CommandList.append(rx.cap(1));
        pos += rx.matchedLength();
    }
    emit cmdHistoryChanged(m_History);
}

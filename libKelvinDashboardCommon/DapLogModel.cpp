#include "DapLogModel.h"

DapLogModel::DapLogModel(QObject *parent) : QAbstractListModel(parent)
{

}

DapLogModel &DapLogModel::getInstance()
{
    static DapLogModel instance;
    return instance;
}

int DapLogModel::rowCount(const QModelIndex &) const
{
    return m_dapLogMessage.count();
}

QVariant DapLogModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < rowCount())
        switch (role) {
            case TypeRole:
            {
                QString s = m_dapLogMessage.at(index.row())->getType();
                return m_dapLogMessage.at(index.row())->getType();
            }
            case TimeStampRole: return m_dapLogMessage.at(index.row())->getTimeStamp();
            case FileRole: return m_dapLogMessage.at(index.row())->getFile();
            case MessageRole:
            {
                QString s1 = m_dapLogMessage.at(index.row())->getMessage();

                return m_dapLogMessage.at(index.row())->getMessage();
            }
            default:
            break;
        }
    return QVariant();
}

QHash<int, QByteArray> DapLogModel::roleNames() const
{
    static const QHash<int, QByteArray> roles {
        { TypeRole, "type" },
        { TimeStampRole, "timestamp" },
        { FileRole, "file" },
        { MessageRole, "message" }
    };

    return roles;
}

QVariantMap DapLogModel::get(int row) const
{
    const DapLogMessage *widget = m_dapLogMessage.value(row);
    return { {"type", widget->getType()}, {"timestamp", widget->getTimeStamp()}, {"file", widget->getFile()}, {"message", widget->getMessage()} };
}

void DapLogModel::append(const DapLogMessage &message)
{
    this->append(message.getType(), message.getTimeStamp(), message.getFile(), message.getMessage());
}

void DapLogModel::append(const QString &type, const QString &timestamp, const QString &file, const QString &message)
{
    beginInsertRows(QModelIndex(), m_dapLogMessage.count(), m_dapLogMessage.count());
    m_dapLogMessage.insert(m_dapLogMessage.count(), new DapLogMessage(type, timestamp, file, message));
    endInsertRows();
}

void DapLogModel::set(int row, const QString &type, const QString &timestamp, const QString &file, const QString &message)
{
    if (row < 0 || row >= m_dapLogMessage.count())
            return;

        DapLogMessage *widget = m_dapLogMessage.value(row);
        widget->setType(type);
        widget->setTimeStamp(timestamp);
        widget->setFile(file);
        widget->setMessage(message);
        dataChanged(index(row, 0), index(row, 0), { TypeRole, TimeStampRole, FileRole, MessageRole });
}

void DapLogModel::remove(int row)
{
    if (row < 0 || row >= m_dapLogMessage.count())
            return;

        beginRemoveRows(QModelIndex(), row, row);
        m_dapLogMessage.removeAt(row);
        endRemoveRows();
}

void DapLogModel::clear()
{
    for(auto it = m_dapLogMessage.begin(); it != m_dapLogMessage.end(); ++it)
    {
        delete *it;
    }

    m_dapLogMessage.clear();
}


/// Method that implements the singleton pattern for the qml layer.
/// @param engine QML application.
/// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
QObject *DapLogModel::singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return &getInstance();
}

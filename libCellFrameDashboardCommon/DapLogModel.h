#ifndef DAPLOGMODEL_H
#define DAPLOGMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QList>
#include <QQmlEngine>
#include <QJSEngine>
#include <QXmlStreamWriter>
#include <QXmlStreamReader>
#include <QXmlStreamAttribute>

#include "DapLogMessage.h"
/**
 * @brief The DapLogRole enum
 * Roles of dap log model
 *
 * These values are used in arguments to methods data and roleNames.
 * Main goal is return concrete fields from concrete log messages
 */
enum DapLogRole {
        /// Type of log message
        TypeRole = Qt::DisplayRole,
        /// Timestamp of log message
        TimeStampRole = Qt::UserRole,
        /// Name of file where log message was occured
        FileRole,
        /// Text of log message
        MessageRole
    };

/// Class model for log screen
class DapLogModel : public QAbstractListModel
{
    Q_OBJECT
    /// list of log messages
    QList<DapLogMessage*>    m_dapLogMessage;

    /// standard constructor
    DapLogModel(QObject *parent = nullptr);
public:

    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapLogModel &getInstance();


    Q_ENUM(DapLogRole)

    /// Count of log messages in model
    /// @return count of log messages
    int rowCount(const QModelIndex & = QModelIndex()) const;
    /// Get data from concrete log messages
    /// @param index Index of log message
    /// @param role Which field in log message
    /// @return Part of log message in according to which field was choosen
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    /// Get all types fields of log message
    /// @return set of fiels of log message
    QHash<int, QByteArray> roleNames() const;

    /// Get concrete log message
    /// @return log message
    Q_INVOKABLE QVariantMap get(int row) const;
    /// Append to new log message
    /// @param message New log message
    Q_INVOKABLE void append(const DapLogMessage &message);
    /// Append to new log message
    /// @param type Type of log message
    /// @param timestamp Timestamp of log message
    /// @param file Name of file of log message
    /// @param message Text of log message
    Q_INVOKABLE void append(const QString &type, const QString &timestamp, const QString  &file, const QString &message);
    /// Change log message by new data
    /// @param row Index of log message
    /// @param type Type of log message
    /// @param timestamp Timestamp of log message
    /// @param file Name of file of log message
    /// @param message Text of log message
    Q_INVOKABLE void set(int row, const QString &type, const QString &timestamp, const QString  &file, const QString &message);
    /// Remove log message
    /// @param row Index of log message
    Q_INVOKABLE void remove(int row);
    /// Clear all log messages
    Q_INVOKABLE void clear();

public slots:
    /// Method that implements the singleton pattern for the qml layer.
    /// @param engine QML application.
    /// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
    static QObject *singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
};

#endif // DAPLOGMODEL_H

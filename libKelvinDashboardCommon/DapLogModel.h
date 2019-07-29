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

enum DapLogRole {
        TypeRole = Qt::DisplayRole,
        TimeStampRole = Qt::UserRole,
        FileRole,
        MessageRole
    };

class DapLogModel : public QAbstractListModel
{
    Q_OBJECT

    QList<DapLogMessage*>    m_dapLogMessage;

    DapLogModel(QObject *parent = nullptr);
public:

    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapLogModel &getInstance();


    Q_ENUM(DapLogRole)

    int rowCount(const QModelIndex & = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE void append(const DapLogMessage &message);
    Q_INVOKABLE void append(const QString &type, const QString &timestamp, const QString  &file, const QString &message);
    Q_INVOKABLE void set(int row, const QString &type, const QString &timestamp, const QString  &file, const QString &message);
    Q_INVOKABLE void remove(int row);
     Q_INVOKABLE void clear();

public slots:
    /// Method that implements the singleton pattern for the qml layer.
    /// @param engine QML application.
    /// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
    static QObject *singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
};

#endif // DAPLOGMODEL_H

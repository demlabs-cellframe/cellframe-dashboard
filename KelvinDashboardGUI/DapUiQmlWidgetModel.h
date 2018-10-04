#ifndef DAPUIQMLWIDGETMODEL_H
#define DAPUIQMLWIDGETMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QList>
#include <QQmlEngine>
#include <QJSEngine>
#include <QXmlStreamWriter>
#include <QXmlStreamReader>
#include <QXmlStreamAttribute>

#include "DapUiQmlWidget.h"

enum DapUiQmlWidgetRole {
        NameRole = Qt::DisplayRole,
        URLPageRole = Qt::UserRole,
        ImageRole,
        VisibleRole
    };

class DapUiQmlWidgetModel : public QAbstractListModel
{
    Q_OBJECT
    
    QList<DapUiQmlWidget*>    m_dapUiQmlWidgets;
    
    DapUiQmlWidgetModel(QObject *parent = nullptr);
public:
    
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapUiQmlWidgetModel &getInstance();
    
    
    Q_ENUM(DapUiQmlWidgetRole)
    
    int rowCount(const QModelIndex & = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;
        
    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE void append(const QString &name, const QString &URLpage, const QString  &image, const bool &visible);
    Q_INVOKABLE void set(int row, const QString &name, const QString &URLpage, const QString  &image, const bool &visible);
    Q_INVOKABLE void remove(int row);
    
public slots:
    /// Method that implements the singleton pattern for the qml layer.
    /// @param engine QML application.
    /// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
    static QObject *singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
};

#endif // DAPUIQMLWIDGETMODEL_H

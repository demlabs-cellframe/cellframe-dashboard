/// Нужно
/// Организовать сохранение в настройках сети
/// Закинуть при смене сети настройки действий
/// создать при запуске действия по сохраненной сети
/// организовать удаление ячеек в таблице


#ifndef CHAINTABLE_H
#define CHAINTABLE_H

#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QWidget>
#include <QString>
#include <QDebug>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QMap>
#include <QVariantMap>
#include <QList>

#include <iostream>
#include <memory>

#include "SettingsTableModel.h"
#include "TableModel.h"
#include "LoadPlugin.h"

namespace cellframe{
class ChainTable: public QObject
{
    Q_OBJECT
public:
    ChainTable(QQmlApplicationEngine *,QObject *parent = nullptr);
    //ChainTable(QQmlApplicationEngine *,QString *,QObject *parent = nullptr);
    ~ChainTable();
    void showTable();

    QString getPathQml(QString );

    int numberOfItemListContent()const;

    ///column - set count column
    ///list - list of column names in strict order
    ///width - list of column widths in strict order
    void setHeadTable(int column, QStringList *list = nullptr, QList<int> *width = nullptr);

    ///Fills a table with data row by row based on another table by structure StructTable
    void setDataTable(QList<StructTable> *fullTable);

public slots:
    void messageThis();

private:
    QQmlApplicationEngine *mainProc;
    LoadPlugin *_cellFramePlugin;
    TableModel _model;
    SettingsTable _settingModel;



    ///column headings
    // QList<QString> _headlineRows;
    QVariantMap _eventList;
    ///path plugin folder
    QString _pluginFolder;

    ///from config(json)
    QString _namePlugin;
    QString _aboutPlugin;
    QMap<QString,QVariant> _qmlWidjetList;
    QMap<QString,QVariant> _networkList;


    void _loadConfigFile();

    //Временно для генерации таблицы

    void _generateNetwork();

};
}

#endif // CHAINTABLE_H

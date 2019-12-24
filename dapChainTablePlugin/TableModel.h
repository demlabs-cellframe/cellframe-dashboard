#ifndef TABLEMODEL_H
#define TABLEMODEL_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QAbstractListModel>
#include <QVariant>
#include <QDebug>
#include "StructTableChain.h"

namespace cellframe{

constexpr int WIDTH_COLUMN = 150;

class TableModel:public QAbstractTableModel
{
    Q_OBJECT
    Q_PROPERTY(QStringList getPropertyRole READ getPropertyRole CONSTANT)
    Q_PROPERTY(QStringList getPropertyTitle READ getPropertyTitle CONSTANT)
    Q_PROPERTY(QStringList getPropertyWidth READ getPropertyWidth CONSTANT)

public:
    TableModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override
    {
        Q_UNUSED(parent)
        return _listChain.count();
    }
    int columnCount(const QModelIndex &parent = QModelIndex()) const override
    {
        Q_UNUSED(parent)
        return _propertyHeadList.count();
    }

    bool setData(const QModelIndex &index,const QVariant &value, int role) override;
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;


    QString getFunction();

    void setCurrentNetwork(QString *network);

    void setNumberColumn(int number);

    //insert rows
    Q_INVOKABLE bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex())override;
    bool insertRows(StructTable *newRow, const QModelIndex &parent = QModelIndex());

    ///Table data
    ///Inserts a row at the end of a table
    void setRowToTable(StructTable);

    //Property HEAD TABLE FUNCTION
    void setPropertyHeadList(QString role, QString title, int width = WIDTH_COLUMN);
    QStringList getPropertyRole();
    QStringList getPropertyTitle();
    QStringList getPropertyWidth();

    Q_INVOKABLE QVariant &getHash(int row, int count);
//    Q_INVOKABLE QVariant &getCreator(int row, int count);
//    Q_INVOKABLE QVariant &getInvestor(int row, int count);
public slots:
    QVariant event_pressed();

signals:
    void clickForPaste();

private:
    QString _currentNetwork;
    //Blockchain data list
    QList<StructTable> _listChain;
    QList<headTable> _propertyHeadList;
    int _number_column;
};
}

#endif // TABLEMODEL_H


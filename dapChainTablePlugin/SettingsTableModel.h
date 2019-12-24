#ifndef SETTINGSTABLE_H
#define SETTINGSTABLE_H

#include <QAbstractListModel>
#include <StructListNetwork.h>
#include <QDebug>
#include <QString>

namespace cellframe{

class SettingsTable:public QAbstractListModel
{
    Q_OBJECT
public:
    SettingsTable(QObject *parent = nullptr);

    //standard functions from the model
    int rowCount(const QModelIndex &parent = QModelIndex()) const override{
        qDebug()<<"[SettingTable] is rowCount "<<listNetWork.count();
        Q_UNUSED(parent)
        return listNetWork.count();
    }
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;

    bool setData(const QModelIndex &index,const QVariant &value, int role) override;
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    //insert one line into the list
    //param structNetwork
    void insertOneRowInList(structNetwork );
    Q_INVOKABLE void saveNetworkFromQML(int index, QVariant name);

private:
    //The list contains available chain networks
    QList<structNetwork> listNetWork;
};
}

#endif // SETTINGSTABLE_H

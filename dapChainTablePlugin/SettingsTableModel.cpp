#include "SettingsTableModel.h"
using namespace cellframe;

SettingsTable::SettingsTable(QObject *parent):QAbstractListModel(parent)
{
    qDebug()<<"[SettingModel] construct";
}

QVariant SettingsTable::headerData(int section, Qt::Orientation orientation, int role) const

{
    qDebug()<<"[SettingModel] headerData";
    if (role != Qt::DisplayRole)
        return QVariant();
    if (orientation == Qt::Horizontal)
    {
        switch (section)
        {
        default:
            return QVariant();
        }
    }
    return QVariant();
}

QHash<int, QByteArray> SettingsTable::roleNames() const        //Возвращает имена ролей модели
{
    qDebug()<<"[SettingModel] roleNames";
  QHash<int, QByteArray> roles;
  roles.insert(Qt::UserRole+0, "nameNetwork");
  roles.insert(Qt::UserRole+1, "ip");
  roles.insert(Qt::UserRole+2, "port");
  return roles;
}

QVariant SettingsTable::data(const QModelIndex &index, int role) const
{
    qDebug()<<"[SettingModel] date";
  if (!index.isValid())
    return QVariant();

  structNetwork s = listNetWork.at(index.row());
  switch (role) {
      case Qt::UserRole+0: return s.rows[0];
      case Qt::UserRole+1:{
      QString tmp = QString("%1.%2.%3.%4").arg(s.rows[1].toInt()).arg(s.rows[2].toInt()).arg(s.rows[3].toInt()).arg(s.rows[4].toInt());
      return tmp;
  }
      case Qt::UserRole+2: return s.rows[5];
    }

  return QVariant();
}

bool SettingsTable::setData(const QModelIndex &index,
                               const QVariant &value, int role)
 {

//    qDebug()<<"[TableModel] setDate";
//     if (index.isValid() && role == Qt::EditRole) {

//         //stringList.replace(index.row(), value.toString());
//         emit dataChanged(index, index);
//         return true;
//     }
//     return false;
 }

void SettingsTable::insertOneRowInList(structNetwork insertRow )
{
    listNetWork.push_back(insertRow);
}

void SettingsTable::saveNetworkFromQML(int index,QVariant name)
{
    qDebug()<<"[SettingModel] save name: "<<listNetWork[index].rows[0];
    qDebug()<<"[SettingModel] save name from qml: "<<name;
}

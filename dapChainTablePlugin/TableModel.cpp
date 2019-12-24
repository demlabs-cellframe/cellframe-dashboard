#include "TableModel.h"
using namespace cellframe;

#include <QtDebug>

TableModel::TableModel(QObject *parent) : QAbstractTableModel (parent)
{
  qDebug()<<"[TableModel]Construct";

}

QHash<int, QByteArray> TableModel::roleNames() const        //Возвращает имена ролей модели
{
    qDebug()<<"[TableModel] roleNames";
  QHash<int, QByteArray> roles;

  for(int i(0);i<_propertyHeadList.count();i++)
  {
      roles.insert(Qt::UserRole+i, _propertyHeadList.at(i).role.toUtf8());
  }

  return roles;
}

void TableModel::setNumberColumn(int number)
{
    _number_column = number;
}

QVariant TableModel::data(const QModelIndex &index, int role) const
{
   // qDebug()<<"[TableModel] date";
  if (!index.isValid())
    return QVariant();

  StructTable s = _listChain[index.row()];
    if(role == Qt::UserRole+0)
    {
       return  index.row();
    }
  for(int i = 0;i<s.getCount();i++)
  {
      if(role == Qt::UserRole+i+1)
      {
          return s.getMainValueCell(i);
      }
  }
  return QVariant();
}

///Inserts a row at the end of a table
void TableModel::setRowToTable(StructTable content)
{
    _listChain.push_back(content);
}


bool TableModel::setData(const QModelIndex &index,
                               const QVariant &value, int role)
 {
    qDebug()<<"[TableModel] setDate";
     if (index.isValid() /*&& role == Qt::EditRole*/) {
         StructItem tmp;
         tmp.valueItem = value;
         tmp.creator = "name1";
         tmp.investor = "name2";
         if(_listChain[index.row()].editValue(index.column()-1,tmp))
         {
         emit dataChanged(index, index);
         return true;
         }
     }
     return false;
 }

void TableModel::setCurrentNetwork(QString *network)
{
    _currentNetwork = *network;
}
//================================GET INFO???===========================
QVariant &TableModel::getHash(int row, int column)
{
    return _listChain[row].getHash(column);
}
//QVariant &TableModel::getCreator(int row, int column)
//{
//    return _listChain[row].getCreator(column);
//}
//QVariant &TableModel::getInvestor(int row, int column)
//{
//    return _listChain[row].getInvestor(column);
//}
//===================================SLOTS===============================
QVariant TableModel::event_pressed()
{
    qDebug()<<"on Press";
    QVariant str;
    return str;
}

//===================================SIGNALS===============================
//void TableModel::clickForPaste()
//{
//   // emit clickForPaste();

//}

//=========================insert rows===================================
bool TableModel::insertRows(int row, int count, const QModelIndex &parent)
{
    Q_UNUSED(row)
    Q_UNUSED(count)
    qDebug()<<"[TableModel] insert row";

    beginInsertRows(parent,_listChain.count(),_listChain.count());
    StructTable tmpRow;
    //int maxCount = roleNames().count();
    for(int i(0);i<_number_column;i++)
    {
       // tmpRow.setNewItem(QString(""));
    }

   setRowToTable(tmpRow);

    endInsertRows();
    return true;

}

bool TableModel::insertRows(StructTable *newRow, const QModelIndex &parent)
{
   beginInsertRows(parent,_listChain.count(),_listChain.count());
   setRowToTable(*newRow);
   endInsertRows();
   return true;
}
///=====================Property HEAD TABLE FUNCTION=====================
///
void TableModel::setPropertyHeadList(QString role,QString title,int width)
{
    headTable tmp;
    tmp.role = role;
    tmp.title = title;
    tmp.width = width;
    _propertyHeadList.push_back(tmp);
}

QStringList TableModel::getPropertyRole()
{
    QStringList tmp;
    for(auto value:_propertyHeadList)
    {
        tmp.push_back(value.role);
    }
    return tmp;
}

QStringList TableModel::getPropertyTitle()
{
    QStringList tmp;
    for(auto value:_propertyHeadList)
    {
        tmp.push_back(value.title);
    }
    return tmp;
}

QStringList TableModel::getPropertyWidth()
{
    QStringList tmp;
    for(auto value:_propertyHeadList)
    {
        tmp.push_back(QString("%1").arg(value.width));
        //qDebug()<<value.width;
    }
    return tmp;
}
//-------------------------

#include "DapWalletListModel.h"

DapWalletListModel::DapWalletListModel(QObject *a_parent)
    : DapAbstractWalletList (a_parent)
{

}

void DapWalletListModel::setModel(QJsonDocument *doc)
{
  QList <Item> items;
  QJsonArray arr = doc->array();

  for (auto itr = arr.begin(); itr != arr.end(); itr++)
  {
      QJsonObject obj = itr->toObject();
      items.append(getItem(obj));
  }

  auto *g = global();
  if(g->m_items->isEmpty() || g->m_items->count() != items.count() )
  {
      g->beginResetModel();
      *g->m_items = items;
      g->endResetModel();
  }
  else
      for(int i = 0; i < items.count(); i++)
          g->set(i,items[i]);
}

DapAbstractWalletList::Item DapWalletListModel::getItem(QJsonObject obj)
{
  Item itm;

  QString name   = obj["name"].toString();
  QString status = obj["status"].toString();

  itm.name          = name;
  itm.statusProtect = status;

  return itm;
}

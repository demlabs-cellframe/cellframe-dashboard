#include "DapDiagnosticModel.h"

DapDiagnosticModel::DapDiagnosticModel (QObject *a_parent)
  : DapAbstractDiagnosticModel (a_parent)
{

}

void DapDiagnosticModel::setModel(QJsonDocument *doc)
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

DapAbstractDiagnosticModel::Item DapDiagnosticModel::getItem(QJsonObject obj)
{
    Item itm;

    QJsonObject system = obj["system"].toObject();
    QJsonObject proc   = obj["process"].toObject();

    itm.proc_DB_size              = proc["DB_size"].toString();
    itm.proc_chain_size           = proc["chain_size"].toString();
    itm.proc_log_size             = proc["log_size"].toString();
    itm.proc_memory_use           = proc["memory_use"].toVariant().toInt();
    itm.proc_memory_use_value     = proc["memory_use_value"].toString();
    itm.proc_name                 = proc["name"].toString();
    itm.proc_status               = proc["status"].toString();
    itm.proc_uptime               = proc["uptime"].toString();
    itm.proc_version              = proc["version"].toString();

    itm.system_CPU_load           = system["CPU"].toObject()["load"].toVariant().toInt();
    itm.system_memory_free        = system["memory"].toObject()["free"].toString();
    itm.system_memory_load        = system["memory"].toObject()["load"].toVariant().toInt();
    itm.system_memory_total       = system["memory"].toObject()["total"].toString();
//    itm.system_memory_total_value = system["memory"].toObject()["total_value"].toVariant().toInt();
    itm.system_mac                = system["mac"].toString();
    itm.system_uptime             = system["uptime"].toString();
    itm.system_uptime_dashboard   = system["uptime_dashboard"].toString();
    itm.system_node_name          = system["name"].toString();

    quint64 timeUpdate            = system["time_update_unix"].toVariant().toLongLong();
    itm.system_time_update        = QDateTime::fromSecsSinceEpoch(timeUpdate).toString("dd.MM.yyyy-hh:mm");

    return itm;
}

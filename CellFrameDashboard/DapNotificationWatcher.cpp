#include "DapNotificationWatcher.h"

DapNotificationWatcher::DapNotificationWatcher(QObject *parent)
{
    m_node_notify = std::shared_ptr<cellframe_node::notify::CellframeNotificationChannel>(cellframe_node::getCellframeNodeInterface("local")->openNotificationChannel());

    m_node_notify->addNotifyDataCallback([this](const std::string &data) 
    {
        emit rcvNotify(QJsonDocument::fromJson(data.c_str()).toVariant());
    });
}

DapNotificationWatcher::~DapNotificationWatcher()
{
    
}
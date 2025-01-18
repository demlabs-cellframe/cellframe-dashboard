#pragma once

#include <QObject>
#include "DapNetworksManagerBase.h"
#include "../NotifyController/DapNotifyController.h"

class DapNetworksManagerLocal : public DapNetworksManagerBase
{
    Q_OBJECT
public:
    DapNetworksManagerLocal(DapModulesController* moduleController);
    ~DapNetworksManagerLocal();

private slots:
    void slotNotifyIsConnected(bool isConnected);
    void slotRcvNotifyNetList(QJsonDocument doc);
    void slotRcvNotifyNetInfo(QJsonDocument doc);
    void slotRcvNotifyNetsInfo(QJsonDocument doc);
    void initNotifyConnet();
private:

    void clearAll();
    NetworkInfo getNetworkInfo(const QString& netName, const QJsonObject& itemModel);

    QString convertState(QString state);
    QString convertProgress(QJsonObject obj);
    void updateNetworkList(const QStringList& list);
private:
    DapNotifyController *m_notifyController = nullptr;

    const QMap<QString, QString> STATES_STRINGS = {
        { "NET_STATE_OFFLINE", "OFFLINE"},
        { "NET_STATE_ONLINE", "ONLINE"},
        { "NET_STATE_LINKS_PREPARE", "LINKS PREPARE"},
        { "NET_STATE_LINKS_ESTABLISHED", "LINKS ESTABLISHED"},
        { "NET_STATE_LINKS_CONNECTING", "LINKS CONNECTING"},
        { "NET_STATE_SYNC_CHAINS", "SYNC CHAINS"},
        { "NET_STATE_SYNC_GDB", "SYNC GDB"},
        { "NET_STATE_ADDR_REQUEST", "ADDR REQUEST"},
        { "UNDEFINED", "ERROR"}
    };
};

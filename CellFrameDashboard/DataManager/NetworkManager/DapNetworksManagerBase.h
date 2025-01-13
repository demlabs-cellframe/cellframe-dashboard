#pragma once

#include <DapAbstractDataManager.h>
#include "DapNetworksTypes.h"
#include <QMap>

class DapNetworksManagerBase : public DapAbstractDataManager
{
    Q_OBJECT
public:
    DapNetworksManagerBase(DapModulesController *moduleController);

    const QStringList& getNetworkList() const { return m_netList; }
    const QMap<QString, NetworkLoadProgress>& getNetworkLoadProgress() const {return m_netsLoadProgress; }
signals:
    void deleteNetworksSignal(const QStringList& list);
    void networkListChanged();

    void updateNetworkInfoSignal(const NetworkInfo& info);

    void sigUpdateItemNetLoad();
    void isConnectedChanged(bool isConnected);

protected:
    QStringList m_netList = QStringList();

    QMap<QString, NetworkLoadProgress> m_netsLoadProgress;
};


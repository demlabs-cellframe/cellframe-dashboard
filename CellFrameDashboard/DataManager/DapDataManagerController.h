#pragma once

#include <QObject>
#include "DapNetworksManagerBase.h"
#include "Modules/DapModulesController.h"

class DapDataManagerController : public QObject
{
    Q_OBJECT
public:
    DapDataManagerController(DapModulesController* moduleController);

    DapNetworksManagerBase* getNetworkManager() const { return m_networksManager; }

    Q_PROPERTY (QStringList networkList READ getNetworkList NOTIFY networkListChanged)
    QStringList getNetworkList() const;

signals:
    void networkListChanged();
    void isConnectedChanged(bool isConnected);
private:
    DapNetworksManagerBase* m_networksManager = nullptr;
};

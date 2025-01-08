#pragma once

#include <QObject>
#include "DapNetworksManager.h"
#include "Modules/DapModulesController.h"

class DapDataManagerController : public QObject
{
    Q_OBJECT
public:
    DapDataManagerController(DapModulesController* moduleController);

    DapNetworksManager* getNetworkManager() const { return m_networksManager; }

    Q_PROPERTY (QStringList networkList READ getNetworkList NOTIFY networkListChanged)
    QStringList getNetworkList() const;

signals:
    void networkListChanged();
private:
    DapNetworksManager *m_networksManager = nullptr;
};

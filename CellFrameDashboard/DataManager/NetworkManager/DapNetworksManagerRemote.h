#pragma once

#include "DapNetworksManagerBase.h"
#include <QTimer>

class DapNetworksManagerRemote : public DapNetworksManagerBase
{
    Q_OBJECT
public:
    DapNetworksManagerRemote(DapModulesController* moduleController);

private slots:
    void clearAndUpdateDataSlot();
    void networkListRespond(const QVariant &rcvData);
    void networksStatesRespond(const QVariant &rcvData);
    void requestNetworkList();
private:

    void requestNetworskInfo();

private:
    QTimer* m_netListTimer = nullptr;
    bool isSendRequest{false};
};


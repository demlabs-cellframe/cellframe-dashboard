#pragma once

#include "DapNetworksManagerBase.h"

class DapNetworksManagerRemote : public DapNetworksManagerBase
{
    Q_OBJECT
public:
    DapNetworksManagerRemote(DapModulesController* moduleController);
protected:
    void initManager() override;
private slots:
    void networkListRespond(const QVariant &rcvData);

private:
    void requestNetworkList();
};


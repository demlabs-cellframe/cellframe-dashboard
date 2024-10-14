#ifndef DAPMODULENETWORKS_H
#define DAPMODULENETWORKS_H

#include <QObject>

#include "DapAbstractModule.h"
#include "DapModulesController.h"
#include "Models/DapNetworksModel.h"

class DapModuleNetworks : public DapAbstractModule
{
    Q_OBJECT

public:
    explicit DapModuleNetworks(DapModulesController *parent);
    ~DapModuleNetworks();

public:

protected:
    DapModulesController  *m_modulesCtrl;
    DapNetworksModel *m_networkList = nullptr;
private:

};

#endif // DAPMODULENETWORKS_H

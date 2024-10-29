#ifndef DAPMODULENETWORKS_H
#define DAPMODULENETWORKS_H

#include <QObject>
#include <QQmlContext>

#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "Models/DapNetworkList.h"

class DapModuleNetworks : public DapAbstractModule
{
    Q_OBJECT

public:
    explicit DapModuleNetworks(DapModulesController *parent);
    ~DapModuleNetworks();

public:

protected:
    DapModulesController  *m_modulesCtrl;
    DapNetworkList *m_networkList = nullptr;
private:

};

#endif // DAPMODULENETWORKS_H

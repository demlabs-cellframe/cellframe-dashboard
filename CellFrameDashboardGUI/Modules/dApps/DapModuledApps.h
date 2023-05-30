#ifndef DAPMODULEDAPPS_H
#define DAPMODULEDAPPS_H

#include <QObject>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuledApps : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuledApps(DapModulesController * modulesCtrl, DapAbstractModule *parent = nullptr);

private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;
};

#endif // DAPMODULEDAPPS_H

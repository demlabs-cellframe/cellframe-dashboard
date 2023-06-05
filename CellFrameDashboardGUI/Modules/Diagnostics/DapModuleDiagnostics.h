#ifndef DAPMODULEDIAGNOSTICS_H
#define DAPMODULEDIAGNOSTICS_H

#include <QObject>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleDiagnostics : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleDiagnostics(DapModulesController * modulesCtrl, DapAbstractModule *parent = nullptr);

private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;
};

#endif // DAPMODULEDIAGNOSTICS_H

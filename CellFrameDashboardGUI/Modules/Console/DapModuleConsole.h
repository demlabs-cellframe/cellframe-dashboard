#ifndef DAPMODULECONSOLE_H
#define DAPMODULECONSOLE_H

#include <QObject>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleConsole : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleConsole(DapModulesController * modulesCtrl, DapAbstractModule *parent = nullptr);

private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;
};

#endif // DAPMODULECONSOLE_H

#ifndef DAPMODULELOGS_H
#define DAPMODULELOGS_H

#include <QObject>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleLogs : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleLogs(DapModulesController * modulesCtrl, DapAbstractModule *parent = nullptr);

private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;
};

#endif // DAPMODULELOGS_H

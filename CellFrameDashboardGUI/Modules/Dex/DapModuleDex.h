#ifndef DAPMODULEDEX_H
#define DAPMODULEDEX_H

#include <QObject>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"


class DapModuleDex : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleDex(DapModulesController * modulesCtrl, DapAbstractModule *parent = nullptr);

private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;
};

#endif // DAPMODULEDEX_H

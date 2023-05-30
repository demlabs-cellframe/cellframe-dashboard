#ifndef DAPMODULETXEXPLORER_H
#define DAPMODULETXEXPLORER_H

#include <QObject>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleTxExplorer : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleTxExplorer(DapModulesController * modulesCtrl, DapAbstractModule *parent = nullptr);

private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;
};

#endif // DAPMODULETXEXPLORER_H

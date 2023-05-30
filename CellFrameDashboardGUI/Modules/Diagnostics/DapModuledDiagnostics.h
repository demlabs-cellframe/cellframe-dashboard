#ifndef DAPMODULEDDIAGNOSTICS_H
#define DAPMODULEDDIAGNOSTICS_H

#include <QObject>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuledDiagnostics : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuledDiagnostics(DapModulesController * modulesCtrl, DapAbstractModule *parent = nullptr);

private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;
};

#endif // DAPMODULEDDIAGNOSTICS_H

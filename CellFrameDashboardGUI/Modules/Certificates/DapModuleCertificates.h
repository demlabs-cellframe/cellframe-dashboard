#ifndef DAPMODULECERTIFICATES_H
#define DAPMODULECERTIFICATES_H

#include <QObject>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleCertificates : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleCertificates(DapModulesController * modulesCtrl, DapAbstractModule *parent = nullptr);

private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;
};

#endif // DAPMODULECERTIFICATES_H

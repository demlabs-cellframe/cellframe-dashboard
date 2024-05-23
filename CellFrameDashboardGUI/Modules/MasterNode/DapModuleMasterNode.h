#pragma once

#include <QObject>
#include <QWidget>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleMasterNode : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleMasterNode(DapModulesController *parent);
private:
    DapModulesController  *m_modulesCtrl;
};

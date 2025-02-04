#pragma once

#include <QObject>
#include "DapAbstractMasterNodeCommand.h"

class DapNodeDelStage : public DapAbstractMasterNodeCommand
{
    Q_OBJECT
public:
    DapNodeDelStage(DapModulesController *modulesController);

    void tryDeleteNode(const QVariantMap& masterNodeInfo);
private slots:
    void deletedNode(const QVariant &rcvData);
};


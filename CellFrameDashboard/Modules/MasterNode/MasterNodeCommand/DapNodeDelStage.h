#pragma once

#include <QObject>
#include "DapAbstractMasterNodeCommand.h"

class DapNodeDelStage : public DapAbstractMasterNodeCommand
{
    Q_OBJECT
public:
    DapNodeDelStage(DapServiceController *serviceController);

    void tryDeleteNode(const QVariantMap& masterNodeInfo);
private slots:
    void deletedNode(const QVariant &rcvData);
};


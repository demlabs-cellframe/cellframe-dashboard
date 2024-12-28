#pragma once

#include <QObject>
#include "DapAbstractMasterNodeCommand.h"

class DapUpdateConfigStage : public DapAbstractMasterNodeCommand
{
    Q_OBJECT
public:
    DapUpdateConfigStage(DapServiceController *serviceController);

    void updateConfigForRegistration(const QVariantMap& masterNodeInfo);
    void updateConfigForCencel(const QVariantMap& masterNodeInfo, const QMap<QString, QVariantMap>& allMasterNode);
};


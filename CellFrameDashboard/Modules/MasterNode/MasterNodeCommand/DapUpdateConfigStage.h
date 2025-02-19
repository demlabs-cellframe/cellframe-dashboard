#pragma once

#include <QObject>
#include <QtConcurrent/QtConcurrent>

#include "DapAbstractMasterNodeCommand.h"

class DapUpdateConfigStage : public DapAbstractMasterNodeCommand
{
    Q_OBJECT
public:
    DapUpdateConfigStage(DapServiceController *serviceController);

    void updateConfigForRegistration(const QVariantMap& masterNodeInfo);
    void updateConfigForCancel(const QVariantMap& masterNodeInfo, const QMap<QString, QVariantMap>& allMasterNode);

private:
    void setConfigValue(QString config, QString group, QString param, QString value);
};


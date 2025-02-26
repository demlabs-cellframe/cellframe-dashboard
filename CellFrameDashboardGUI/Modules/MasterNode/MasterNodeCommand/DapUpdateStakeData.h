#pragma once

#include <QObject>
#include "DapStakeListCommand.h"

class DapUpdateStakeData : public DapStakeListCommand
{
    Q_OBJECT
public:
    DapUpdateStakeData(DapServiceController *serviceController);

    void tryUpdateStakeData(const QMap<QString, QVariantMap>& nodes);

protected:
    void nodeNotFound() override;
    void errorReceived(int errorNumber, const QString& message) override;
    void nodeFound(const QJsonObject& nodeInfo) override;
private:
    void dataUpdate();
private:
    QStringList m_lastNetworkRequest;

    QMap<QString, QVariantMap> m_nodes;
};


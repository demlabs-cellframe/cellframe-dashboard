#pragma once

#include <QObject>
#include <QTimer>
#include "DapStakeListCommand.h"

class DapWaitingPermission : public DapStakeListCommand
{
    Q_OBJECT
public:
    DapWaitingPermission(DapServiceController *serviceController);
    ~DapWaitingPermission();

    void startWaitingPermission(const QVariantMap& masterNodeInfo);

    void cencelRegistration() override;
protected:
    void nodeFound(const QJsonObject& nodeInfo) override;
    void errorReceived(int errorNumber, const QString& message) override;
private slots:
    void getListKeysRequest();
private:
    QTimer* m_listKeysTimer = nullptr;

    const int TIME_OUT_LIST_KEYS = 30000;
};


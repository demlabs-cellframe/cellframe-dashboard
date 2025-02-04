#pragma once

#include <QObject>
#include <QTimer>
#include "DapAbstractMasterNodeCommand.h"

class DapWaitingPermission : public DapAbstractMasterNodeCommand
{
    Q_OBJECT
public:
    DapWaitingPermission(DapModulesController *modulesController);
    ~DapWaitingPermission();

    void startWaitingPermission(const QVariantMap& masterNodeInfo);

    void cencelRegistration() override;
private slots:
    void respondListKeys(const QVariant &rcvData);
private:
    void getListKeys();
private:
    QTimer* m_listKeysTimer = nullptr;

    const int TIME_OUT_LIST_KEYS = 30000;
};


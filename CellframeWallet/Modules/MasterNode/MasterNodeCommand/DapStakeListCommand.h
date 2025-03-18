#pragma once

#include <QObject>
#include "DapAbstractMasterNodeCommand.h"

class DapStakeListCommand : public DapAbstractMasterNodeCommand
{
    Q_OBJECT
public:
    DapStakeListCommand(DapServiceController *serviceController);
    ~DapStakeListCommand();

    void getListKeys(const QString& network, const QString& nodeAddr);
signals:
    void responseRequest(const QJsonObject& nodeInfo);
    void errorResponse(int errorNumber, const QString& message);
protected:
    virtual void nodeFound(const QJsonObject& nodeInfo);
    virtual void errorReceived(int errorNumber, const QString& message);
    virtual void nodeNotFound();
private slots:
    void respondListKeys(const QVariant &rcvData);   
private:
    QString m_requiredNode;
    QString m_networkName;
};


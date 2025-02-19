#pragma once

#include <QObject>
#include <functional>
#include "DapServiceController.h"

class DapAbstractMasterNodeCommand : public QObject
{
public:
    using NewDataCallback = std::function<void(const QString&, const QVariant&)>;
    using StopCreationCallback = std::function<void(int, const QString&)>;
    using StageComplatedCallback = std::function<void()>;

    DapAbstractMasterNodeCommand(DapServiceController *serviceController);
    ~DapAbstractMasterNodeCommand();
    virtual void cencelRegistration();

    void setNewDataCallback(NewDataCallback handler) { m_newDataCallback = handler; }
    void setStopCreationCallback(StopCreationCallback handler) { m_stopCreationCallback = handler; }
    void setStageComplatedCallback(StageComplatedCallback handler) { m_stageComplatedCallback = handler; }

protected:
    void stopCreationMasterNode(int code, const QString& message);
    void stageComplated();

    void setMasterNodeInfo(const QVariantMap& masterNodeInfo) { m_masterNodeInfo = masterNodeInfo; }
    void addDataMasterNodeInfo(const QString& key, const QVariant& data);
protected:
    DapServiceController* m_serviceController = nullptr;

    QVariantMap m_masterNodeInfo;

    NewDataCallback m_newDataCallback = nullptr;
    StopCreationCallback m_stopCreationCallback = nullptr;
    StageComplatedCallback m_stageComplatedCallback = nullptr;
};


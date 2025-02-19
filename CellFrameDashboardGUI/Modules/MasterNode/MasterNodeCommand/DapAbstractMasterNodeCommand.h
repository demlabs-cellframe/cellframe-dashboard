#pragma once

#include <QObject>
#include "DapServiceController.h"
#include "../DapMasterNodeKeys.h"
class DapAbstractMasterNodeCommand : public QObject
{
    Q_OBJECT
public:
    using NewDataCallback = std::function<void(const QString&, const QVariant&)>;
    using UpdateDataCallback = std::function<void(const QString&, const QString&, const QVariant&)>;
    using StopCreationCallback = std::function<void(int, const QString&)>;
    using Callback = std::function<void()>;

    DapAbstractMasterNodeCommand(DapServiceController *serviceController);
    ~DapAbstractMasterNodeCommand();
    virtual void cencelRegistration();

    void setNewDataCallback(NewDataCallback handler) { m_newDataCallback = handler; }
    void setUpdateDataCallback(UpdateDataCallback handler) { m_updateDataCallback = handler; }
    void setStopCreationCallback(StopCreationCallback handler) { m_stopCreationCallback = handler; }
    void setStageComplatedCallback(Callback handler) { m_stageComplatedCallback = handler; }
    void setSaveDataCallback(Callback handler) { m_saveDataCallback = handler; }
signals:
    void finished();
protected:
    void stopCreationMasterNode(int code, const QString& message);
    void stageComplated();

    void setMasterNodeInfo(const QVariantMap& masterNodeInfo) { m_masterNodeInfo = masterNodeInfo; }
    void addDataMasterNodeInfo(const QString& key, const QVariant& data);

    void updateMasterNodeData(const QString& network, const QString& paramName, const QVariant& value);
    void saveData();
protected:
    DapServiceController* m_serviceController = nullptr;

    QVariantMap m_masterNodeInfo;

    NewDataCallback m_newDataCallback = nullptr;
    UpdateDataCallback m_updateDataCallback = nullptr;
    StopCreationCallback m_stopCreationCallback = nullptr;
    Callback m_stageComplatedCallback = nullptr;
    Callback m_saveDataCallback = nullptr;
};


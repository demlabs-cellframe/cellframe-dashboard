#include "DapModuleSettings.h"

DapModuleSettings::DapModuleSettings(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_timerVersionCheck(new QTimer())
    , m_timerTimeoutService(new QTimer())
{
    connect(m_modulesCtrl, &DapModulesController::initDone, [=] ()
    {
        initConnect();
        s_serviceCtrl->requestToService("DapVersionController", QStringList()<<"version");
        checkVersion();
        setStatusInit(true);
    });

    m_isNodeAutoRun = m_modulesCtrl->getSettings()->value(SETTINGS_NODE_ENABLE_KEY, true).toBool();
}

DapModuleSettings::~DapModuleSettings()
{
    delete m_timerVersionCheck;
    delete m_timerTimeoutService;
}

void DapModuleSettings::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::versionControllerResult, this, &DapModuleSettings::rcvVersionInfo);
    connect(s_serviceCtrl, &DapServiceController::rcvRemoveResult, this, &DapModuleSettings::resultCrearData);


    connect(m_timerVersionCheck, &QTimer::timeout, this, &DapModuleSettings::checkVersion);
    connect(m_timerTimeoutService, &QTimer::timeout, this, &DapModuleSettings::timeoutVersionInfo);

}

void DapModuleSettings::rcvVersionInfo(const QVariant& result)
{
    auto resultObject = QJsonDocument::fromJson(result.toByteArray()).object();

    QJsonObject objRes = resultObject["result"].toObject();

//    qDebug()<<objRes["message"].toString();

    if(objRes["message"].toString().contains("error"))
    {
        qWarning()<<objRes["message"].toString();
    }
    else if(objRes["message"].toString().contains("node"))
    {
        m_nodeVersion = objRes["lastVersion"].toString();
        emit nodeVersionChanged();
    }
    else
    {
//        objRes["hasUpdate"] = true;
//        emit sigVersionInfo(objRes);
        emit sigVersionInfo(result);
        m_guiVersionRequest = false;
        emit guiRequestChanged();
    }
}

void DapModuleSettings::checkVersion()
{
    m_timerVersionCheck->stop();
    s_serviceCtrl->requestToService("DapVersionController", QStringList()<<"version node");
    m_timerVersionCheck->start(30000);
}

void DapModuleSettings::guiVersionRequest()
{
    if(!m_guiVersionRequest)
    {
        m_guiVersionRequest = true;
        emit guiRequestChanged();
        m_timerTimeoutService->stop();
        s_serviceCtrl->requestToService("DapVersionController", QStringList()<<"version");
        m_timerTimeoutService->start(10000);
    }
}

void DapModuleSettings::timeoutVersionInfo()
{
    QJsonObject objRes;
    objRes.insert("message", "Service not found");
    emit sigVersionInfo(objRes);
    m_timerTimeoutService->stop();
    m_guiVersionRequest = false;
    emit guiRequestChanged();
}

void DapModuleSettings::clearNodeData()
{
    s_serviceCtrl->requestToService("DapRemoveChainsOrGdbCommand", QStringList()<<"");
//    s_serviceCtrl->requestToService("DapNodeRestart", QStringList()<<"");
    m_clearDataProcessing = true;
    clearDataProcessingChanged();

    emit sigNodeDataRemoved();
}

void DapModuleSettings::resultCrearData(const QVariant& result)
{
    m_clearDataProcessing = false;
    clearDataProcessingChanged();
//    emit sigNodeDataRemoved();
//    qDebug()<<result;
}

void DapModuleSettings::setNodeStatus(bool isStart)
{
    m_isNodeStarted = isStart;
    emit isNodeStartedChanged();
}

void DapModuleSettings::setNodeAutorun(bool isEnable)
{
    if(m_isNodeAutoRun != isEnable)
    {
        m_isNodeAutoRun = isEnable;
        m_modulesCtrl->getSettings()->setValue(SETTINGS_NODE_ENABLE_KEY, m_isNodeAutoRun);
        emit isNodeAutorunChanged();
    }
}

void DapModuleSettings::nodeInfoRcv(const QVariant& rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    if(replyObj.contains("activeNode"))
    {
        setNodeStatus(replyObj["activeNode"].toBool());
    }
    else if(replyObj.contains("result"))
    {
        emit resultNodeRequest(replyObj["result"].toString());
    }
    else if(replyObj.contains("error"))
    {
        emit errorNodeRequest(replyObj["error"].toString());
    }
}

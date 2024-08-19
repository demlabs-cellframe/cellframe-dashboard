#include "DapModuleSettings.h"
#include "NodePathManager.h"

DapModuleSettings::DapModuleSettings(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_timerVersionCheck(new QTimer())
    , m_timerTimeoutService(new QTimer())
{
    updateUrlUpdateNode();

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

void DapModuleSettings::updateUrlUpdateNode()
{
    auto& pathManager = NodePathManager::getInstance();
    connect(&pathManager, &NodePathManager::checkedUrlSignal, [this](bool isReady)
            {
                QString ver = isReady ? QString(MAX_NODE_VERSION) : "";
                m_urlUpdateNode = NodePathManager::getInstance().getNodeUrl(ver);
                emit nodeUrlUpdated();
            });

    pathManager.tryCheckUrl(pathManager.getNodeUrl(QString(MAX_NODE_VERSION)));
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
    QJsonObject objRes = result.toJsonObject();

//    qDebug()<<objRes["message"].toString();

    if(objRes["message"].toString().contains("error"))
    {
        qWarning()<<objRes["message"].toString();
    }
    else if(objRes["message"].toString().contains("node"))
    {
        QString ver = objRes["lastVersion"].toString();
        if(m_nodeVersion == ver)
        {
            return;
        }
        m_nodeVersion = ver;
        if(m_nodeVersion.isEmpty())
        {
            if(nodeUpdateType::DOWNLOAD != m_nodeUpdateType)
            {
                setNodeUpdateType(nodeUpdateType::NONE);
            }
        }
        emit nodeVersionChanged();

        if(m_nodeVersion == QString(MAX_NODE_VERSION))
        {
            setNodeUpdateType(nodeUpdateType::EQUAL);
            return;
        }
        int minMinor, maxMinor, minMaj, maxMaj, minPat, maxPat, min, maj, pat;
        QRegularExpression regular(R"([0-9]{0,6}.[0-9]{0,6}-[0-9]{0,6})");
        auto separateData = [regular](const QString& ver, int& pat, int& min, int& maj) -> bool
        {
            if(!ver.contains(regular))
            {
                return false;
            }
            auto tmpMain = ver.split('.');
            if(tmpMain.size() != 2) return false;

            auto tmpPat = tmpMain[1].split('-');
            if(tmpPat.size() != 2) return false;

            pat = tmpPat[1].toInt();
            min = tmpPat[0].toInt();
            maj = tmpMain[0].toInt();
            return true;
        };

        if(!separateData(QString(MIN_NODE_VERSION), minPat, minMinor, minMaj))
        {
            qDebug() << "[DapModuleSettings] Problems parsing the minimum allowed version of a node";
            return;
        }
        if(!separateData(QString(MAX_NODE_VERSION), maxPat, maxMinor, maxMaj))
        {
            qDebug() << "[DapModuleSettings] Problems parsing the maximum allowed version of a node";
            return;
        }
        if(!separateData(m_nodeVersion, pat, min, maj))
        {
            qDebug() << "[DapModuleSettings] Problems parsing the current allowed version of a node";
            return;
        }

        auto comaperVer = [](const int cur, const int min, const int max) -> nodeUpdateType
        {
            if(cur == max && cur == min)
            {
                return nodeUpdateType::EQUAL;
            }
            else if(cur <= max && cur >= min)
            {
                if(cur < max)
                {
                    return nodeUpdateType::UPDATE;
                }
                else
                {
                    return nodeUpdateType::EQUAL;
                }
            }
            else if(cur < min)
            {
                return nodeUpdateType::LESS;
            }

            return nodeUpdateType::MORE;
        };

        auto majorType = comaperVer(maj, minMaj, maxMaj);
        if(majorType != nodeUpdateType::EQUAL)
        {
            setNodeUpdateType(majorType);
            emit needNodeUpdateSignal();
            return;
        }
        auto minorType = comaperVer(min, minMinor, maxMinor);
        if(minorType != nodeUpdateType::EQUAL)
        {
            setNodeUpdateType(minorType);
            emit needNodeUpdateSignal();
            return;
        }
        auto patType = comaperVer(pat, minPat, maxPat);
        if(patType != nodeUpdateType::EQUAL)
        {
            setNodeUpdateType(patType);
            emit needNodeUpdateSignal();
            return;
        }
        setNodeUpdateType(nodeUpdateType::EQUAL);
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

void DapModuleSettings::setNodeUpdateType(const nodeUpdateType type)
{
    if(m_nodeUpdateType != type)
    {
        m_nodeUpdateType = type;
        emit nodeUpdateTypeChanged();
    }
}

void DapModuleSettings::setNeedDownloadNode()
{
    setNodeUpdateType(nodeUpdateType::DOWNLOAD);
}

QString DapModuleSettings::getUrlUpload()
{
    return m_urlUpdateNode;
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

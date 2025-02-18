#include "DapModuleSettings.h"

#include <QQmlApplicationEngine>

DapModuleSettings::DapModuleSettings(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_timerVersionCheck(new QTimer())
    , m_timerTimeoutService(new QTimer())
    , m_instMngr(new DapNodeInstallManager())
{
    if(DapNodeMode::getNodeMode() == DapNodeMode::LOCAL)
    {
        connect(m_modulesCtrl->getAppEngine(), &QQmlApplicationEngine::objectCreated, this, [this] (QObject *object, const QUrl &url){
            Q_UNUSED(object)
            Q_UNUSED(url)
            checkNeedDownload();
        });
        connect(m_instMngr, &DapNodeInstallManager::singnalReadyUpdateToNode, [this] (bool isReady)
                {
                    emit checkedUrlSignal(isReady);
                });

        checkNeedDownload();

        updateUrlUpdateNode();
    }

    connect(m_modulesCtrl, &DapModulesController::initDone, [this] ()
    {
        initConnect();
        QString nodeMode = DapNodeMode::getNodeMode() == DapNodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;

        QVariantMap request = {{Dap::KeysParam::TYPE, Dap::TypeVersionKeys::GUI_VERSION}
                               ,{Dap::KeysParam::NODE_MODE_KEY, nodeMode}};
        s_serviceCtrl->requestToService("DapVersionController", request);
//        if(DapNodeMode::getNodeMode() == DapNodeMode::LOCAL)
        checkVersion();
        setStatusInit(true);
    });

    m_isNodeAutoRun = m_modulesCtrl->getSettings()->value(SETTINGS_NODE_ENABLE_KEY, true).toBool();
}

DapModuleSettings::~DapModuleSettings()
{
    disconnect();
    delete m_instMngr;
    delete m_timerVersionCheck;
    delete m_timerTimeoutService;
}

void DapModuleSettings::updateUrlUpdateNode()
{
    connect(this, &DapModuleSettings::checkedUrlSignal, [this](bool isReady)
            {
                QString maxVer = QString(MAX_NODE_VERSION);
                QString ver = isReady ? maxVer : "";
                m_urlUpdateNode = getNodeUrl(ver);
                m_isNodeUrlUpdated = true;
                emit nodeUrlUpdated();
            });

    tryCheckUrl(getNodeUrl(QString(MAX_NODE_VERSION)));
}

void DapModuleSettings::checkNeedDownload()
{
    /// Checking whether the node's local mode has been started.
    if(DapNodeMode::getNodeMode() == DapNodeMode::LOCAL && m_modulesCtrl->getCountRestart() > 1)
    {
        return;
    }
     // && !m_modulesCtrl->getCountRestart()
    if (!cellframe_node::getCellframeNodeInterface(DapNodeMode::getNodeMode()==DapNodeMode::LOCAL ? "local":"remote")->nodeInstalled())
    {
        emit signalIsNeedInstallNode(true, getUrlForNodeDownload());
    }
    else {
        emit signalIsNeedInstallNode(false, "");
    }
}

void DapModuleSettings::tryCheckUrl(const QString& url)
{
    m_instMngr->checkUpdateNode(url);
}

QString DapModuleSettings::getUrlForNodeDownload()
{
    return m_instMngr->getUrlForDownload();
}

QString DapModuleSettings::getNodeUrl(const QString& ver)
{
    if(ver.isEmpty())
    {
        return getUrlForNodeDownload();
    }
    return m_instMngr->getUrl(ver);
}

void DapModuleSettings::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::versionControllerResult, this, &DapModuleSettings::rcvVersionInfo);
    connect(s_serviceCtrl, &DapServiceController::rcvRemoveResult, this, &DapModuleSettings::resultCrearData);


    connect(m_timerVersionCheck, &QTimer::timeout, this, &DapModuleSettings::checkVersion);
    connect(m_timerTimeoutService, &QTimer::timeout, this, &DapModuleSettings::timeoutVersionInfo);

}

void DapModuleSettings::rcvVersionInfo(const QVariant& resultJson)
{
    QByteArray result = convertJsonResult(resultJson.toByteArray());
    auto resultObject = QJsonDocument::fromJson(result).object();

//    QJsonObject objRes = resultObject["result"].toObject();
//    qDebug()<<objRes["message"].toString();

    if(resultObject["message"].toString().contains("error"))
    {
        qWarning()<<resultObject["message"].toString();
    }
    else if(resultObject["message"].toString().contains("node"))
    {
        QString ver = resultObject["lastVersion"].toString();
        if(ver.isEmpty() || m_nodeVersion == ver)
        {
            return;
        }

        if(DapNodeMode::getNodeMode() == DapNodeMode::LOCAL)
        {
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
            auto emitNeedUpdate = [this]
            {
                /// Checking whether the node's local mode has been started.
                if(DapNodeMode::getNodeMode() == DapNodeMode::LOCAL && m_modulesCtrl->getCountRestart() > 1)
                {
                    return;
                }
                emit needNodeUpdateSignal();
            };


            if(majorType != nodeUpdateType::EQUAL)
            {
                setNodeUpdateType(majorType);
                emitNeedUpdate();
                return;
            }
            auto minorType = comaperVer(min, minMinor, maxMinor);
            if(minorType != nodeUpdateType::EQUAL)
            {
                setNodeUpdateType(minorType);
                emitNeedUpdate();
                return;
            }
            auto patType = comaperVer(pat, minPat, maxPat);
            if(patType != nodeUpdateType::EQUAL)
            {
                setNodeUpdateType(patType);
                emitNeedUpdate();
                return;
            }
            setNodeUpdateType(nodeUpdateType::EQUAL);
        }
        else
        {
            if(resultObject["lastVersion"].toString().contains("cellframe-node version"))
            {
                QJsonObject objRes = QJsonDocument::fromJson(resultObject["lastVersion"].toVariant().toByteArray()).object();
                QString dirtVersion = objRes["result"].toArray().first().toObject()["status"].toString();
                QString resVer = dirtVersion.remove("cellframe-node version").simplified();

                m_nodeVersion = resVer;
                emit nodeVersionChanged();
            }

        }
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

void DapModuleSettings::setNodeUpdateType(int type)
{
    nodeUpdateType tmpType = static_cast<nodeUpdateType>(type);
    if(m_nodeUpdateType != tmpType)
    {
        m_nodeUpdateType = tmpType;
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
    QString nodeMode = DapNodeMode::getNodeMode() == DapNodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;

    QVariantMap request = {{Dap::KeysParam::TYPE, Dap::TypeVersionKeys::NODE_VERSION}
                           ,{Dap::KeysParam::NODE_MODE_KEY, nodeMode}};
    s_serviceCtrl->requestToService("DapVersionController", request);
    m_timerVersionCheck->start(30000);
}

void DapModuleSettings::guiVersionRequest()
{
    if(!m_guiVersionRequest)
    {
        m_guiVersionRequest = true;
        emit guiRequestChanged();
        m_timerTimeoutService->stop();
        QString nodeMode = DapNodeMode::getNodeMode() == DapNodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;

        QVariantMap request = {{Dap::KeysParam::TYPE, Dap::TypeVersionKeys::GUI_VERSION}
                               ,{Dap::KeysParam::NODE_MODE_KEY, nodeMode}};
        s_serviceCtrl->requestToService("DapVersionController", request);
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

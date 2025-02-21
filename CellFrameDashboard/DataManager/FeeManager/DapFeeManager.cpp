#include "DapFeeManager.h"
#include "DapDataManagerController.h"

DapFeeManager::DapFeeManager(DapModulesController *moduleController)
    : DapFeeManagerBase(moduleController)
    , m_feeUpdateTimer(new QTimer())
    , m_rcvFeeTimeout(new QTimer())
{
    connect(m_feeUpdateTimer, &QTimer::timeout, this, &DapFeeManager::updateFee, Qt::QueuedConnection);
    connect(m_rcvFeeTimeout, &QTimer::timeout, this, &DapFeeManager::slotRcvFeeTimeout, Qt::QueuedConnection);

    connect(m_modulesController->getServiceController(), &DapServiceController::rcvFee, this, &DapFeeManager::rcvFee, Qt::QueuedConnection);
}

void DapFeeManager::initManager()
{
    updateFee();
}

void DapFeeManager::updateFee()
{
    m_feeUpdateTimer->stop();
    auto netList = m_modulesController->getManagerController()->getNetworkList();
    if(netList.isEmpty())
    {
        m_feeUpdateTimer->start(1000);
        m_lastNatworkRequest.clear();
        return;
    }

    if(m_lastNatworkRequest.isEmpty() || !netList.contains(m_lastNatworkRequest))
    {
        m_lastNatworkRequest = netList[0];
    }
    else
    {
        int netIndex = netList.indexOf(m_lastNatworkRequest);
        if(netList.size() - 1 == netIndex)
        {
            m_lastNatworkRequest.clear();
            m_feeUpdateTimer->start(TIME_FEE_UPDATE);
            return;
        }
        else
        {
            m_lastNatworkRequest = netList[netIndex + 1];
        }
    }
    requestFee(m_lastNatworkRequest);
}

void DapFeeManager::requestFee(const QString &network)
{
    m_isRequestData = true;
    QString currentMode = DapNodeMode::getNodeMode() == DapNodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
    QVariantMap request = {{Dap::KeysParam::NETWORK_NAME, network}
                           ,{Dap::KeysParam::NODE_MODE_KEY, currentMode}};
    m_modulesController->getServiceController()->requestToService("DapGetFeeCommand", request);
    m_rcvFeeTimeout->start(TIME_FEE_TIMEOUT);
}

void DapFeeManager::rcvFee(const QVariant &rcvData)
{
    if(!m_isRequestData)
    {
        return;
    }
    m_isRequestData = false;

    QByteArray byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());

    auto feeDoc = QJsonDocument::fromJson(byteArrayData);

    QJsonObject feeObject = feeDoc.object();
    if(feeObject.isEmpty())
    {
        qDebug() << "[DapModuleWallet] The list of networks is empty";
        return;
    }

    m_rcvFeeTimeout->stop();

    for(const auto& networkName: feeObject.keys())
    {
        QJsonObject networkObj = feeObject[networkName].toObject();
        CommonWallet::FeeInfo tmpFeeInfo;
        if(!networkObj.contains("network_fee"))
        {
            qDebug() << "[DapModuleWallet] There is no information on the network commission";
        }
        else
        {
            QJsonObject netFeeObject = networkObj["network_fee"].toObject();
            QStringList netFeeKeys = netFeeObject.keys();
            for(const QString& itemName: netFeeKeys)
            {
                tmpFeeInfo.netFee.insert(itemName, netFeeObject[itemName].toString());
            }
        }

        if(!networkObj.contains("validator_fee"))
        {
            qDebug() << "[DapModuleWallet] There is no information on the validator commission";
        }
        else
        {
            QJsonObject netValidatorObject = networkObj["validator_fee"].toObject();
            QStringList validatorKeys = netValidatorObject.keys();
            for(const QString& itemName: validatorKeys)
            {
                tmpFeeInfo.validatorFee.insert(itemName, netValidatorObject[itemName].toString());
            }
        }

        if(!m_feeInfo.contains(networkName)
            || tmpFeeInfo.netFee != m_feeInfo.value(networkName).netFee
            || tmpFeeInfo.validatorFee != m_feeInfo.value(networkName).validatorFee)
        {
            m_feeInfo.insert(networkName, std::move(tmpFeeInfo));
            emit feeUpdated(networkName);
        }
    }
    updateFee();
}

void DapFeeManager::slotRcvFeeTimeout()
{
    m_lastNatworkRequest.clear();
    updateFee();
}

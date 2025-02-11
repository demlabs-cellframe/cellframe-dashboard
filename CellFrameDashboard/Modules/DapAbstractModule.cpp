#include "DapAbstractModule.h"
#include "DapModulesController.h"

DapAbstractModule::DapAbstractModule(DapModulesController *parent)
    :QObject(parent)
{
    s_serviceCtrl = parent->getServiceController();
    m_modulesCtrl = parent;

    connect(m_modulesCtrl, &DapModulesController::sigUpdateData, this, &DapAbstractModule::slotUpdateData);
}

DapAbstractModule::~DapAbstractModule()
{
    disconnect(m_modulesCtrl, &DapModulesController::sigUpdateData, this, &DapAbstractModule::slotUpdateData);

    s_serviceCtrl = nullptr;
    m_modulesCtrl = nullptr;
}

QByteArray DapAbstractModule::convertJsonResult(const QByteArray &data)
{
    QByteArray resultByteArray;

    QJsonDocument replyDoc = QJsonDocument::fromJson(data);
    QJsonObject replyObj = replyDoc.object();

    if(replyObj["result"].isObject())
    {
        QJsonObject resultObj = replyObj["result"].toObject();
        QJsonDocument result(resultObj);
        resultByteArray = result.toJson();
    }
    else if(replyObj["result"].isArray())
    {
        QJsonArray resultArr = replyObj["result"].toArray();
        QJsonDocument result(resultArr);
        resultByteArray = result.toJson();
    }
    else
    {
        QString resultStr = replyObj["result"].toString();
        resultByteArray = resultStr.toUtf8();
    }

    return resultByteArray;
}

bool DapAbstractModule::statusProcessing()
{
    return m_statusProcessing;
}
void DapAbstractModule::setStatusProcessing(bool status)
{
    m_statusProcessing = status;
    emit statusProcessingChanged();
}

void DapAbstractModule::setName(QString name)
{
    m_name = name;
}

QString DapAbstractModule::getName()
{
    return m_name;
}

void DapAbstractModule::setStatusInit(bool status)
{
    m_statusInit = status;
    emit statusInitChanged();
}


#include "DapNotifyController.h"
#include "qjsondocument.h"
#include "qjsonobject.h"
#include "DapNodePathManager.h"

DapNotifyController::DapNotifyController(QObject * parent)
    : QObject(parent)
    , m_timerCheckNetPack(new QTimer())
{
    connect(m_timerCheckNetPack, &QTimer::timeout, this, &DapNotifyController::timeoutNetRcv);
}

void DapNotifyController::init()
{
    m_watcher = new DapNotificationWatcher();

    connect(m_watcher, &DapNotificationWatcher::rcvNotify, this, &DapNotifyController::rcvData);
    connect(m_watcher, &DapNotificationWatcher::changeConnectState, this, [this](QString status)
            {
                stateProcessing(status);
            });

    m_watcher->run();
}

void DapNotifyController::stateProcessing(QString status)
{
    if(status != m_connectState)
    {
        m_connectState = status;

        if(status != QAbstractSocket::SocketState::ConnectedState)
        {
            m_timerCheckNetPack->stop();
            m_isConnected = false;
            emit socketState(m_connectState, true, true);
        }
        else
        {
            m_timerCheckNetPack->start(5000);
            m_isConnected = true;
            emit socketState(m_connectState, false, false);
        }
        emit isConnectedChanged(m_isConnected);
    }
}

void DapNotifyController::rcvData(QVariant data)
{
    if(!data.isValid())
        return;

    QJsonObject resObj = QJsonDocument::fromVariant(data).object();

    if(resObj.contains("class"))
    {
        QString className = resObj["class"].toString();
        //----old----//
        if(className == "Wallet")
        {
        }
        else if(className == "NetStates")
        {
            emit netStates(resObj.toVariantMap());
        }
        //----new----//
        else if(className ==  "NetList")
        {
            QJsonDocument result = parseData(className, resObj, "networks", true);

            if(!result.isEmpty() && result.array().count())
            {
                m_timerCheckNetPack->stop();
                emit sigNotifyRcvNetList(result);
            }
        }
        else if(className ==  "NetsInfo")
        {
            QJsonDocument result = parseData(className, resObj, "networks", false);
            if(!result.isEmpty())
                emit sigNotifyRcvNetsInfo(result);
        }
        else if(className ==  "WalletList")
        {
            QJsonDocument result = parseData(className, resObj, "wallets", true);
            if(!result.isEmpty())
                emit sigNotifyRcvWalletList(result);
        }
        else if(className ==  "WalletsInfo")
        {
            QJsonDocument result = parseData(className, resObj, "wallets", false);
            if(!result.isEmpty())
                emit sigNotifyRcvWalletsInfo(result);
        }
        else if(className ==  "NetInfo")
        {
            QJsonDocument result = parseData(className, resObj, "", false);
            if(!result.isEmpty())
                emit sigNotifyRcvNetInfo(result);
        }
        else if(className ==  "WalletInfo")
        {
            QJsonDocument result = parseData(className, resObj, "", false);
            if(!result.isEmpty())
                emit sigNotifyRcvWalletInfo(result);
        }
        else
        {
//            qDebug()<<"Unknown class: " << className;
        }
    }
}

QJsonDocument DapNotifyController::parseData(QString className, const QJsonObject obj, QString key, bool isArray)
{
//    qDebug()<<className;

    QJsonDocument result;

    if(key.isEmpty())
    {
        result.setObject(obj);
        return result;
    }

    if((isArray && !obj[key].isArray()) || (!isArray && !obj[key].isObject()))
    {
        qDebug()<<"[DapNotifyController::parseData] " << className << " is not " << (isArray ? "array" : "object");
        return QJsonDocument();
    }

    if(isArray)
    {
        QJsonArray array = obj[key].toArray();
        result.setArray(array);
    }
    else
    {
        QJsonObject object = obj[key].toObject();
        result.setObject(object);
    }

    return result;
}

void DapNotifyController::timeoutNetRcv()
{
    qWarning()<<"Timeout waiting notify: net list";
    emit sigNotifyRcvNetList(QJsonDocument(QJsonArray{"notify_timeout"})); //send empty net list
}

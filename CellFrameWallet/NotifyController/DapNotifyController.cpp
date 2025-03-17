#include "DapNotifyController.h"

DapNotifyController::DapNotifyController(QObject * parent)
    : QObject(parent)
    , m_timerCheckNetPack(new QTimer())
{
    connect(m_timerCheckNetPack, &QTimer::timeout, this, &DapNotifyController::timeoutNetRcv);

}

void DapNotifyController::init()
{
    if(DapNodeMode::getNodeMode()==DapNodeMode::LOCAL)
    {
        m_initTimer = new QTimer(this);

        m_initTimer->start(5000);
        connect(m_initTimer, &QTimer::timeout, [this]
        {
            qDebug()<<"Reinit notify timer tick";
            bool isInstalled = cellframe_node::getCellframeNodeInterface("local")->nodeInstalled();

            if(isInstalled)
            {
                m_initTimer->stop();

                m_node_notify = std::shared_ptr<cellframe_node::notify::CellframeNotificationChannel>(cellframe_node::getCellframeNodeInterface("local")->openNotificationChannel());

                m_node_notify->addNotifyDataCallback([this](const std::string &data)
                                                     {
                                                         rcvData(QJsonDocument::fromJson(data.c_str()).toVariant());
                                                     });

                m_node_notify->addNotifyStatusCallback([this](const cellframe_node::notify::CellframeNotificationChannel::E_NOTIFY_STATUS &status)
                                                       {
                                                           if(status != m_connectState)
                                                           {
                                                               m_connectState = status;

                                                               if(status == cellframe_node::notify::CellframeNotificationChannel::CONNECTED)
                                                               {
                                                                   m_timerCheckNetPack->stop();
                                                                   m_isConnected = true;
                                                                   emit notifySocketStateChanged(m_isConnected);
                                                               }
                                                               else
                                                               {
                                                                   m_timerCheckNetPack->start(5000);
                                                                   m_isConnected = false;
                                                                   emit notifySocketStateChanged(m_isConnected);
                                                               }
                                                           }
                                                       });

                m_connectState = m_node_notify->status(); //for init
                emit notifySocketStateChanged(m_connectState);
            }
        });
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

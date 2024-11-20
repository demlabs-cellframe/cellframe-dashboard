#include "DapNotifyController.h"
#include "qjsondocument.h"
#include "qjsonobject.h"
#include "DapNodePathManager.h"

DapNotifyController::DapNotifyController(QObject * parent) : QObject(parent)
{

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
            emit chainsLoadProgress(QVariantMap());
            m_isConnected = false;
            emit socketState(m_connectState, true, true);
        }
        else
        {
            m_isConnected = true;
            emit socketState(m_connectState, false, false);
        }
        emit isConnectedChanged();
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
        else if(className == "chain_init")
        {
            qDebug() << "[DapNotifyController] chain init - " << resObj.toVariantMap();
            emit chainsLoadProgress(resObj.toVariantMap());
        }
        //----new----//
        else if(className ==  "NetList")
        {
            qDebug()<<className;
        }
        else if(className ==  "NetsInfo")
        {
            qDebug()<<className;
        }
        else if(className ==  "WalletList")
        {
            qDebug()<<className;
        }
        else if(className ==  "WalletsInfo")
        {
            qDebug()<<className;
        }
        else if(className ==  "NetInfo")
        {
            qDebug()<<className;
        }
        else if(className ==  "WalletInfo")
        {
            qDebug()<<className;
        }else
            qDebug()<<"Unknown class: " << className;
    }
}

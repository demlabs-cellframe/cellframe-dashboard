#ifndef DAPMODULENETWORKS_H
#define DAPMODULENETWORKS_H

#include <QObject>
#include <QDebug>
#include <QQmlContext>

#include <cmath>

#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "Models/DapNetworkModel.h"

class DapModuleNetworks : public DapAbstractModule
{
    Q_OBJECT

public:
    explicit DapModuleNetworks(DapModulesController *parent);
    ~DapModuleNetworks();

public:
    Q_INVOKABLE void goSync();
    Q_INVOKABLE void goOnline();
    Q_INVOKABLE void goOffline();

private:
    QString convertState(QString state);
    QString convertProgress(QJsonObject obj);

    DapNetworkModel::Item itemModelGenerate(QString netName, QJsonObject itemModel);
    void updateItemModel(DapNetworkModel::Item itmModel);
    void updateFullModel(QJsonDocument docModel);
    int getIndexItemModel(QString netName);

private:
    DapModulesController  *m_modulesCtrl = nullptr;
    DapNetworkModel *m_networkModel = nullptr;
    DapNotifyController *m_notifyCtrl = nullptr;
    QStringList s_netList = QStringList();

    struct NetLoadProgress{
        QString name{""};
        QString state{""};
        QString percent{""};
    };
    QMap<QString, NetLoadProgress> m_netsLoadProgress;
    QString m_totalProgressNetsLoad;

private slots:
    void slotRcvNotifyNetList(QJsonDocument doc);
    void slotRcvNotifyNetInfo(QJsonDocument doc);
    void slotRcvNotifyNetsInfo(QJsonDocument doc);

    void slotUpdateItemNetLoad(NetLoadProgress netItm);

signals:
    void sinNetsLoading(bool isLoading);
    void sigNetLoadProgress(QString progress);
    void sigUpdateItemNetLoad(NetLoadProgress netItm);
};


#endif // DAPMODULENETWORKS_H

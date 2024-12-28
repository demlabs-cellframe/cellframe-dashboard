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

    struct NetLoadProgress{
        QString name{""};
        QString state{""};
        QString percent{""};
    };

public:
    explicit DapModuleNetworks(DapModulesController *parent);
    ~DapModuleNetworks();

private:
    QString convertState(QString state);
    QString convertProgress(QJsonObject obj);

    DapNetworkModel::Item itemModelGenerate(QString netName, QJsonObject itemModel);
    void updateItemModel(DapNetworkModel::Item itmModel);
    void updateFullModel(QJsonDocument docModel);
    int getIndexItemModel(QString netName);

    void clearAll();

private slots:
    void slotRcvNotifyNetList(QJsonDocument doc);
    void slotRcvNotifyNetInfo(QJsonDocument doc);
    void slotRcvNotifyNetsInfo(QJsonDocument doc);

    void slotUpdateItemNetLoad();

    void slotNotifyIsConnected(bool isConnected);

public:
    Q_INVOKABLE void goSync(QString net);
    Q_INVOKABLE void goOnline(QString net);
    Q_INVOKABLE void goOffline(QString net);

signals:
    void sigNetsLoading(bool isLoading);
    void sigNetLoadProgress(int progress);
    void sigUpdateItemNetLoad();

private:
    DapModulesController  *m_modulesCtrl = nullptr;
    DapNetworkModel *m_networkModel = nullptr;
    DapNotifyController *m_notifyCtrl = nullptr;
    QStringList s_netList = QStringList();

    QMap<QString, NetLoadProgress> m_netsLoadProgress;
    int m_totalProgressNetsLoad;
};


#endif // DAPMODULENETWORKS_H

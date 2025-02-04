#ifndef DAPMODULENETWORKS_H
#define DAPMODULENETWORKS_H

#include <QObject>
#include <QDebug>
#include <QQmlContext>

#include <cmath>

#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "Models/DapNetworkModel.h"
#include "DapNetworksTypes.h"

class DapModuleNetworks : public DapAbstractModule
{
    Q_OBJECT

public:
    explicit DapModuleNetworks(DapModulesController *parent);
    ~DapModuleNetworks();

    Q_INVOKABLE void goSync(QString net);
    Q_INVOKABLE void goOnline(QString net);
    Q_INVOKABLE void goOffline(QString net);

signals:
    void sigNetsLoading(bool isLoading);
    void sigNetLoadProgress(int progress);
    void sigUpdateItemNetLoad();

private slots:
    void deleteNetworksSlot(const QStringList& list);
    void updateModelInfo(const NetworkInfo& info);
    void networkListChangedSlot();
    void slotUpdateItemNetLoad();

    void slotNotifyIsConnected(bool isConnected);

private:
    QString convertProgress(QJsonObject obj);

    int getIndexItemModel(QString netName);

    void clearAll();

private:
    DapNetworkModel *m_networkModel = nullptr;
    DapStringListModel* m_netListModel = nullptr;
};

#endif // DAPMODULENETWORKS_H

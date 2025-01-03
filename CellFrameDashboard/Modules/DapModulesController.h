#ifndef DAPMODULESCONTROLLER_H
#define DAPMODULESCONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QJsonArray>

#include "Workers/dateworker.h"
#include "Workers/stringworker.h"
#include "Workers/mathworker.h"

#include "DapAbstractModule.h"
#include "../DapServiceController.h"
#include "Models/DapStringListModel.h"
#include "Models/DapNetworkList.h"
#include "qsettings.h"
#include "NotifyController/DapNotifyController.h"

class DapModulesController : public QObject
{
    Q_OBJECT
public:
    DapModulesController(QQmlApplicationEngine *appEngine, QObject *parent = nullptr);
    ~DapModulesController();

    DapServiceController* getServiceController() const {return s_serviceCtrl;}

    QSettings* getSettings() {return s_settings;}
    void tryStartModules() { emit initDone(); }
    const QStringList& getNetworkList() const {return m_netList;}
    void setCurrentWallet(const QPair<int,QString>& dataWallet);
    void setWalletList(const QStringList& walletList);
    const QStringList& getWalletList() const { return m_walletList; }
    int getCurrentWalletIndex() const { return m_currentWalletIndex; }
    const QString& getCurrentWalletName() const { return m_currentWalletName; }

    void initModules();
    void initWorkers();
    void restoreIndex();

    void addModule(const QString &key, DapAbstractModule *p_module);
    DapAbstractModule* getModule(const QString &key);

    void addWorker(const QString &key, QObject *p_worker);
    QObject* getWorker(const QString &key);
    QQmlApplicationEngine* getAppEngine() {return s_appEngine;}



    DapServiceController *s_serviceCtrl;

    Q_PROPERTY (int currentWalletIndex READ currentWalletIndex WRITE setCurrentWalletIndex NOTIFY currentWalletIndexChanged)
    int currentWalletIndex(){return m_currentWalletIndex;}
    void setCurrentWalletIndex(int newIndex);
    Q_PROPERTY (QString currentWalletName READ currentWalletName NOTIFY currentWalletNameChanged)
    QString currentWalletName(){return m_currentWalletName;}

    Q_PROPERTY (bool isNodeWorking READ isNodeWorking NOTIFY nodeWorkingChanged)
    bool isNodeWorking(){return m_isNodeWorking;}

    Q_PROPERTY (int nodeLoadProgress READ nodeLoadProgress NOTIFY nodeLoadProgressChanged)
    int nodeLoadProgress(){return m_nodeLoadProgress;}

    Q_INVOKABLE bool isFirstLaunch() { return m_lastProgress == 0; }

    void setNotifyCtrl(DapNotifyController * notifyController);
    DapNotifyController* getNotifyCtrl(){return m_notifyCtrl;}

    Q_INVOKABLE QString getCurrentNetwork() const {return m_currentNetworkName;}
    void setCurrentNetwork(const QString& name);

public slots:
    Q_INVOKABLE void updateListWallets();
    Q_INVOKABLE void updateListNetwork();
    void setNodeLoadProgress(int progress);
    void setIsNodeWorking(bool);

    void slotRcvNotifyWalletList(QJsonDocument doc);
    void slotRcvNotifyWalletInfo(QJsonDocument doc);
    void slotRcvNotifyWalletsInfo(QJsonDocument doc);

    void slotRcvNotifyNetList(QJsonDocument doc);
    void slotRcvNotifyNetInfo(QJsonDocument doc);
    void slotRcvNotifyNetsInfo(QJsonDocument doc);

private slots:

    void rcvNetList(const QVariant &rcvData);

signals:
    void initDone();

    void walletsListUpdated();
    void netListUpdated();
    void currentWalletIndexChanged();
    void currentWalletNameChanged();
    void currentNetworkChanged(QString netName);
    void sigFeeRcv(const QVariant &rcvData);

    void feeUpdateChanged();

    void nodeWorkingChanged();
    void nodeLoadProgressChanged();

    void sigNotifyControllerIsInit();
private:
    void updateNetworkListModel();

    void clearProgressInfo();
private:

    //Other
    DapNotifyController * m_notifyCtrl;

    QQmlApplicationEngine *s_appEngine;
    //Modules
    QMap<QString, DapAbstractModule*> m_listModules;
    QMap<QString, QObject*> m_listWorkers;

    //workers
    DateWorker * m_dateWorker;
    StringWorker * m_stringWorker;
    MathWorker * m_mathWorker;

    QSettings *s_settings;
    DapStringListModel* m_netListModel = nullptr;

    bool m_firstDataLoad{false}; 
    QStringList m_netList;

    QMap<QString, QMap<int, int>> m_networksLoadProgress;
    QJsonArray nodeLoadProgressJson;
    int m_nodeLoadProgress = 0;
    // Need to know it was first launch or restore after reboot node
    int m_lastProgress = 0;

    QStringList m_walletList;
    int m_currentWalletIndex{-1};
    QString m_currentWalletName{""};
    QString m_currentNetworkName = "";


    bool m_isNodeWorking = false;

    bool m_skinWallet = false;
};

#endif // DAPMODULESCONTROLLER_H

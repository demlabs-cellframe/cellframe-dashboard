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
#include "qsettings.h"
#include "../ConfigWorker/configworker.h"

#include "../NotifyController/DapNotifyController.h"

class DapDataManagerController;
class DapApplication;

class DapModulesController : public QObject
{
    Q_OBJECT
public:
    DapModulesController(QQmlApplicationEngine *appEngine, DapApplication* applicationManager, QObject *parent = nullptr);
    ~DapModulesController();

    DapServiceController* getServiceController() const;
    DapApplication* getAppManager() const;
    void sendRequestToService(const QString& asServiceName, const QVariant &args = QVariant());

    void setConfigWorker(ConfigWorker* worker) {m_configWorker = worker;}
    ConfigWorker* getConfigWorker() {return m_configWorker;}

    QSettings* getSettings() {return s_settings;}
    void setWalletList(const QStringList& walletList);

    void initModules();
    void initWorkers();

    void addModule(const QString &key, DapAbstractModule *p_module);
    DapAbstractModule* getModule(const QString &key);

    void addWorker(const QString &key, QObject *p_worker);
    QObject* getWorker(const QString &key);
    QQmlApplicationEngine* getAppEngine() {return s_appEngine;}

    Q_PROPERTY (bool isNodeWorking READ isNodeWorking NOTIFY nodeWorkingChanged)
    bool isNodeWorking(){return m_isNodeWorking;}

    Q_PROPERTY (int nodeLoadProgress READ nodeLoadProgress NOTIFY nodeLoadProgressChanged)
    int nodeLoadProgress(){return m_nodeLoadProgress;}

    Q_INVOKABLE bool isFirstLaunch() { return m_lastProgress == 0; }

    void setNotifyCtrl(DapNotifyController * notifyController);
    DapNotifyController* getNotifyCtrl(){return m_notifyCtrl;}

    DapDataManagerController* getManagerController() const {return m_managerController; }
    
    Q_INVOKABLE QString getCurrentNetwork() const {return m_currentNetworkName;}
    void setCurrentNetwork(const QString& name);
public slots:
    void setNodeLoadProgress(int progress);
    void setIsNodeWorking(bool);

    void slotRcvNotifyWalletList(QJsonDocument doc);
    void slotRcvNotifyWalletInfo(QJsonDocument doc);
    void slotRcvNotifyWalletsInfo(QJsonDocument doc);

signals:
    void initDone();

    void currentNetworkChanged(QString netName);

    void nodeWorkingChanged();
    void nodeLoadProgressChanged();

    void sigNotifyControllerIsInit();
private slots:
    void readyReceiveData();
private:
    void cleareProgressInfo();
private:
    DapApplication* m_appManager = nullptr;
    //Other
    DapNotifyController * m_notifyCtrl;
    DapDataManagerController* m_managerController = nullptr;

    QQmlApplicationEngine *s_appEngine;

    //Modules
    QMap<QString, DapAbstractModule*> m_listModules;
    QMap<QString, QObject*> m_listWorkers;

    //workers
    DateWorker * m_dateWorker;
    StringWorker * m_stringWorker;
    MathWorker * m_mathWorker;

    QSettings *s_settings;

    bool m_firstDataLoad{false}; 

    QMap<QString, QMap<int, int>> m_networksLoadProgress;
    QJsonArray nodeLoadProgressJson;
    int m_nodeLoadProgress = 0;
    // Need to know it was first launch or restore after reboot node
    int m_lastProgress = 0;

    QString m_currentNetworkName = "";

    ConfigWorker *m_configWorker = nullptr;

    bool m_isNodeWorking = false;

    bool m_skinWallet = false;
};

#endif // DAPMODULESCONTROLLER_H

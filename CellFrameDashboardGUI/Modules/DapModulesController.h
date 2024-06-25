#ifndef DAPMODULESCONTROLLER_H
#define DAPMODULESCONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>

#include "Workers/dateworker.h"
#include "Workers/stringworker.h"
#include "Workers/mathworker.h"

#include "DapAbstractModule.h"
#include "../DapServiceController.h"
#include "Models/DapStringListModel.h"
#include "qsettings.h"
#include "../ConfigWorker/configworker.h"

class DapModulesController : public QObject
{
    Q_OBJECT
public:
    DapModulesController(QQmlApplicationEngine *appEngine, QObject *parent = nullptr);
    ~DapModulesController();

    DapServiceController* getServiceController() const {return s_serviceCtrl;}
    void setConfigWorker(ConfigWorker* worker) {m_configWorker = worker;}
    ConfigWorker* getConfigWorker() {return m_configWorker;}

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

    QQmlApplicationEngine *s_appEngine;

    DapServiceController *s_serviceCtrl;   

    Q_PROPERTY (int currentWalletIndex READ currentWalletIndex WRITE setCurrentWalletIndex NOTIFY currentWalletIndexChanged)
    int currentWalletIndex(){return m_currentWalletIndex;};
    void setCurrentWalletIndex(int newIndex);
    Q_PROPERTY (QString currentWalletName READ currentWalletName NOTIFY currentWalletNameChanged)
    QString currentWalletName(){return m_currentWalletName;}

    Q_PROPERTY (int isNodeWorking READ isNodeWorking NOTIFY nodeWorkingChanged)
    int isNodeWorking(){return m_isNodeWorking;};

public slots:
    Q_INVOKABLE void updateListWallets();
    Q_INVOKABLE void updateListNetwork();

private slots:

    void rcvNetList(const QVariant &rcvData);

signals:
    void initDone();

    void walletsListUpdated();
    void netListUpdated();
    void currentWalletIndexChanged();
    void currentWalletNameChanged();
    void sigFeeRcv(const QVariant &rcvData);

    void feeUpdateChanged();

    void nodeWorkingChanged();
private:
    void updateNetworkListModel();
private:

    //Modules
    QMap<QString, DapAbstractModule*> m_listModules;
    QMap<QString, QObject*> m_listWorkers;

    //workers
    DateWorker * m_dateWorker;
    StringWorker * m_stringWorker;
    MathWorker * m_mathWorker;

    QTimer *m_timerUpdateData;
    QSettings *s_settings;
    DapStringListModel* m_netListModel = nullptr;

    bool m_firstDataLoad{false}; 
    QStringList m_netList;

    QStringList m_walletList;
    int m_currentWalletIndex{-1};
    QString m_currentWalletName{""};

    ConfigWorker *m_configWorker = nullptr;

    bool m_isNodeWorking = false;
};

#endif // DAPMODULESCONTROLLER_H

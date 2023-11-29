#ifndef DAPMODULESCONTROLLER_H
#define DAPMODULESCONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>

#include "Workers/dateworker.h"
#include "Workers/stringworker.h"
#include "Workers/mathworker.h"

#include "DapAbstractModule.h"
#include "../DapServiceController.h"
#include "qsettings.h"

class DapModulesController : public QObject
{
    Q_OBJECT
public:
    DapModulesController(QQmlApplicationEngine *appEngine, QObject *parent = nullptr);
    ~DapModulesController();

    DapServiceController* getServiceController() {return s_serviceCtrl;}
    QSettings* getSettings() {return s_settings;}
    void tryStartModules() { emit initDone(); }
    const QStringList& getNetworkList() const {return m_netList;}
    void setCurrentWallet(const QPair<int,QString>& dataWallet);
    void setWalletList(const QStringList& walletList);
    const QStringList& getWalletList() const { return m_walletList; }
    int getCurrentWalletIndex() const { return m_currentWalletIndex; }
    const QString& getCurrentWalletName() const { return m_currentWalletName; }

    QQmlApplicationEngine *s_appEngine;
    //Modules
    QMap<QString, DapAbstractModule*> m_listModules;
    QMap<QString, QObject*> m_listWorkers;

    DapServiceController *s_serviceCtrl;   
    // QByteArray m_walletList;


    Q_PROPERTY (int currentWalletIndex READ currentWalletIndex WRITE setCurrentWalletIndex NOTIFY currentWalletIndexChanged)
    int currentWalletIndex(){return m_currentWalletIndex;};
    void setCurrentWalletIndex(int newIndex);
    Q_PROPERTY (QString currentWalletName READ currentWalletName NOTIFY currentWalletNameChanged)
    QString currentWalletName(){return m_currentWalletName;};
    Q_PROPERTY(bool feeUpdate READ feeUpdate WRITE setFeeUpdate NOTIFY feeUpdateChanged)
    bool feeUpdate(){return m_flagFeeUpdate;};
    void setFeeUpdate(bool flag);

    Q_INVOKABLE void getComission(QString network);

    QString testData{"test data"};

    QJsonDocument m_feeDoc;


    //workers
    DateWorker * m_dateWorker;
    StringWorker * m_stringWorker;
    MathWorker * m_mathWorker;

public:
    void initModules();
    void initWorkers();
    void restoreIndex();

    void addModule(const QString &key, DapAbstractModule *p_module);
    DapAbstractModule* getModule(const QString &key);

    void addWorker(const QString &key, QObject *p_worker);
    QObject* getWorker(const QString &key);
    QQmlApplicationEngine* getAppEngine() {return s_appEngine;}

private:
    QTimer *m_timerUpdateData, *m_timerUpdateFee;
    QSettings *s_settings;

    bool m_firstDataLoad{false};
    bool m_flagFeeUpdate{false};
    
    QStringList m_netList;

    QStringList m_walletList;
    int m_currentWalletIndex{-1};
    QString m_currentWalletName{""};
public slots:
    Q_INVOKABLE void updateListWallets();
    Q_INVOKABLE void updateListNetwork();
    Q_INVOKABLE void getFee();

private slots:

    void rcvNetList(const QVariant &rcvData);
    void rcvFee(const QVariant &rcvData);

signals:
    void initDone();

    void walletsListUpdated();
    void netListUpdated();
    void currentWalletIndexChanged();
    void currentWalletNameChanged();
    void sigFeeRcv(const QVariant &rcvData);

    void feeUpdateChanged();

};

#endif // DAPMODULESCONTROLLER_H

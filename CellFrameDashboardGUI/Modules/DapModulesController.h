#ifndef DAPMODULESCONTROLLER_H
#define DAPMODULESCONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>

#include "DapAbstractModule.h"
#include "../DapServiceController.h"

class DapModulesController : public QObject
{
    Q_OBJECT
public:
    DapModulesController(QQmlApplicationEngine *appEngine, QObject *parent = nullptr);
    ~DapModulesController();

    QQmlApplicationEngine *s_appEngine;
    //Modules
    QMap<QString, DapAbstractModule*> m_listModules;

    DapServiceController *s_serviceCtrl;

    QVariantList m_netList, m_walletList;
    int m_currentWalletIndex{-1};
    QString m_currentWalletName{""};

    Q_PROPERTY (int currentWalletIndex READ currentWalletIndex WRITE setCurrentWalletIndex NOTIFY currentWalletIndexChanged)
    int currentWalletIndex(){return m_currentWalletIndex;};
    void setCurrentWalletIndex(int newIndex);
    Q_PROPERTY (QString currentWalletName READ currentWalletName NOTIFY currentWalletNameChanged)
    QString currentWalletName(){return m_currentWalletName;};

    Q_INVOKABLE QString getComission(QString token, QString network);

    QString testData{"test data"};

public:
    void initModules();
    void restoreIndex();

    void addModule(const QString &key, DapAbstractModule *p_module);
    DapAbstractModule* getModule(const QString &key);

private:
    QTimer *m_timerUpdateData;
    QSettings *s_settings;

    bool m_firstDataLoad{false};

public slots:
    void getWalletList();
    void getNetworkList();

private slots:

    void rcvWalletList(const QVariant &rcvData);
    void rcvNetList(const QVariant &rcvData);

signals:
    void initDone();

    void walletsListUpdated();
    void netListUpdated();
    void currentWalletIndexChanged();
    void currentWalletNameChanged();

};

#endif // DAPMODULESCONTROLLER_H

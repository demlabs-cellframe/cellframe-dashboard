#ifndef DAPMODULESCONTROLLER_H
#define DAPMODULESCONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QDebug>

#include "DapServiceController.h"
#include "DapAbstractModule.h"

class DapModulesController : public QObject
{
    Q_OBJECT
public:
    explicit DapModulesController(QObject *parent = nullptr);
    ~DapModulesController();

public:
    DapServiceController  *s_serviceCtrl;
    QMap<QString, DapAbstractModule*> m_listModules;

    QVariantList m_netList, m_walletList;
    int m_currentWalletIndex;
    QString m_currentWalletName;

    QString testData{"test data"};

public:
    static DapModulesController &getInstance();
    void setListModules(QMap<QString, DapAbstractModule*> &list);
    QMap<QString, DapAbstractModule*> getListModules();

private:
    QTimer *m_timerUpdateData;

private slots:
    void getWalletList();
    void getNetworkList();

    void rcvWalletList(const QVariant &rcvData);
    void rcvNetList(const QVariant &rcvData);


};

#endif // DAPMODULESCONTROLLER_H

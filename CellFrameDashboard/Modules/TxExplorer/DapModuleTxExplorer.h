#ifndef DAPMODULETXEXPLORER_H
#define DAPMODULETXEXPLORER_H

#include <QObject>
#include <QDebug>

#include "../DapModulesController.h"
#include "Models/DapHistoryModel.h"
#include "Models/DapHistoryProxyModel.h"
#include "DapWalletsManagerBase.h"

class DapModuleTxExplorer : public DapAbstractModule
{
    Q_OBJECT

    // Q_PROPERTY(QString walletName     READ walletName      WRITE setWalletName)
public:
    explicit DapModuleTxExplorer(DapModulesController * modulesCtrl);

    // QString walletName() const { return m_walletName; }

    Q_INVOKABLE void clearHistory();
    Q_INVOKABLE void updateHistory();

signals:
    void updateHistoryModel();

protected slots:
    virtual void setHistoryModel(const QVariant &rcvData);
    virtual void cleareData();

private slots:
    void slotHistoryUpdate();
    void walletInfoChangedsSlot(const QString& walletName, const QString& networkName);
private:
    void initConnect();
    DapWalletsManagerBase* getWalletManager() const;
    QString getNewLastNetwork();
protected:
    QTimer *m_timerHistoryUpdate = nullptr;
    QTimer *m_timerRequest = nullptr;
    DapHistoryProxyModel *m_historyProxyModel = nullptr;
    DapModulesController  *m_modulesCtrl;
    DapHistoryModel *m_historyModel = nullptr;

    bool isSendReqeust{false};
    QString m_lastWalletName {""};
    QStringList m_lastNetworkName;


    const int TIME_OUT_HISTORY_UPDATE = 60000;
    const int TIME_OUT_HISTORY_REQUEST = 30000;
};
#endif // DAPMODULETXEXPLORER_H

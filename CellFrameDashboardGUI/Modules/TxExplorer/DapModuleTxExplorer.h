#ifndef DAPMODULETXEXPLORER_H
#define DAPMODULETXEXPLORER_H

#include <QObject>
#include <QDebug>

#include "../DapModulesController.h"
#include "Models/DapHistoryModel.h"
#include "Models/DapHistoryProxyModel.h"

class DapModuleTxExplorer : public DapAbstractModule
{
    Q_OBJECT

    Q_PROPERTY(QString walletName     READ walletName      WRITE setWalletName)
public:
    explicit DapModuleTxExplorer(DapModulesController * modulesCtrl);

    QString walletName() const { return m_walletName; }

    Q_INVOKABLE void clearHistory();
    Q_INVOKABLE void updateHistory(bool flag);

signals:
    void updateHistoryModel();
    void historyMore15Changed(bool flag);

private slots:
    void slotHistoryUpdate();

public slots:
    void setHistoryModel(const QVariant &rcvData);

    void setWalletName(QString str);

private:
    void initConnect();

private:
    DapModulesController  *m_modulesCtrl;
    QTimer *m_timerHistoryUpdate;
    DapHistoryModel *m_historyModel = nullptr;
    DapHistoryProxyModel *m_historyProxyModel = nullptr;
    bool isSendReqeust{false};
    QQmlContext *context;

    QString m_walletName {""};
};

#endif // DAPMODULETXEXPLORER_H

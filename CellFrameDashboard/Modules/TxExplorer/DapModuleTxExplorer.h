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

private slots:
    void slotHistoryUpdate();

public slots:
    virtual void setHistoryModel(const QVariant &rcvData);

    virtual void setWalletName(QString str);

private:
    void initConnect();

private:
    QQmlContext *context;
    QByteArray *m_historyByteArray;

protected:
    QTimer *m_timerHistoryUpdate;
    DapHistoryProxyModel *m_historyProxyModel = nullptr;
    DapModulesController  *m_modulesCtrl;
    DapHistoryModel *m_historyModel = nullptr;

    bool isSendReqeust{false};
    QString m_walletName {""};

};


#endif // DAPMODULETXEXPLORER_H

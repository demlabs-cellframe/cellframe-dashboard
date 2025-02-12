#ifndef DAPMODULETXEXPLORER_H
#define DAPMODULETXEXPLORER_H

#include <QObject>
#include <QDebug>

#include "../DapModulesController.h"
#include "Models/DapHistoryModel.h"
#include "Models/DapHistoryProxyModel.h"
#include "DapWalletsManagerBase.h"
#include <QMutableListIterator>

class DapModuleTxExplorer : public DapAbstractModule
{
    Q_OBJECT

    using HistoryList = QList<DapHistoryModel::Item>;
    struct HistorySaves
    {
        ///    hash    status
        QHash<QString, QString> hashes;
        ///   network      hash
        QMap<QString, QSet<QString>> queue;
        HistoryList history;
    };
public:
    explicit DapModuleTxExplorer(DapModulesController * modulesCtrl);

    Q_INVOKABLE void updateHistory();

signals:
    void updateHistoryModel();

protected slots:
    virtual void setHistoryModel(const QVariant &rcvData);
    virtual void cleareData();
protected:
    bool addHistory(const QString& wallet, const QString &networkName, const HistoryList &list);
    bool updateModelBySaves();
private slots:
    void slotUpdateData() override;
    void slotHistoryUpdate();
    void walletInfoChangedsSlot(const QString& walletName, const QString& networkName);
    void deleteNetworksSlot(const QStringList& list);
private:
    void initConnect();
    DapWalletsManagerBase* getWalletManager() const;
    QString getNewLastNetwork();
protected:
    QTimer *m_timerHistoryUpdate = nullptr;
    QTimer *m_timerRequest = nullptr;
    DapHistoryProxyModel *m_historyProxyModel = nullptr;
    DapHistoryModel *m_historyModel = nullptr;

    bool isSendReqeust{false};
    QString m_lastWalletName {""};
    QStringList m_lastNetworkName;

    QMap<QString, HistorySaves> m_listsWallets;

    const int TIME_OUT_HISTORY_UPDATE = 60000;
    const int TIME_OUT_HISTORY_REQUEST = 30000;
};
#endif // DAPMODULETXEXPLORER_H

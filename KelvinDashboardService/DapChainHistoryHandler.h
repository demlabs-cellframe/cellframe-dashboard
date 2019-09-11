#ifndef DAPCHAINHISTORYHANDLER_H
#define DAPCHAINHISTORYHANDLER_H

#include <QtGlobal>
#include <QObject>
#include <QVariantList>
#include <QTimer>
#include <QProcess>
#include <QDebug>
#include <QList>

#include "DapHistoryType.h"

class DapChainHistoryHandler : public QObject
{
    Q_OBJECT

private:
    QVariant m_history;
    QTimer* m_timoutRequestHistory;

public:
    explicit DapChainHistoryHandler(QObject *parent = nullptr);

    /// Get current state of history
    /// @return data
    QVariant getHistory() const;

public slots:
    /// Request new tx history
    /// @param wallet list
    void onRequestNewHistory(const QMap<QString, QVariant>& aWallets);

signals:
    /// Signal for request wallets list
    void requsetWallets();
    /// Signal about getting new transatcion history
    /// @param data of history QList<QVariant>.
    /// QVariant is QStringList. QStringList consists
    /// 0:  date
    /// 1:  status
    /// 2:  currency
    /// 3:  token
    /// 4:  wallet_to
    /// 5:  wallet_from
    void changeHistory(QVariant);
};

#endif // DAPCHAINHISTORYHANDLER_H

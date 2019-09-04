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

    //!<    Get current state of history
    QVariant getHistory() const;

public slots:
    //!<    Request new tx history
    //! \param wallet list
    void onRequestNewHistory(const QMap<QString, QVariant>& aWallets);

signals:
    //!<    Signal for request wallets list
    void requsetWallets();
    //!<    Signal about getting new transatcion history
    void changeHistory(QVariant);
};

#endif // DAPCHAINHISTORYHANDLER_H

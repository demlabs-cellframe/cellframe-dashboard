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

    QVariant getHistory() const;

public slots:
    void onRequestNewHistory(const QMap<QString, QVariant>& aWallets);

signals:
    void requsetWallets();
    void changeHistory(QVariant);
};

#endif // DAPCHAINHISTORYHANDLER_H

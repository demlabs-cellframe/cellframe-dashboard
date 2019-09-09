#ifndef DAPSCREENHISTORYMODEL_H
#define DAPSCREENHISTORYMODEL_H

#include <QtGlobal>
#include <QDebug>
#include <QImage>
#include <QAbstractListModel>
#include <QDateTime>
#include <QTimer>
#include "DapHistoryType.h"

#define MASK_FOR_MODEL QString("MMMM, dd")

class DapScreenHistoryModel : public QAbstractListModel
{
    Q_OBJECT

public:
    /// Role enumeration
    enum {
        DisplayDateRole = Qt::UserRole,
        DateRole,
        DisplayNameTokenRole,
        DisplayNumberWalletRole,
        DisplayStatusRole,
        StatusRole,
        StatusColorRole,
        DisplayCryptocurrency,
        DisplayCurrency
    };

private:
    QList<DapTransactionItem> m_elementList;
    QTimer* m_timeout;

public:
    explicit DapScreenHistoryModel(QObject *parent = nullptr);
    static DapScreenHistoryModel &getInstance();

    /// Override model's methods
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    /// Receive new tx history
    void receiveNewData(const QVariant& aData);

signals:
    /// Signal for requset current state of tx history
    /// By defalt this signal emits when the client has just started while
    /// the tx model will not get at least one tx history.
    /// The signal stop emitting after getting the request result
    void sendRequestHistory();
};

#endif // DAPSCREENHISTORYMODEL_H

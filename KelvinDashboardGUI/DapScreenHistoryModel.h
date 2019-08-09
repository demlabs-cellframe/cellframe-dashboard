#ifndef DAPSCREENHISTORYMODEL_H
#define DAPSCREENHISTORYMODEL_H

#include <QDebug>
#include <QImage>
#include <QAbstractListModel>

struct DapTransactionItem {
    QString Date;
    QImage  TokenPic;
    QString Status;
    QString TokenName;
    QString WalletNumber;
    QString Cryptocurrency;
    QString Currency;
};

class DapScreenHistoryModel : public QAbstractListModel
{
    Q_OBJECT

private:
    enum {
        DisplayDateRole = Qt::UserRole,
        DisplayNameTokenRole,
        DisplayNumberWalletRole,
        DisplayStatusRole,
        DisplayCryptocurrency,
        DisplayCurrency
    };

    QList<DapTransactionItem> m_elementList;

public:
    explicit DapScreenHistoryModel(QObject *parent = nullptr);
    static DapScreenHistoryModel &getInstance();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:


};

#endif // DAPSCREENHISTORYMODEL_H

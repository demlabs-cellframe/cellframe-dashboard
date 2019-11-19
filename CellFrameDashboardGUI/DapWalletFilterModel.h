#ifndef DAPWALLETFILTERMODEL_H
#define DAPWALLETFILTERMODEL_H

#include <QSortFilterProxyModel>

class DapWalletFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT

public:
    explicit DapWalletFilterModel(QObject *parent = nullptr);
};

#endif // DAPWALLETFILTERMODEL_H

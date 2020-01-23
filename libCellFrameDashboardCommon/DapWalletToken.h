#ifndef DAPWALLETTOKEN_H
#define DAPWALLETTOKEN_H

#include <QString>

struct DapWalletToken
{
    /// Token name.
    QString m_sName;
    /// Token balance.
    double  m_dBalance {0.0};
    /// Token emission.
    quint64 m_iEmission {0};
    /// Network.
    QString m_sNetwork;

public:
    explicit DapWalletToken(const QString& asName = QString());
};

#endif // DAPWALLETTOKEN_H

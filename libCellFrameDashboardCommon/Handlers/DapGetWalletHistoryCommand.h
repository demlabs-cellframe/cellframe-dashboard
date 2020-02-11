#ifndef DAPGETWALLETHISTORYCOMMAND_H
#define DAPGETWALLETHISTORYCOMMAND_H

#include <QProcess>
#include <QRegExp>
#include <QRegularExpression>
#include <QDate>

#include "DapWallet.h"
#include "DapWalletHistoryEvent.h"
#include "DapAbstractCommand.h"

class DapGetWalletHistoryCommand : public DapAbstractCommand
{
public:
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param parent Parent.
    /// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
    /// @param asCliPath The path to cli nodes.
    DapGetWalletHistoryCommand(const QString &asServicename, QObject *parent = nullptr, const QString &asCliPath = QString());

public slots:
    /// Send a response to the client.
    /// @details Performed on the service side.
    /// @param arg1 Network.
    /// @param arg2 Chain.
    /// @param arg3 Wallet address.
    /// @param arg4...arg10 Parameters.
    /// @return Reply to client.
    QVariant respondToClient(const QVariant &arg1 = QVariant(), const QVariant &arg2 = QVariant(),
                             const QVariant &arg3 = QVariant(), const QVariant &arg4 = QVariant(),
                             const QVariant &arg5 = QVariant(), const QVariant &arg6 = QVariant(),
                             const QVariant &arg7 = QVariant(), const QVariant &arg8 = QVariant(),
                             const QVariant &arg9 = QVariant(), const QVariant &arg10 = QVariant()) override;
};

#endif // DAPGETWALLETHISTORYCOMMAND_H

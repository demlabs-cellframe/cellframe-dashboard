/****************************************************************************
**
** This file is part of the libCellFrameDashboardClient library.
** 
** The class implements the "Add wallet" command interface.
**
****************************************************************************/

#ifndef DAPADDWALLETCOMMAND_H
#define DAPADDWALLETCOMMAND_H

#include "DapAbstractCommand.h"

class DapAddWalletCommand : public DapAbstractCommand
{
public:
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param apSocket Client connection socket with service.
    /// @param parent Parent.
    explicit DapAddWalletCommand(const QString &asServicename, DapRpcSocket *apSocket = nullptr, QObject *parent = nullptr);

public slots:
    /// Send a response to the service.
    /// @param arg1...arg10 Parameters.
    /// @return Reply to service.
    QVariant respondToService(const QVariant &arg1 = QVariant(), const QVariant &arg2 = QVariant(), 
                              const QVariant &arg3 = QVariant(), const QVariant &arg4 = QVariant(), 
                              const QVariant &arg5 = QVariant(), const QVariant &arg6 = QVariant(), 
                              const QVariant &arg7 = QVariant(), const QVariant &arg8 = QVariant(), 
                              const QVariant &arg9 = QVariant(), const QVariant &arg10 = QVariant());
    /// Send a response to the client.
    /// @param arg1...arg10 Parameters.
    /// @return Reply to client.
    QVariant respondToClient(const QVariant &arg1 = QVariant(), const QVariant &arg2 = QVariant(), 
                             const QVariant &arg3 = QVariant(), const QVariant &arg4 = QVariant(), 
                             const QVariant &arg5 = QVariant(), const QVariant &arg6 = QVariant(), 
                             const QVariant &arg7 = QVariant(), const QVariant &arg8 = QVariant(), 
                             const QVariant &arg9 = QVariant(), const QVariant &arg10 = QVariant());
};

#endif // DAPADDWALLETCOMMAND_H

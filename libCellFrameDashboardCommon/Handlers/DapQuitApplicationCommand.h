/****************************************************************************
**
** This file is part of the libCellFrameDashboardClient library.
**
** The class implements the exit command of the application. Both the
** GUI client and the service complete the work.
**
****************************************************************************/

#ifndef DAPQUITAPPLICATIONCOMMAND_H
#define DAPQUITAPPLICATIONCOMMAND_H

#include <QObject>
#include <QCoreApplication>

#include "DapAbstractCommand.h"

class DapQuitApplicationCommand : public DapAbstractCommand
{
    Q_OBJECT

public:
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param parent Parent.
    /// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
    explicit DapQuitApplicationCommand(const QString &asServicename, QObject *parent = nullptr);

public slots:
    /// Send a notification to the client. At the same time, you should not expect a response from the client.
    /// @details Performed on the service side.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void notifyToClient(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant()) override;
    /// Process the notification from the service on the client side.
    /// @details Performed on the client side.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void notifedFromService(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant()) override;
};

#endif // DAPQUITAPPLICATIONCOMMAND_H

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
    explicit DapQuitApplicationCommand(const QString &asServicename, QObject *parent = nullptr);

public slots:
    /// Send noify to client.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void notifyToClient(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Send noify to client.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void notifedFromService(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
};

#endif // DAPQUITAPPLICATIONCOMMAND_H

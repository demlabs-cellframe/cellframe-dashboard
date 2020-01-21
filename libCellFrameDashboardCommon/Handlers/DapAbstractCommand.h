/****************************************************************************
**
** This file is part of the libCellFrameDashboardClient library.
** 
** The class implements the command interface.
**
****************************************************************************/

#ifndef DAPABSTRACTCOMMAND_H
#define DAPABSTRACTCOMMAND_H

#include <QObject>
#include <QVariant>

#include "DapRpcSocket.h"
#include "DapRpcLocalServer.h"

typedef  DapRpcService DapCommand;

class DapAbstractCommand : public DapCommand
{
    Q_OBJECT

protected:
    QObject * m_parent {nullptr};

public:
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param apSocket Client connection socket with service.
    /// @param parent Parent.
    explicit DapAbstractCommand(const QString &asServiceName, QObject *parent = nullptr);
    
signals:
    void clientNotifed(const QVariant& aNotify);
    /// The signal is emitted if a response from the client is successfully received.
    /// @param asRespond Client response.
    void clientResponded(const QVariant& aRespond);

    void serviceNotifed(const QVariant& aNotify);
    /// The signal is emitted in case of a successful response from the service.
    /// @param asRespond Service response.
    void serviceResponded(const QVariant& aRespond);

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
    /// Send request to client.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void requestToClient(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Send a response to the service.
    /// @param arg1...arg10 Parameters.
    /// @return Reply to service.
    virtual QVariant respondToService(const QVariant &arg1 = QVariant(),
                                      const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                      const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                      const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                      const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                      const QVariant &arg10 = QVariant());
    /// Reply from client.
    /// @return Client reply.
    virtual QVariant replyFromClient();

    /// Send noify to service.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void notifyToService(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Send noify to client.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void notifedFromClient(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Send request to service.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void requestToService(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Send a response to the client.
    /// @param arg1...arg10 Parameters.
    /// @return Reply to client.
    virtual QVariant respondToClient(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Reply from service.
    /// @return Service reply.
    virtual void replyFromService();
};

#endif // DAPABSTRACTCOMMAND_H

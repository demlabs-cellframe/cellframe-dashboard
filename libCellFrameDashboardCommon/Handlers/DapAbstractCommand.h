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

typedef  DapRpcService DapCommand;

class DapAbstractCommand : public DapCommand
{
    Q_OBJECT
    
    /// Client connection socket with service.
    DapRpcSocket    *m_pSocket {nullptr};

public:
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param apSocket Client connection socket with service.
    /// @param parent Parent.
    explicit DapAbstractCommand(const QString &asServiceName, DapRpcSocket *apSocket = nullptr, QObject *parent = nullptr);
    
signals:
    /// The signal is emitted if a response from the client is successfully received.
    /// @param asRespond Client response.
    void clientResponded(const QVariant& asRespond);
    /// The signal is emitted in case of a successful response from the service.
    /// @param asRespond Service response.
    void serviceResponded(const QVariant& asRespond);

public slots:
    /// Send request to client.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE void requestToClient(const QVariant &arg1 = QVariant(),
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
                                      const QVariant &arg10 = QVariant()) = 0;
    /// Reply from client.
    /// @return Client reply.
    virtual QVariant replyFromClient();

    /// Send request to service.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE void requestToService(const QVariant &arg1 = QVariant(),
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
                                     const QVariant &arg10 = QVariant()) = 0;
    /// Reply from service.
    /// @return Service reply.
    virtual void replyFromService();
};

#endif // DAPABSTRACTCOMMAND_H

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
    /// Parent.
    QObject * m_parent {nullptr};
    /// The path to cli nodes.
    QString m_sCliPath;
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param parent Parent.
    /// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
    /// @param asCliPath The path to cli nodes.
    explicit DapAbstractCommand(const QString &asServiceName, QObject *parent = nullptr, const QString &asCliPath = QString());
    
signals:
    /// The signal is emitted in case of successful notification of the client by the service.
    /// @param aNotify Notification.
    void clientNotifed(const QVariant& aNotify);
    /// The signal is emitted if the client has successfully received
    /// a request from the service and responded to the service.
    /// @param asRespond Client response.
    void clientResponded(const QVariant& aRespond);
    /// The signal is emitted if the client successfully notifies the service.
    /// @param aNotify Notification.
    void serviceNotifed(const QVariant& aNotify);
    /// The signal is emitted if the service has successfully received
    /// a request from the client and responded to the client
    /// @param asRespond Service response.
    void serviceResponded(const QVariant& aRespond);

public slots:
    /// Send a notification to the client. At the same time, you should not expect a response from the client.
    /// @details Performed on the service side.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void notifyToClient(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Process the notification from the service on the client side.
    /// @details Performed on the client side.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void notifedFromService(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Send request to client.
    /// @details Performed on the service side.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void requestToClient(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Send a response to the service.
    /// @details Performed on the client side.
    /// @param arg1...arg10 Parameters.
    /// @return Reply to service.
    virtual QVariant respondToService(const QVariant &arg1 = QVariant(),
                                      const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                      const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                      const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                      const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                      const QVariant &arg10 = QVariant());
    /// Reply from client.
    /// @details Performed on the service side.
    /// @return Client reply.
    virtual QVariant replyFromClient();

    /// Send a notification to the service. At the same time, you should not expect a response from the service.
    /// @details Performed on the client side.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void notifyToService(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Process the notification from the client on the service side.
    /// @details Performed on the service side.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void notifedFromClient(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Send request to service.
    /// @details Performed on the client side.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void requestToService(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Send a response to the client.
    /// @details Performed on the service side.
    /// @param arg1...arg10 Parameters.
    /// @return Reply to client.
    virtual QVariant respondToClient(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant());
    /// Reply from service.
    /// @details Performed on the service side.
    /// @return Service reply.
    virtual QVariant replyFromService();
};

#endif // DAPABSTRACTCOMMAND_H

/****************************************************************************
**
** This file is part of the libKelvinDashboardClient library.
** 
** The class extends QLocalServer to implement the server side. It is 
** intended for transfer of commands of type Dapsomommand between the server 
** and the client.
**
****************************************************************************/

#ifndef DAPLOCALSERVER_H
#define DAPLOCALSERVER_H

#include <QObject>
#include <QString>
#include <QLocalServer>
#include <QLocalSocket>
#include <QDebug>

#include "DapCommand.h"

class DapLocalServer : public QLocalServer
{
    Q_OBJECT
    
protected:
    /// Name of client-server connection.
    QString             m_nameConnect;
    /// Client connected to the server.
    QLocalSocket        *m_client {nullptr};
    
public:
    /// Redefined сonstructor.
    /// @param nameConnect Name of the connection. Default is empty.
    /// @param parent The default parent is empty.
    explicit DapLocalServer(const QString& nameConnect, QObject *parent = nullptr);
    
    ///********************************************
    ///                 Properties
    /// *******************************************
     
    /// Name of client-server connection.
    Q_PROPERTY(QString NameConnect MEMBER m_nameConnect READ getNameConnect WRITE setNameConnect NOTIFY nameConnectChanged)
    
    
    ///********************************************
    ///                 Interface
    /// *******************************************
    
    /// Get the name of the connection.
    /// @return Name of the connection.
    const QString& getNameConnect() const;
    /// Set connection name.
    /// @param nameConnect Name of the connection.
    void setNameConnect(const QString &nameConnect);
    /// Connect with client.
    /// @details As the name of the connection, the NameConnect property 
    /// initialized through the constructor will be used.
    void connectWithClient();
    /// Connect with client.
    /// @details The name of the connection sets the parameter.
    /// @param nameConnect Name of the connection.
    void connectWithClient(const QString &nameConnect);
    /// Get the command.
    /// @details When the command is received, the commandRecieved signal is emitted. 
    /// @param byteArrayCommand Accepted command in byte representation.
    /// @return The received command.
    const DapCommand &recieveCommand(const QByteArray& byteArrayCommand);
    /// Set command.
    /// @details If the command is successfully sent, the commandSent signal 
    /// is emitted.
    /// @param command Submitted command.
    /// @return Returns true if the command was successfully sent, 
    /// false - the command was not sent.
    bool sendCommand(const DapCommand &command);
    /// Check the existence of the connected client.
    /// @return Returns three if the client is connected to the server, 
    /// false is not connected.
    Q_INVOKABLE bool isClientExist();
    
signals:
    /// The signal is emitted when the NameConnect property changes.
    /// @param nameConnect Name of the connection.
    void nameConnectChanged(const QString &nameConnect);
    /// The signal is emitted when a command is received.
    /// @param command The received command.
    void commandRecieved(const DapCommand &command);
    /// The signal is emitted when sending a command.
    /// @param command Submitted command.
    void commandSent(const DapCommand &command); 
};

#endif // DAPLOCALSERVER_H

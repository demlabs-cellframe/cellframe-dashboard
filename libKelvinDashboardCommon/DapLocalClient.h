/****************************************************************************
**
** This file is part of the libKelvinDashboardClient library.
** 
** The class extends the QLocalSocket to implement the client side. It is 
** intended for transfer of commands of type Dapsomommand between the client 
** and the server.
**
****************************************************************************/

#ifndef DAPLOCALCLIENT_H
#define DAPLOCALCLIENT_H

#include <QObject>
#include <QLocalSocket>

#include "DapCommand.h"

class DapLocalClient : public QLocalSocket
{
    Q_OBJECT
    
protected:
    /// Name of client-server connection.
    QString     m_nameConnect;
    
public:
    /// Redefined сonstructor.
    /// @param nameConnect Name of the connection. Default is empty.
    /// @param parent The default parent is empty.
    explicit DapLocalClient(const QString& nameConnect = "", QObject *parent = nullptr);
       
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
    /// Connect to the server.
    /// @details As the name of the connection, the NameConnect property 
    /// initialized through the constructor will be used.
    void connectToServer();
    /// Connect to the server.
    /// @details The name of the connection sets the parameter.
    /// @param nameConnect Name of the connection.
    void connectToServer(const QString &nameConnect);
    /// Get the command.
    /// @details When the command is received, the commandRecieved signal is emitted 
    /// @return The received command.
    const DapCommand& recieveCommand();
    /// Set command.
    /// @details If the command is successfully sent, the commandSent signal 
    /// is emitted.
    /// @param command Submitted command.
    /// @return Returns true if the command was successfully sent, 
    /// false - the command was not sent.
    bool sendCommand(const DapCommand &command);
    
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

#endif // DAPLOCALCLIENT_H

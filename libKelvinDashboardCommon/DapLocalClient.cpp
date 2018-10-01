#include "DapLocalClient.h"

/// Redefined сonstructor.
/// @param nameConnect Name of the connection. Default is empty.
/// @param parent The default parent is empty.
DapLocalClient::DapLocalClient(const QString &nameConnect, QObject *parent) : QLocalSocket(parent)
{
    Q_UNUSED(nameConnect);
    
    // Initializing fields
    m_nameConnect = nameConnect;
    
    // A signal-slot connection that starts receiving a command when the socket is 
    // switched to readyRead mode
    connect(this, &DapLocalClient::readyRead, this, &DapLocalClient::recieveCommand);
}

/// Get the name of the connection.
/// @return Name of the connection.
const QString &DapLocalClient::getNameConnect() const
{
    return m_nameConnect;
}

/// Set connection name.
/// @param nameConnect Name of the connection.
void DapLocalClient::setNameConnect(const QString &nameConnect)
{
    m_nameConnect = nameConnect;
}

/// Connect to the server.
/// @details As the name of the connection, the NameConnect property 
/// initialized through the constructor will be used.
void DapLocalClient::connectToServer()
{
    QLocalSocket::connectToServer(getNameConnect());
}

/// Connect to the server.
/// @details The name of the connection sets the parameter.
/// @param nameConnect Name of the connection.
void DapLocalClient::connectToServer(const QString &nameConnect)
{
    QLocalSocket::connectToServer(nameConnect);
}

/// Get the command.
/// @details When the command is received, the commandRecieved signal is emitted 
/// @return The received command.
const DapCommand &DapLocalClient::recieveCommand()
{
    DapCommand *command = new DapCommand(this->readAll());
    emit commandRecieved(*command);
    return *command;
}

/// Set command.
/// @details If the command is successfully sent, the commandSent signal 
/// is emitted.
/// @param command Submitted command.
/// @return Returns true if the command was successfully sent, 
/// false - the command was not sent.
bool DapLocalClient::sendCommand(const DapCommand &command)
{
    if(this->isWritable())
    {
        this->write(const_cast<DapCommand &>(command).serialize());
        
        if(this->flush())
        {
            emit commandSent(command);
            return true;
        }
    }
    return false;
}

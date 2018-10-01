#include "DapLocalServer.h"

/// Redefined сonstructor.
/// @param nameConnect Name of the connection. Default is empty.
/// @param parent The default parent is empty.
DapLocalServer::DapLocalServer(const QString &nameConnect, QObject *parent) : QLocalServer(parent)
{
    Q_UNUSED(nameConnect);
    
    // Initializing fields
    m_nameConnect = nameConnect;
}

/// Get the name of the connection.
/// @return Name of the connection.
const QString &DapLocalServer::getNameConnect() const
{
    return m_nameConnect;
}

/// Set connection name.
/// @param nameConnect Name of the connection.
void DapLocalServer::setNameConnect(const QString &nameConnect)
{
    m_nameConnect = nameConnect;
}

/// Connect with client.
/// @details As the name of the connection, the NameConnect property 
/// initialized through the constructor will be used.
void DapLocalServer::connectWithClient()
{
    connectWithClient(getNameConnect());
}

/// Connect with client.
/// @details The name of the connection sets the parameter.
/// @param nameConnect Name of the connection.
void DapLocalServer::connectWithClient(const QString &nameConnect)
{
    this->setSocketOptions(QLocalServer::WorldAccessOption);
    
    if(this->listen(nameConnect)) 
    {
        connect(this, &QLocalServer::newConnection, [=] 
        {
            m_client = this->nextPendingConnection();
            {
                qDebug() << "Cient connected";
                connect(m_client, &QLocalSocket::readyRead, [=]
                {
                    QByteArray clientCommand = m_client->readAll();
                    
                    while (true) {
                        if(clientCommand.isEmpty())
                            break;
                        
                        recieveCommand(clientCommand);
                        break;
                    }
                });
            }
        });
    }
}

/// Get the command.
/// @details When the command is received, the commandRecieved signal is emitted. 
/// @param byteArrayCommand Accepted command in byte representation.
/// @return The received command.
const DapCommand& DapLocalServer::recieveCommand(const QByteArray &byteArrayCommand)
{
    DapCommand *command = new DapCommand(byteArrayCommand);
    emit commandRecieved(*command);
    return *command;
}

/// Set command.
/// @details If the command is successfully sent, the commandSent signal 
/// is emitted.
/// @param command Submitted command.
/// @return Returns true if the command was successfully sent, 
/// false - the command was not sent.
bool DapLocalServer::sendCommand(const DapCommand &command)
{
    if(m_client->isWritable())
    {
        qDebug() << "Send command by: " << const_cast<DapCommand &>(command).serialize();
        qDebug() << "Send command: " << command.getArguments().at(0);
        m_client->write(const_cast<DapCommand &>(command).serialize());
        
        if(m_client->flush())
        {
            emit commandSent(command);
            return true;
        }
    }
    return false;
}

/// Check the existence of the connected client.
/// @return Returns three if the client is connected to the server, 
/// false is not connected.
bool DapLocalServer::isClientExist()
{
    return m_client ? true : false;
}

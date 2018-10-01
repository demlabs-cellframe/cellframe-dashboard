#include "DapClient.h"

/// Standard сonstructor.
DapClient::DapClient(QObject *parent) : QObject(parent)
{
    connect(&m_localClient, &DapLocalClient::commandRecieved, this, &DapClient::identificationCommand);
    connect(&m_localClient, static_cast<void(DapLocalClient::*)(DapLocalClient::LocalSocketError)>(&DapLocalClient::error), this, &DapClient::errorHandler);
    connect(&m_localClient, &DapLocalClient::connected, this, [=] 
    {
        QTimer::singleShot(1000, [&] 
        { 
            emit connectedToService();
        });
    });
}

/// Get an instance of a class.
/// @return Instance of a class.
DapClient &DapClient::getInstance()
{
    static DapClient instance;
    return instance;
}

/// Connect to the service.
/// @brief The name of the service connection is set from the NameSrvice property.
void DapClient::connectToService()
{
    qDebug() << "Connect to service ()" << getNameSrvice();
    m_localClient.connectToServer(getNameSrvice());
}

/// Connect to the service.
/// @param nameService Service connection name.
void DapClient::connectToService(const QString &nameService)
{
    setNameSrvice(nameService);
    qDebug() << "Connect to servoce (nameService)";
    m_localClient.connectToServer(nameService);
}

/// Authorize user.
/// @param password User password.
void DapClient::authorization(const QString &password)
{
    qDebug() << "Authorization " << password << endl;
    DapCommand command(TypeDapCommand::Authorization, 1, { password });
    m_localClient.sendCommand(command);
}

/// Handle connection error.
/// @param socketError Error local connection of the client with the service.
void DapClient::errorHandler(const DapLocalClient::LocalSocketError &socketError)
{
    switch (socketError) {
    case DapLocalClient::PeerClosedError:
    case DapLocalClient::ConnectionRefusedError:
    case DapLocalClient::ServerNotFoundError:
        QTimer::singleShot(1000, [&] 
        { 
            connectToService(); 
            emit errorConnect();
        } );
        break;
    default:
        break;
    }
}

/// Get the name of the service connection.
/// @return The name of the service connection.
QString DapClient::getNameSrvice() const
{
    return m_nameService;
}

/// Set the name of the service connection.
/// @param nameService Service connection name.
void DapClient::setNameSrvice(const QString &nameService)
{
    m_nameService = nameService;
    m_localClient.setNameConnect(nameService);
}

/// Get company brand.
/// @return Brand сompany.
QString DapClient::getBrand() const
{
    return m_brand;
}

/// Get app version.
/// @return Application version.
QString DapClient::getVersion() const
{
    return m_version;
}

/// Get user authorization flag.
/// @return Returns true if the user is authorized, otherwise - false.
bool DapClient::getIsAuthorization() const
{
    return m_isAuthorization;
}

/// Set user authorization flag.
/// @param isAuthorization The value of the user authorization flag.
void DapClient::setIsAuthorization(bool isAuthorization)
{
    m_isAuthorization = isAuthorization;
    emit isAuthorizationChanged(m_isAuthorization);
}

/// /// Identification of the command received.
/// @param command Command received.
/// @return Returns true if the command is identified, otherwise - false.
bool DapClient::identificationCommand(const DapCommand &command)
{
    qDebug() << "Identification command: " << command.getTypeCommand();
    qDebug() << "Identification command: " << command.getArguments().count();
    switch (command.getTypeCommand()) 
    {
    case TypeDapCommand::Authorization:
        if(command.getArgument(0).toBool())
            setIsAuthorization(true);
        else
            setIsAuthorization(false);
        return true;
    case TypeDapCommand::ActivateWindowClient:
        emit activateWindow();
        return true;
    case TypeDapCommand::CheckExistenceClient:
        if(command.getArgument(0).toBool())
            emit isExistenceClient(true);
        else
            emit isExistenceClient(false);
        return true;
    case TypeDapCommand::CloseClient:
        qApp->quit();
        return true;
    default:
        return false;
    }
}

/// Method that implements the singleton pattern for the qml layer.
/// @param engine QML application.
/// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
QObject *DapClient::singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    
    return &getInstance();
}


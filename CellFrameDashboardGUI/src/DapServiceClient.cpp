#include "DapServiceClient.h"

DapServiceClient::DapServiceClient(QObject *apParent)
    : QObject(apParent)
{
    // Initialization of the service connection socket
    m_pClientSocket = new DapUiSocket(this);
    // Signal-slot connection broadcasting service connection error
    connect(m_pClientSocket,static_cast<void(DapUiSocket::*)(DapUiSocketError)> (&DapUiSocket::error),
        this, &DapServiceClient::handleSocketError);
    // Signal-slot connection broadcasting signal of successful connection to the service
    connect(m_pClientSocket,SIGNAL(connected()), this, SLOT(connectedToService()));
    // Signal-slot connection transmitting a signal to disconnect from the service
    connect(m_pClientSocket,SIGNAL(disconnected()), this, SLOT(disconnectFromService()));
    // Signal-slot connection that reconnects to the service
    connect(&m_reconnectTimer, SIGNAL(timeout()), this, SLOT(reconnectToService()));
}

/// Get a socket pointer.
/// @return A pointer to a socket.
DapUiSocket *DapServiceClient::getClientSocket() const
{
    return m_pClientSocket;
}

/// Establish a connection with the service when the latter is launched.
void DapServiceClient::onServiceStarted()
{
    qInfo() << "Service started.";
    connectToService();
}

/// Handle event of successful connection to the service.
void DapServiceClient::connectedToService()
{
    qInfo() << "Connected to the service";
    m_launchAttemptCounter = 0;
    m_isServiceConnected = true;
    stopReconnectingToService();
    emit sigConnected();
}

/// Start the process of reconnecting to the service.
void DapServiceClient::startReconnectingToService()
{
    if(!m_reconnectTimer.isActive()) {
        qInfo() << "Start trying to reconnect to service";
        m_reconnectTimer.start(RECONNECT_TIMEOUT_MS);
    }
}

/// Stop the process of reconnecting to the service.
void DapServiceClient::stopReconnectingToService()
{
    if(m_reconnectTimer.isActive())
    {
        m_reconnectTimer.stop();
        qInfo() << "Reconnect timer stopped";
    }
}

/// Handle socket error.
/// @param aSocketEror Socket error code.
void DapServiceClient::handleSocketError(DapUiSocketError aSocketEror)
{
    qDebug() << m_pClientSocket->errorString();
    startReconnectingToService();
    emit sigSocketError(aSocketEror);
    emit sigSocketErrorString(m_pClientSocket->errorString());
}

/// Reconnect service.
void DapServiceClient::reconnectToService()
{
    ++m_launchAttemptCounter;
    DapServiceError resultInit = DapServiceError::NO_ERRORS;
    if(m_launchAttemptCounter == NUMBER_LAUNCH_ATTEMPTS)
    {
        qCritical() << "Server not running after `serviceStart` operation";
        QMessageBox::critical(Q_NULLPTR, DAP_BRAND, "Unable to start service", QMessageBox::Ok);
        exit(-1);
    }
    else
    {
        resultInit = init();
    }
    if(resultInit == DapServiceError::NO_ERRORS)
    {
        connectToService();
    }
}

/// Initiate the service monitor.
DapServiceError DapServiceClient::init()
{
    DapServiceError result = DapServiceClientNative::init();

    handleServiceError(result);

    return result;
}

/// Handle service error.
/// @param aServiceEror Service error code.
void DapServiceClient::handleServiceError(DapServiceError aServiceEror)
{
    switch (aServiceEror)
    {
        case DapServiceError::NO_ERRORS:
            break;
        case DapServiceError::USER_COMMAND_ABORT:
            QMessageBox::critical(Q_NULLPTR, DAP_BRAND, "User abort service comand", QMessageBox::Ok);
            exit(-1);
        case DapServiceError::UNABLE_START_SERVICE:
            QMessageBox::critical(Q_NULLPTR, DAP_BRAND, "Start the service with administrator rights", QMessageBox::Ok);
            qCritical() << "Start the service with administrator rights";
            break;
        case DapServiceError::UNABLE_STOP_SERVICE:
            qCritical() << "Can't stop service";
            break;
        case DapServiceError::UNKNOWN_ERROR:
            qCritical() << "Got unknown error";
            break;
        case DapServiceError::SERVICE_NOT_FOUND:
            qCritical() << "Service not found";
            break;
    }
    if(aServiceEror != DapServiceError::NO_ERRORS)
    {
        emit sigServiceError(aServiceEror);
    }
}

/// Establish a connection with the service.
void DapServiceClient::connectToService()
{
    if(m_pClientSocket->state() == QAbstractSocket::ConnectedState)
        return;
    
    qInfo() << "with parametr: " << DAP_BRAND;
    m_pClientSocket->connectToServer(DAP_BRAND);
}

/// Handle service outage.
void DapServiceClient::disconnectFromService()
{
    m_isServiceConnected = true;
    startReconnectingToService();
    emit sigDisconnected();
}

#ifndef DAPSERVICECLIENT_H
#define DAPSERVICECLIENT_H

#include <QObject>
#include <QTimer>
#include <QMessageBox>
#include <QLocalSocket>
#include <QLocalServer>

#if defined(Q_OS_LINUX)
#include "DapServiceClientNativeLinux.h"
typedef class DapServiceClientNativeLinux DapServiceClientNative;
#elif defined(Q_OS_WIN)
#include "DapServiceClientNativeWin.h"
typedef class DapServiceClientNativeWin DapServiceClientNative;
#elif defined(Q_OS_MAC)
#include "DapServiceClientNativeMacOS.h"
typedef class DapServiceClientNativeMacOS DapServiceClientNative;
#endif

typedef QLocalSocket DapUiSocket;
typedef QLocalServer DapUiServer;
typedef QLocalSocket::LocalSocketError DapUiSocketError;

class DapServiceClient : public QObject, public DapServiceClientNative
{
    Q_OBJECT
    Q_DISABLE_COPY(DapServiceClient)
    
    /// Reconnect interval.
    const int RECONNECT_TIMEOUT_MS {5000};
    /// The number of attempts to restart the service.
    const size_t NUMBER_LAUNCH_ATTEMPTS {3};
    /// The current number of attempts to restart the service.
    size_t m_launchAttemptCounter {0};
    /// Reconnect timer.
    QTimer m_reconnectTimer;
    /// Service connection socket.
    DapUiSocket *m_pClientSocket {nullptr};

    bool m_isServiceConnected {false};
    
public:
    explicit DapServiceClient(QObject * apParent = nullptr);
    /// Get a socket pointer.
    /// @return A pointer to a socket.
    DapUiSocket *getClientSocket() const;
    
signals:
    /// The signal emitted in case of successful connection to the service.
    void sigConnected();
    /// The signal emitted in case of successful disconnection from the service.
    void sigDisconnected();
    /// The signal emitted in the event of an error when connecting to the service.
    /// @param asErrorMessage Socket error message.
    void sigSocketErrorString(const QString& asErrorMessage);
    /// The signal emitted in the event of an error when connecting to the service.
    /// @param aSocketEror Socket error code.
    void sigSocketError(DapUiSocketError aSocketEror);
    /// The signal is emitted in case of an error when trying to start the service.
    /// @param aServiceEror Service error code.
    void sigServiceError(DapServiceError aServiceEror);
    
protected slots:
    /// Establish a connection with the service when the latter is launched.
    void onServiceStarted();
    /// Handle event of successful connection to the service.
    void connectedToService();
    /// Start the process of reconnecting to the service.
    void startReconnectingToService();
    /// Stop the process of reconnecting to the service.
    void stopReconnectingToService();
    /// Handle socket error.
    /// @param aSocketEror Socket error code.
    void handleSocketError(DapUiSocketError aSocketEror);
    /// Reconnect service.
    void reconnectToService();
    /// Handle service error.
    /// @param aServiceEror Service error code.
    void handleServiceError(DapServiceError aServiceEror);

public slots:
    /// Initiate the service monitor.
    virtual DapServiceError init() override;
    /// Establish a connection with the service.
    void connectToService();
    /// Handle service outage.
    void disconnectFromService();
};

#endif // DAPSERVICECLIENT_H

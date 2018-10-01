/****************************************************************************
**
** This file is part of the KelvinDashboardGUI application.
** 
** The class implements the GUI interface of the application. Designed to 
** broadcast user actions to the service. Manages the state of graphic 
** elements of the GUI framework, connection with the service, identification 
** of commands received from the service, etc.
** 
** Class implements a singleton pattern.
**
****************************************************************************/

#ifndef DAPCLIENT_H
#define DAPCLIENT_H

#include <QObject>
#include <QLocalSocket>
#include <QQmlEngine>
#include <QJSEngine>
#include <QApplication>
#include <QTimer>

#include "DapCommand.h"
#include "DapLocalClient.h"

class DapClient : public QObject
{
    Q_OBJECT
    
    /// Local client.
    DapLocalClient   m_localClient;
    /// Brand сompany.
    QString m_brand {DAP_BRAND};
    /// Application version.
    QString m_version {DAP_VERSION};
    /// Service connection name.
    QString m_nameService;
    /// User authorization flag.
    bool m_isAuthorization {false};
    
    /// Standard сonstructor.
    explicit DapClient(QObject *parent = nullptr);
public:
    DapClient(const DapClient&) = delete;
    DapClient& operator= (const DapClient &) = delete;
    
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapClient &getInstance();
    
    ///********************************************
    ///                 Property
    /// *******************************************
    
    /// Service connection name.
    Q_PROPERTY(QString NameSrvice MEMBER m_nameService READ getNameSrvice WRITE setNameSrvice NOTIFY nameSrviceChanged)
    /// Brand сompany.
    Q_PROPERTY(QString Brand MEMBER m_brand READ getBrand NOTIFY brandChanged)
    /// Application version.
    Q_PROPERTY(QString Version MEMBER m_version READ getVersion NOTIFY versionChanged)
    /// User authorization flag.
    Q_PROPERTY(bool IsAuthorization MEMBER m_isAuthorization READ getIsAuthorization WRITE setIsAuthorization NOTIFY isAuthorizationChanged)
    
    ///********************************************
    ///                 Interface
    /// *******************************************
    
    /// Connect to the service.
    /// @brief The name of the service connection is set from the NameSrvice property.
    Q_INVOKABLE void connectToService();
    /// Connect to the service.
    /// @param nameService Service connection name.
    Q_INVOKABLE void connectToService(const QString &nameService);
    /// Authorize user.
    /// @param password User password.
    Q_INVOKABLE void authorization(const QString &password);
    /// Handle connection error.
    /// @param socketError Error local connection of the client with the service.
    void errorHandler(const QLocalSocket::LocalSocketError& socketError);
    /// Get the name of the service connection.
    /// @return The name of the service connection.
    QString getNameSrvice() const;
    /// Set the name of the service connection.
    /// @param nameService Service connection name.
    void setNameSrvice(const QString &nameService);
    /// Get company brand.
    /// @return Brand сompany.
    QString getBrand() const;
    /// Get app version.
    /// @return Application version.
    QString getVersion() const;
    /// Get user authorization flag.
    /// @return Returns true if the user is authorized, otherwise - false.
    bool getIsAuthorization() const;
    /// Set user authorization flag.
    /// @param isAuthorization The value of the user authorization flag.
    void setIsAuthorization(bool isAuthorization);
    
signals:
    /// The signal is emitted when a successful connection to the service is established.
    void connectedToService();
    /// The signal is emitted when the connection to the service is broken.
    void disconnectedFromService();
    /// The signal is emitted when the name of the client's connection with the service is changed.
    void nameSrviceChanged(const QString &nameService);
    /// The signal is emitted when the Brand company property changes.
    void brandChanged(const QString &brand);
    /// The signal is emitted when the Application version property changes.
    void versionChanged(const QString &version);
    /// The signal is emitted when the User authorization flag property changes.
    void isAuthorizationChanged(bool isAuthorization);
    /// The signal is emitted when the main application window is activated.
    void activateWindow();
    /// The signal is emitted when an error occurs in the connection between the client and the service.
    void errorConnect();
    /// The signal is emitted when checking the existence of an already running copy of the application.
    void isExistenceClient(bool isExistenceClient);
    
public slots:
    /// /// Identification of the command received.
    /// @param command Command received.
    /// @return Returns true if the command is identified, otherwise - false.
    bool identificationCommand(const DapCommand &command);
    /// Method that implements the singleton pattern for the qml layer.
    /// @param engine QML application.
    /// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
    static QObject *singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
};

#endif // DAPCLIENT_H

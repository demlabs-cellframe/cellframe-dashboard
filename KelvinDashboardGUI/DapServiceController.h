#ifndef DAPSERVICECONTROLLER_H
#define DAPSERVICECONTROLLER_H

#include <QObject>
#include <QQmlEngine>
#include <QJSEngine>
#include <QApplication>
#include <QTimer>

#include "DapCommandController.h"
#include "DapServiceClient.h"
#include "DapLogModel.h"

class DapServiceController : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(DapServiceController)
    /// Brand сompany.
    QString m_sBrand {DAP_BRAND};
    /// Application version.
    QString m_sVersion {DAP_VERSION};
    
    /// Service connection management service.
    DapServiceClient *m_pDapServiceClient {nullptr};
    /// RPC protocol controller.
    DapCommandController *m_pDapCommandController {nullptr};
    
    explicit DapServiceController(QObject *apParent = nullptr);
    
public:
    
    
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapServiceController &getInstance();
    
    ///********************************************
    ///                 Property
    /// *******************************************
    
    /// Brand сompany.
    Q_PROPERTY(QString Brand MEMBER m_sBrand READ getBrand NOTIFY brandChanged)
    /// Application version.
    Q_PROPERTY(QString Version MEMBER m_sVersion READ getVersion NOTIFY versionChanged)
    
    ///********************************************
    ///                 Interface
    /// *******************************************
    void init(DapServiceClient *apDapServiceClient);
    /// Get company brand.
    /// @return Brand сompany.
    QString getBrand() const;
    /// Get app version.
    /// @return Application version.
    QString getVersion() const;
    /// Get node logs.
    /// @param aiTimeStamp Timestamp start reading logging.
    /// @param aiRowCount Number of lines displayed.
    void getNodeLogs(int aiTimeStamp, int aiRowCount) const;
    
    DapLogModel getLogModel() const;
    void setLogModel(const DapLogModel &dapLogModel);

    Q_INVOKABLE void addWallet(const QString& asName);

signals:
    /// The signal is emitted when the Brand company property changes.
    void brandChanged(const QString &brand);
    /// The signal is emitted when the Application version property changes.
    void versionChanged(const QString &version);
    /// The signal is emitted when the main application window is activated.
    void activateWindow();
    /// The signal is emitted when checking the existence of an already running copy of the application.
    void isExistenceClient(bool isExistenceClient);
    
private slots:
    /// Handling service response for receiving node logs.
    /// @param aNodeLogs List of node logs.
    void processGetNodeLogs(const QStringList& aNodeLogs);

public slots:
    /// Show or hide GUI client by clicking on the tray icon.
    /// @param aIsActivated Accepts true - when requesting to 
    /// display a client, falso - when requesting to hide a client.
    void activateClient(bool aIsActivated);
    /// Shut down client.
    void closeClient();
    /// Method that implements the singleton pattern for the qml layer.
    /// @param engine QML application.
    /// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
    static QObject *singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
};

#endif // DAPSERVICECONTROLLER_H

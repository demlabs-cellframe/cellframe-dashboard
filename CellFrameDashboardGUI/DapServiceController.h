#ifndef DAPSERVICECONTROLLER_H
#define DAPSERVICECONTROLLER_H

#include <QObject>
#include <QQmlEngine>
#include <QJSEngine>

#include "DapCommandController.h"
#include "DapServiceClient.h"

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
    /// Standard constructor
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

signals:
    /// The signal is emitted when the Brand company property changes.
    /// @param asBrand Brand
    void brandChanged(const QString &brand);
    /// The signal is emitted when the Application version property changes.
    /// @param version Version
    void versionChanged(const QString &version);

public slots:
    /// Method that implements the singleton pattern for the qml layer.
    /// @param engine QML application.
    /// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
    static QObject *singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
};

#endif // DAPSERVICECONTROLLER_H

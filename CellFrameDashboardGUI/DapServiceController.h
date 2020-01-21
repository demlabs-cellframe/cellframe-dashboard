#ifndef DAPSERVICECONTROLLER_H
#define DAPSERVICECONTROLLER_H

#include <QObject>
#include <QGenericArgument>
#include <QQmlEngine>
#include <QJSEngine>
#include <QVector>
#include <algorithm>

#include "DapServiceClient.h"
#include "Handlers/DapAbstractCommand.h"
#include "Handlers/DapQuitApplicationCommand.h"
#include "Handlers/DapActivateClientCommand.h"
#include "Handlers/DapUpdateLogsCommand.h"

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
    /// Command manager.
    QVector<QPair<DapAbstractCommand*, QString>>      m_transceivers;
    /// RPC socket.
    DapRpcSocket    * m_DAPRpcSocket {nullptr};
    /// Standard constructor
    explicit DapServiceController(QObject *apParent = nullptr);
    
public:
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapServiceController &getInstance();
    /// Send request to service.
    /// @param arg1...arg10 Parametrs.
    Q_INVOKABLE void requestToService(const QString& asServiceName, const QVariant &arg1 = QVariant(),
                         const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                         const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                         const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                         const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                         const QVariant &arg10 = QVariant());
    Q_INVOKABLE void notifyService(const QString& asServiceName, const QVariant &arg1 = QVariant(),
                         const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                         const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                         const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                         const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                         const QVariant &arg10 = QVariant());
    
    ///********************************************
    ///                 Property
    /// *******************************************
    
    /// Brand company.
    Q_PROPERTY(QString Brand MEMBER m_sBrand READ getBrand NOTIFY brandChanged)
    /// Application version.
    Q_PROPERTY(QString Version MEMBER m_sVersion READ getVersion NOTIFY versionChanged)

    ///********************************************
    ///                 Interface
    /// *******************************************
    
    /// Client controller initialization.
    /// @param apDapServiceClient Network connection controller.
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

    void clientActivated();
    
    void addWalletResponded(const QVariant& wallet);
    ///A signal that is used to transmit data to the log model.
    /// @param historyString QStringList
    void logUpdated(const QVariant& logs);
    
private slots:
    /// Register command.
    void registerCommand();
    /// Find the emitted signal.
    /// @param aValue Transmitted parameter.
    void findEmittedSignal(const QVariant& aValue);

    void registerEmmitedSignal();
};

#endif // DAPSERVICECONTROLLER_H

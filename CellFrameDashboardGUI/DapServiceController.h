#ifndef DAPSERVICECONTROLLER_H
#define DAPSERVICECONTROLLER_H

#include <QObject>
#include <QGenericArgument>
#include <QQmlEngine>
#include <QJSEngine>
#include <QVector>
#include <algorithm>
#include <QDataStream>

#include "DapServiceClient.h"
#include "DapWallet.h"
#include "Handlers/DapAbstractCommand.h"
#include "Handlers/DapQuitApplicationCommand.h"
#include "Handlers/DapActivateClientCommand.h"
#include "Handlers/DapUpdateLogsCommand.h"
#include "Handlers/DapAddWalletCommand.h"
#include "Handlers/DapGetListWalletsCommand.h"
#include "Handlers/DapGetListNetworksCommand.h"
#include "Handlers/DapExportLogCommand.h"
#include "Handlers/DapGetWalletAddressesCommand.h"
#include "Handlers/DapGetWalletTokenInfoCommand.h"
#include "Models/DapWalletModel.h"
#include "Handlers/DapCreateTransactionCommand.h"
#include "Handlers/DapMempoolProcessCommand.h"
#include "Handlers/DapGetWalletHistoryCommand.h"
#include "Handlers/DapRunCmdCommand.h"
#include "Handlers/DapGetHistoryExecutedCmdCommand.h"
#include "Handlers/DapSaveHistoryExecutedCmdCommand.h"

class DapServiceController : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(DapServiceController)
    /// Brand сompany.
    QString m_sBrand {DAP_BRAND};
    /// Application version.
    QString m_sVersion {DAP_VERSION};

    QString m_sCurrentNetwork;

    int m_iIndexCurrentNetwork;
    /// Service connection management service.
    DapServiceClient *m_pDapServiceClient {nullptr};
    /// Command manager.
    QVector<QPair<DapAbstractCommand*, QString>>      m_transceivers;
    /// RPC socket.
    DapRpcSocket    * m_DAPRpcSocket {nullptr};
    /// Standard constructor.
    /// @param apParent Parent.
    explicit DapServiceController(QObject *apParent = nullptr);
    
public:
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapServiceController &getInstance();
    /// Send request to service.
    /// @details In this case, a request is sent to the service to which it is obliged to respond. Expect an answer.
    /// @param asServiceName Service name.
    /// @param arg1...arg10 Parametrs.
    Q_INVOKABLE void requestToService(const QString& asServiceName, const QVariant &arg1 = QVariant(),
                         const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                         const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                         const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                         const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                         const QVariant &arg10 = QVariant());
    /// Notify service.
    /// @details In this case, only a notification is sent to the service, the answer should not be expected.
    /// @param asServiceName Service name.
    /// @param arg1...arg10 Parametrs.
    Q_INVOKABLE void notifyService(const QString& asServiceName, const QVariant &arg1 = QVariant(),
                         const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                         const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                         const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                         const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                         const QVariant &arg10 = QVariant());
    
    /// Brand company.
    Q_PROPERTY(QString Brand MEMBER m_sBrand READ getBrand NOTIFY brandChanged)
    /// Application version.
    Q_PROPERTY(QString Version MEMBER m_sVersion READ getVersion NOTIFY versionChanged)

    Q_PROPERTY(QString CurrentNetwork MEMBER m_sVersion READ getCurrentNetwork WRITE setCurrentNetwork NOTIFY currentNetworkChanged)

    Q_PROPERTY(int IndexCurrentNetwork MEMBER m_iIndexCurrentNetwork READ getIndexCurrentNetwork WRITE setIndexCurrentNetwork NOTIFY indexCurrentNetworkChanged)

    Q_PROPERTY(QString CurrentChain READ getCurrentChain)
    
    /// Client controller initialization.
    /// @param apDapServiceClient Network connection controller.
    void init(DapServiceClient *apDapServiceClient);
    /// Get company brand.
    /// @return Brand сompany.
    QString getBrand() const;
    /// Get app version.
    /// @return Application version.
    QString getVersion() const;

    QString getCurrentNetwork() const;

    Q_INVOKABLE void setCurrentNetwork(const QString &sCurrentNetwork);

    int getIndexCurrentNetwork() const;

    Q_INVOKABLE void setIndexCurrentNetwork(int iIndexCurrentNetwork);

    Q_INVOKABLE QString getCurrentChain() const;

signals:
    /// The signal is emitted when the Brand company property changes.
    /// @param asBrand Brand
    void brandChanged(const QString &brand);
    /// The signal is emitted when the Application version property changes.
    /// @param version Version
    void versionChanged(const QString &version);

    void currentNetworkChanged(const QString &asCurrentNetwork);
    /// The signal is emitted when a command to activate a client is received.
    void clientActivated();
    ///This signal sends data about saving a file from the Logs tab
    /// @param saveLogRezult
    void saveLogRezult(const QVariant& message);
    ///A signal that is used to transmit data to the log model.
    /// @param logUpdated QStringList
    void logUpdated(const QVariant& logs);
    /// A signal is emitted if a transaction is successfully created.
    /// @param aResult Transaction result.
    void transactionCreated(const QVariant& aResult);
    /// Signal emitted in case of successful processing of the mempool.
    /// @param aResult Mempool processing result.
    void mempoolProcessed(const QVariant& aResult);

    void walletCreated(const QVariant& wallet);

    void walletsListReceived(const QVariant& walletList);

    void walletsReceived(const QList<QObject*>& walletList);

    void networksListReceived(const QVariant& networkList);

    void walletAddressesReceived(const QVariant& walletAddresses);

    void walletTokensReceived(const QVariant& walletTokens);

    void indexCurrentNetworkChanged(int iIndexCurrentNetwork);

    void historyReceived(const QVariant& walletHistory);

    void walletHistoryReceived(const QList<QObject*>& walletHistory);
    /// The signal is emitted when the command is executed by the cli node command handler.
    /// @param asAnswer The response of the cli node command handler.
    void cmdRunned(const QVariant& asAnswer);
    /// The signal is emitted when receiving a history of commands executed by the cli handler.
    /// @param aHistory History of commands executed by cli handler.
    void historyExecutedCmdReceived(const QVariant& aHistory);
    
private slots:
    /// Register command.
    void registerCommand();
    /// Find the emitted signal.
    /// @param aValue Transmitted parameter.
    void findEmittedSignal(const QVariant& aValue);
    /// Register a signal handler for notification results.
    void registerEmmitedSignal();
};

#endif // DAPSERVICECONTROLLER_H

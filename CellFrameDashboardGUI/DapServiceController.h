#ifndef DAPSERVICECONTROLLER_H
#define DAPSERVICECONTROLLER_H

#include <QObject>
#include <QGenericArgument>
#include <QQmlEngine>
#include <QJSEngine>
#include <QVector>
#include <algorithm>
#include <QDataStream>

#include "NotifyController/DapNotifyController.h"
#include "serviceClient/DapServiceClient.h"
#include "DapServiceClientMessage.h"
#include "DapWallet.h"
#include "handlers/DapAbstractCommand.h"
#include "handlers/DapQuitApplicationCommand.h"
#include "handlers/DapActivateClientCommand.h"
#include "handlers/DapCertificateManagerCommands.h"
#include "handlers/DapUpdateLogsCommand.h"
#include "handlers/DapAddWalletCommand.h"
#include "handlers/DapGetWalletInfoCommand.h"
#include "handlers/DapGetWalletsInfoCommand.h"
#include "handlers/DapGetNetworkStatusCommand.h"
#include "handlers/DapNetworkGoToCommand.h"
#include "handlers/DapGetListNetworksCommand.h"
#include "handlers/DapExportLogCommand.h"
#include "handlers/DapGetWalletAddressesCommand.h"
#include "handlers/DapGetWalletTokenInfoCommand.h"
#include "models/DapWalletModel.h"
#include "handlers/DapCreateTransactionCommand.h"
#include "handlers/DapMempoolProcessCommand.h"
#include "handlers/DapGetWalletHistoryCommand.h"
#include "handlers/DapGetAllWalletHistoryCommand.h"
#include "handlers/DapRunCmdCommand.h"
#include "handlers/DapGetHistoryExecutedCmdCommand.h"
#include "handlers/DapSaveHistoryExecutedCmdCommand.h"
#include "handlers/DapGetListOdersCommand.h"
#include "handlers/DapGetNetworksStateCommand.h"
#include "handlers/DapNetworkSingleSyncCommand.h"
#include "handlers/DapRcvNotify.h"
#include "handlers/DapGetListWalletsCommand.h"

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

    bool m_bReadingChains;

    DapNotifyController *m_DapNotifyController;

    /// Service connection management service.
    DapServiceClient *m_pDapServiceClient {nullptr};
    DapServiceClientMessage *m_pDapServiceClientMessage {nullptr};
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

    /// Disconnect all signals
    Q_INVOKABLE void disconnectAll();

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

    Q_PROPERTY(QString CurrentNetwork MEMBER m_sCurrentNetwork READ getCurrentNetwork WRITE setCurrentNetwork NOTIFY currentNetworkChanged)

    Q_PROPERTY(int IndexCurrentNetwork MEMBER m_iIndexCurrentNetwork READ getIndexCurrentNetwork WRITE setIndexCurrentNetwork NOTIFY indexCurrentNetworkChanged)

    Q_PROPERTY(bool ReadingChains MEMBER m_bReadingChains READ getReadingChains WRITE setReadingChains NOTIFY readingChainsChanged)

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

    bool getReadingChains() const;

    Q_INVOKABLE void setReadingChains(bool bReadingChains);


public slots:
    void requestWalletList();
//    void requestWalletInfo(const QString& a_walletName, const QStringList& a_networkName);
    void requestNetworkStatus(QString a_networkName);
    void changeNetworkStateToOnline(QString a_networkName);
    void changeNetworkStateToOffline(QString a_networkName);
    void requestOrdersList();
    void requestNetworksList();

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

    void walletInfoReceived(const QVariant& walletInfo);
    void walletsInfoReceived(const QVariant& walletList);

    void walletsReceived(QList<QObject*> walletList);

    void walletReceived(QObject* wallet);

    void networksListReceived(const QVariant& networksList);


    void networkStatusReceived(const QVariant& networkStatus);
    void newTargetNetworkStateReceived(const QVariant& targetStateString);

    void walletAddressesReceived(const QVariant& walletAddresses);

    void walletTokensReceived(const QVariant& walletTokens);

    void walletsListReceived(const QVariant& walletsList);

    void indexCurrentNetworkChanged(int iIndexCurrentNetwork);

    void readingChainsChanged(bool bReadingChains);

    void historyReceived(const QVariant& walletHistory);

    void allHistoryReceived(const QVariant& walletHistory);

    void walletHistoryReceived(const QList<QObject*>& walletHistory);

    void allWalletHistoryReceived(const QList<QObject*>& walletHistory);
    /// The signal is emitted when the command is executed by the cli node command handler.
    /// @param asAnswer The response of the cli node command handler.
    void cmdRunned(const QVariant& asAnswer);
    /// The signal is emitted when receiving a history of commands executed by the cli handler.
    /// @param aHistory History of commands executed by cli handler.
    void historyExecutedCmdReceived(const QVariant& aHistory);

     //соблюдаем оригинальную типизацию в сигналах, хотя тут лучше MapVariantList или что-то подобное
    void certificateManagerOperationResult(const QVariant& result);

    void ordersListReceived(const QVariant& ordersInfo);
    void ordersReceived(QList<QObject*> orderList);

    void networkStatesListReceived(const QVariant& networksStateList);
    void networksStatesReceived(QList<QObject*> networksStatesList);

    void networksReceived(QList<QObject*> networksList);

    void dapRcvNotify(const QVariant& rcvData);
    void notifyReceived(const QVariant& rcvData);

private slots:
    /// Register command.
    void registerCommand();
    /// Find the emitted signal.
    /// @param aValue Transmitted parameter.
    void findEmittedSignal(const QVariant& aValue);
    /// Register a signal handler for notification results.
    void registerEmmitedSignal();

private:
    void notifySignalsAttach();
    void notifySignalsDetach();

private slots:
    void slotStateSocket(QString state, int isFirst, int isError){emit signalStateSocket(state, isFirst, isError);}

signals:
    void signalStateSocket(QString state, int isFirst, int isError);
};

#endif // DAPSERVICECONTROLLER_H

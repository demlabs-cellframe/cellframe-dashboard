#ifndef DAPSERVICECONTROLLER_H
#define DAPSERVICECONTROLLER_H

#include <QObject>
#include <QQmlEngine>
#include <QJSEngine>
#include <QApplication>
#include <QTimer>
#include <QMap>
#include <QPair>

#include "DapCommandController.h"
#include "DapServiceClient.h"
#include "DapLogModel.h"
#include "DapChainWalletsModel.h"
#include "DapChainNodeNetworkModel.h"
#include "DapScreenHistoryModel.h"
#include "DapSettingsNetworkModel.h"
#include "DapConsoleModel.h"
#include "DapTransaction.h"

#include "DapChainWalletModel.h"

class DapServiceController : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(DapServiceController)
    /// Brand сompany.
    QString m_sBrand {DAP_BRAND};
    /// Application version.
    QString m_sVersion {DAP_VERSION};
    /// Settings file.
    QString m_sSettingFile {DAP_SETTINGS_FILE};
    /// Result execute.
    QString m_sResult;

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
    /// Result execute command.
    Q_PROPERTY(QString Result MEMBER m_sVersion READ getResult NOTIFY resultChanged)

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
    /// Get setting file name.
    /// @return Setting file name
    QString getSettingFile() const;
    /// Get result command execute.
    /// @return Result execute.
    QString getResult();
    /// Get node logs.
    /// @param aiTimeStamp Timestamp start reading logging.
    /// @param aiRowCount Number of lines displayed.
    void getNodeLogs(int aiTimeStamp, int aiRowCount) const;
    /// Get wallets
    Q_INVOKABLE void getWallets() const;
    /// Add new wallet
    /// @param wallet
    Q_INVOKABLE void addWallet(const QString& asWalletName);
    Q_INVOKABLE void removeWallet(int index, const QString& asWalletName);
    Q_INVOKABLE void sendToken(const QString &asSendWallet, const QString& asAddressReceiver, const QString& asToken, const QString& aAmount);
    Q_INVOKABLE void executeCommand(const QString& command);

    /// Get information about wallet
    /// @param name of wallet
    void getWalletInfo(const QString& asWalletName);
    /// Request about new netowrk list
    void getNetworkList();
    /// Get history of commands
    void getCmdHistory();

signals:
    /// The signal is emitted when the Brand company property changes.
    /// @param asBrand Brand
    void brandChanged(const QString &brand);
    /// The signal is emitted when the Application version property changes.
    /// @param version Version
    void versionChanged(const QString &version);
    /// The signal is emitted when the result execute property changes.
    void resultChanged();
    /// The signal is emitted when the main application window is activated.
    void activateWindow();
    /// The signal is emitted when checking the existence of an already running copy of the application.
    /// @param isExistenceClient True if after checking client is exist. False when not
    void isExistenceClient(bool isExistenceClient);
    /// The signal is emitted when sending to QML
    void sendToQML(QString);
    /// The signal is emitted when log message append to log model or logs was cleared
	void logCompleted();
    /// Signal for data network
    /// @param aData Data network
    void sendNodeNetwork(const QVariant& aData);
    void userSettingsLoaded();
    void userSettingsSaved();

private slots:
    /// Handling service response for receiving node logs.
    /// @param aNodeLogs List of node logs.
    void processGetNodeLogs(const QStringList& aNodeLogs);
    /// Handling service response for add new wallet
    /// @param asWalletName Name of wallet
    /// @param asWalletAddress Address of wallet
    void processAddWallet(const QString& asWalletName, const QString& asWalletAddress);
    // TODO: Implement logic to proccess.
    /// Handling service response for send new token
    /// @param asAnswer Answer
    void processSendToken(const QString& asAnswer);
    /// Handling service response for get wallets
    /// @param aWallets Wallets
    void processGetWallets(const QMap<QString, QVariant>& aWallets);
    /// Handling service response for get information about selected wallet
    /// @param asWalletName Name of wallet
    /// @param asWalletAddress Address of wallet
    void processGetWalletInfo(const QString& asWalletName, const QString& asWalletAddress, const QStringList &aBalance, const QStringList& aTokens);
    /// Handling service response for write information of result executing command
    /// @param result Result executing information
    void processExecuteCommandInfo(const QString& result);
    /// Handling service response for get node network
    /// @param aData Data of node network
    void processGetNodeNetwork(const QVariant& aData);
    /// Handling service response for get transaction history
    /// @param Data of history
    void processGetHistory(const QVariant& aData);

public slots:
    /// Get history of transaction
    void getHistory();
    /// Get node network for explorer
    void getNodeNetwork();
    /// Change status of node
    /// @param it is true if a node is online
    void setNodeStatus(const bool aIsOnline);

    /// Get node logs.
    Q_INVOKABLE void getNodeLogs() const;

    void clearLogModel();
    /// Show or hide GUI client by clicking on the tray icon.
    /// @param aIsActivated Accepts true - when requesting to 
    /// display a client, falso - when requesting to hide a client.
    void activateClient(bool aIsActivated);
    /// Shut down client.
    void closeClient();
    /// Load user settings from settings file
    void loadUserSettings();
    /// Save user settings to file
    void saveUserSettings();
    /// Method that implements the singleton pattern for the qml layer.
    /// @param engine QML application.
    /// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
    static QObject *singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);

public slots:
    void requestWalletData();
};

#endif // DAPSERVICECONTROLLER_H

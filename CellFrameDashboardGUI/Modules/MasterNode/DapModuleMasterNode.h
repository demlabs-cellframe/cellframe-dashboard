#pragma once

#include <QObject>
#include <QWidget>
#include <QDebug>
#include <QMap>
#include <QList>
#include <QVariantMap>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "ConfigWorker/configfile.h"

/// Stages
///
/// Creating the certificate for signing blocks
/// Viewing the certificate hash
/// Making changes to the Backbone network configuration file. Making changes to the node configuration file
/// Restarting the node
/// Publishing your node to the public list
/// Locking mCELL
/// Requesting to become a master node
///
/// Creating an order for the validator fee
/// Restarting the node
/// Sending anonymous diagnostic data to the Cellframe team ??


class DapModuleMasterNode : public DapAbstractModule
{
    enum LaunchStage
    {
        CHECK_PUBLIC_KEY = 0,
        UPDATE_CONFIG,
        RESTARTING_NODE,
        ADDINNG_NODE_DATA,
        SENDING_STAKE,
        CHECKING_STAKE,
        SEND_FORM,
        ORDER_VALIDATOR
    };

    enum TransctionStage
    {
        UNKNOWN = 0,
        QUEUE,
        MEMPOOL,
        CHECK
    };

    struct MasterNodeValidator
    {
        bool availabilityOrder;
        bool nodePresence;
        QString nodeWeight;
        QString nodeStatus;
        QString blocksSigned;
        QString totalRewards;
        QString networksBlocks;
    };

    struct MasterNodeVPN
    {
    };

    struct MasterNodeDEX
    {
    };

    struct MasterNodeInfo
    {
        bool isMaster = false;
        bool isOfline = false;
        QString publicKey = "";
        QString nodeAddress = "";
        QString nodeIP = "";
        QString nodePort = "";
        QString stakeAmount = "";
        QString stakeHash = "";
        QString walletName= "";
        QString walletAddr = "";
        MasterNodeValidator validator;
        MasterNodeVPN vpn;
        MasterNodeDEX dex;
    };

    Q_OBJECT
public:
    explicit DapModuleMasterNode(DapModulesController *parent);

    Q_PROPERTY(QString stakeTokenName READ stakeTokenName NOTIFY currentNetworkChanged)
    QString stakeTokenName() const;

    Q_PROPERTY(QString mainTokenName READ mainTokenName NOTIFY currentNetworkChanged)
    QString mainTokenName() const;

    Q_PROPERTY(QString currentNetwork READ currentNetwork WRITE setCurrentNetwork NOTIFY currentNetworkChanged)
    QString currentNetwork() const { return m_currentNetwork;}
    void setCurrentNetwork(const QString& networkName);

    Q_PROPERTY(QString currentWalletName READ currentWalletName NOTIFY currentWalletNameChanged)
    QString currentWalletName() const { return m_masterNodeInfo[m_currentNetwork].isMaster ? m_masterNodeInfo[m_currentNetwork].walletName : QString();}

    Q_PROPERTY(int creationStage READ creationStage NOTIFY creationStageChanged)
    int creationStage() const;

    Q_INVOKABLE int startMasterNode(const QVariantMap& value);

    Q_PROPERTY(QString networksList READ networksList NOTIFY networksListChanged)
    QString networksList() const;

    Q_PROPERTY(QVariantMap masterNodeData READ masterNodeData NOTIFY masterNodeDataChanged)
    QVariantMap masterNodeData() const;

    Q_PROPERTY(QVariantMap validatorData READ validatorData NOTIFY validatorDataChanged)
    QVariantMap validatorData() const;

    Q_INVOKABLE bool tryGetInfoCertificate(const QString& filePath);
    Q_INVOKABLE void clearCertificate();

    Q_PROPERTY(QString certName READ getCertName NOTIFY certNameChanged)
    QString getCertName() const {return m_certName;}
    void setCertName(const QString& name);

    Q_PROPERTY(QString signature READ getSignature NOTIFY signatureChanged)
    QString getSignature() const {return m_signature;}
    void setSignature(const QString& signature);

    Q_PROPERTY(bool isRegistrationNode READ getIsRegistrationNode NOTIFY registrationNodeStarted)
    bool getIsRegistrationNode() const {return !m_startStage.isEmpty();}

    Q_PROPERTY(bool isSandingDataStage READ isSandingDataStage NOTIFY creationStageChanged)
    bool isSandingDataStage() const;

    Q_PROPERTY(bool isMasterNode READ isMasterNode NOTIFY masterNodeChanged)
    bool isMasterNode() const;

    Q_INVOKABLE QString getMasterNodeData(const QString& key);

    Q_INVOKABLE void moveCertificate(const QString& path = "");
    Q_INVOKABLE void moveWallet(const QString& path = "");
signals:
    void currentNetworkChanged();
    void currentWalletNameChanged();
    void creationStageChanged();
    void masterNodeCreated();
    void networksListChanged();
    void masterNodeDataChanged();
    void validatorDataChanged();
    void certNameChanged();
    void signatureChanged();

    void registrationNodeStarted();
    void masterNodeChanged();

    void certMovedSignal(const int numMessage);
    void walletMovedSignal(const int numMessage);
private slots:
    void respondCreateCertificate(const QVariant &rcvData);
    void nodeRestart();
    void networkListUpdateSlot();

    void workNodeChanged();
    void addedNode(const QVariant &rcvData);
    void respondNetworkStatus(const QVariant &rcvData);
    void respondNodeListCommand(const QVariant &rcvData);

    void respondStakeDelegate(const QVariant &rcvData);
    void respondCheckStakeDelegate(const QVariant &rcvData);
    void respondMempoolCheck(const QVariant &rcvData);
    void respondListKeys(const QVariant &rcvData);
    void respondCreatedStakeOrder(const QVariant &rcvData);
    void respondMoveWalletCommand(const QVariant &rcvData);

    void mempoolCheck();
    void checkStake();
    void createStakeOrder();
private:
    void createMasterNode();
    void stageComplated();

    void saveStageList();
    void loadStageList();
    void clearStageList();
    void saveCurrentRegistration();
    void loadCurrentRegistration();
    void clearCurrentRegistration();
    void saveMasterNodeBase();
    void loadMasterNodeBase();
    void clearMasterNodeBase();

    void createCertificate();
    void getInfoCertificate();
    
    void dumpCertificate();
    void getHashCertificate(const QString& certName);
    void tryStopCreationMasterNode(int code, const QString &message = "");
    void addNode();

    void stakeDelegate();
    void tryCheckStakeDelegate();
    void getInfoNode();
    void getNodeLIst();

    void tryUpdateNetworkConfig();
    void tryRestartNode();
    void startWaitingNode();

    void addNetwork(const QString &net);
    bool checkTokenName() const;

    void startWaitingPermission();
    void getListKeys();

    void finishRegistration();

    void createDemoNode();
    //    name     path
    QPair<QString, QString> parsePath(const QString& filePath, bool isCert = true);
private:
    DapModulesController  *m_modulesCtrl;
    QTimer* m_checkStakeTimer = nullptr;
    QTimer* m_listKeysTimer = nullptr;

    QString m_currentNetwork = "raiden";

    QList<QVariantMap> m_startedMasterNodeList;

    QVariantMap m_currantStartMaster;
    QMap<QString, QVariantMap> m_masterNodes;

    QList<QPair<LaunchStage, int>> m_startStage;

    QString m_certName = "-";
    QString m_signature = "-";
    QString m_certPath;
    bool m_isNetworkStatusRequest = false;
    bool m_isNodeListRequest = false;

    bool m_certMovedKeyRequest = false;
    bool m_walletMovedKeyRequest = false;

    const int TIME_OUT_CHECK_STAKE = 5000;
    const int TIME_OUT_LIST_KEYS = 30000;

    const QMap<QString, QPair<QString, QString>> m_tokens = {{"Backbone", qMakePair(QString("mCELL"), QString("CELL"))},
                                                             {"KelVPN", qMakePair(QString("mKEL"), QString("KEL"))},
                                                             {"raiden", qMakePair(QString("mtCELL"), QString("tCELL"))},
                                                             {"riemann", qMakePair(QString("mtKEL"), QString("tKEL"))},
                                                             {"mileena", qMakePair(QString("mtMIL"), QString("tMIL"))},
                                                             {"subzero", qMakePair(QString("mtCELL"), QString("tCELL"))}};


    QMap<QString, MasterNodeInfo> m_masterNodeInfo;

    const QList<QPair<LaunchStage, int>> PATTERN_STAGE = {{LaunchStage::CHECK_PUBLIC_KEY, 0},
                                                          {LaunchStage::UPDATE_CONFIG, 1},
                                                          {LaunchStage::RESTARTING_NODE, 2},
                                                          {LaunchStage::ADDINNG_NODE_DATA, 3},
                                                          {LaunchStage::SENDING_STAKE, 4},
                                                          {LaunchStage::CHECKING_STAKE, 5},
                                                          {LaunchStage::SEND_FORM, 6},
                                                          {LaunchStage::ORDER_VALIDATOR, 7},
                                                          {LaunchStage::RESTARTING_NODE, 8}};

    const QString STAKE_HASH_KEY = "stakeHash";
    const QString QUEUE_HASH_KEY = "queueHash";

    const QString IS_UPLOAD_CERT_KEY = "isUploadCert";
    const QString CERT_NAME_KEY = "certName";
    const QString CERT_SIGN_KEY = "sign";
    const QString CERT_HASH_KEY = "certHash";
    const QString CERT_PATH_KEY = "certPath";
    const QString NODE_ADDR_KEY = "nodeAddress";
    const QString WALLET_NAME_KEY = "walletName";
    const QString WALLET_ADDR_KEY = "walletAddress";
    const QString NETWORK_KEY = "network";
    const QString FEE_KEY = "fee";
    const QString FEE_TOKEN_KEY = "feeToken";
    const QString NODE_IP_KEY = "nodeIP";
    const QString PORT_KEY = "port";
    const QString STAKE_VALUE_KEY = "stakeValue";
    const QString STAKE_TOKEN_KEY = "stakeToken";
    const QString STAKE_FEE_KEY = "stakeFee";
};

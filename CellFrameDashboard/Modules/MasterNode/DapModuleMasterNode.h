#pragma once

#include <QObject>
#include <QWidget>
#include <QDebug>
#include <QMap>
#include <QList>
#include <QVariantMap>
#include <QMetaEnum>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "MasterNodeCommand/DapSrvStakeInvalidateStage.h"
#include "MasterNodeCommand/DapStakeDelegate.h"
#include "MasterNodeCommand/DapWaitingPermission.h"
#include "MasterNodeCommand/DapUpdateConfigStage.h"
#include "MasterNodeCommand/DapNodeDelStage.h"
#include "DapMasterNodeKeys.h"

class DapModuleMasterNode : public DapAbstractModule
{
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
        bool isRegNode = false;
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
    enum LaunchStage
    {
        CHECK_PUBLIC_KEY = 0,
        UPDATE_CONFIG,
        RESTARTING_NODE,
        ADDINNG_NODE_DATA,
        SENDING_STAKE,
        SEND_FORM,
        ORDER_VALIDATOR,
        ORDER_REMOVE,
        BACK_CONFIG,
        BACK_STAKE,
        NODE_REMOVE
    };
    Q_ENUM(LaunchStage)

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

    Q_PROPERTY(QString certNameFromStartMasterNode READ certNameFromStartMasterNode NOTIFY certNameFromStartMasterNodeChanged)
    QString certNameFromStartMasterNode() const { return m_currentStartMaster.isEmpty() ? QString() : m_currentStartMaster[MasterNode::NETWORK_KEY].toString();}

    Q_INVOKABLE int startMasterNode(const QVariantMap& value);

    Q_PROPERTY(QString networksList READ networksList NOTIFY networksListChanged)
    QString networksList() const;

    Q_PROPERTY(QVariantMap masterNodeData READ masterNodeData NOTIFY masterNodeDataChanged)
    QVariantMap masterNodeData() const;

    Q_PROPERTY(QVariantMap validatorData READ validatorData NOTIFY validatorDataChanged)
    QVariantMap validatorData() const;

    Q_INVOKABLE bool tryGetInfoCertificate(const QString& filePath, const QString &type = Dap::CategoryCert::USER_CERT);
    Q_INVOKABLE void clearCertificate();

    Q_INVOKABLE QString getMasterNodeCertName();

    Q_PROPERTY(QString certName READ getCertName NOTIFY certNameChanged)
    QString getCertName() const {return m_certName;}
    void setCertName(const QString& name);

    Q_PROPERTY(QString signature READ getSignature NOTIFY signatureChanged)
    QString getSignature() const {return m_signature;}
    void setSignature(const QString& signature);

    Q_INVOKABLE QVariant getDataRegistration(const QString& nameData) const;

    Q_PROPERTY(bool isRegistrationNode READ getIsRegistrationNode NOTIFY registrationNodeChanged)
    bool getIsRegistrationNode() const {return !m_startStage.isEmpty();}

    Q_PROPERTY(bool isSandingDataStage READ isSandingDataStage NOTIFY creationStageChanged)
    bool isSandingDataStage() const;

    Q_PROPERTY(bool isMasterNode READ isMasterNode NOTIFY masterNodeChanged)
    bool isMasterNode() const;

    Q_PROPERTY(bool isStartRegistration READ isStartRegistration NOTIFY isStartRegistrationChanged)
    bool isStartRegistration() const { return !m_currentStartMaster.contains(MasterNode::MASTER_NODE_TO_CENCEL_KEY); }

    Q_INVOKABLE QString getMasterNodeData(const QString& key);
    Q_INVOKABLE QString getMasterNodeDataByNetwork(const QString& network, const QString& key);

    Q_INVOKABLE void moveCertificate(const QString& path = "");
    Q_INVOKABLE void moveWallet(const QString& path = "");

    Q_INVOKABLE void createStakeOrderForMasterNode(const QString& fee, const QString& certName);
    Q_INVOKABLE bool isUploadCertificate();
    Q_INVOKABLE QList<int> getFullStepsLoader() const;
    Q_INVOKABLE void cencelRegistration();
    Q_INVOKABLE void continueRegistrationNode();

    Q_PROPERTY(int currentStage READ getCurrentStage NOTIFY creationStageChanged)
    Q_INVOKABLE int getCurrentStage();

    Q_PROPERTY(int errorStage READ getErrorStage NOTIFY errorCreation)
    Q_INVOKABLE int getErrorStage(){return m_errorStage;}

    Q_PROPERTY(int errorMessage READ getErrorMessage NOTIFY errorCreation)
    Q_INVOKABLE int getErrorMessage(){return m_errorCode;}
signals:
    void currentNetworkChanged();
    void certNameFromStartMasterNodeChanged();
    void currentWalletNameChanged();
    void creationStageChanged();
    void masterNodeCreated();
    void networksListChanged();
    void masterNodeDataChanged();
    void validatorDataChanged();
    void certNameChanged();
    void signatureChanged();
    void errorCreation(int numMessage = -1);

    void registrationNodeChanged();
    void masterNodeChanged();

    void certMovedSignal(const int numMessage);
    void walletMovedSignal(const int numMessage);

    void createdStakeOrder(const bool& result);
    void fullStageListUpdate();
    void isStartRegistrationChanged();
    void registrationCenceled();
private slots:
    void respondCreateCertificate(const QVariant &rcvData);
    void networkListUpdateSlot();

    void workNodeChanged();
    void addedNode(const QVariant &rcvData);
    void respondNetworkStatus(const QVariant &rcvData);
    void respondNodeListCommand(const QVariant &rcvData);

    void respondCreatedStakeOrder(const QVariant &rcvData);
    void respondMoveWalletCommand(const QVariant &rcvData);

    void createStakeOrder();
private:
    void createMasterNode();
    void stageComplated();

    void saveStageList();
    void loadStageList();
    void clearStageList();
    void saveFullStagesList();
    void loadFullStagesList();
    void clearFullStagesList();
    void saveCurrentRegistration();
    void loadCurrentRegistration();
    void clearCurrentRegistration();
    void saveMasterNodeBase();
    void loadMasterNodeBase();
    void clearMasterNodeBase();

    void createCertificate();
    void getInfoCertificate();
    
    void dumpCertificate(const QString &type);
    void getHashCertificate(const QString& certName);
    void tryStopCreationMasterNode(int code, const QString &message = "");
    void addNode();

    void getInfoNode();
    void getNodeLIst();

    void tryRestartNode();

    void addNetwork(const QString &net);
    bool checkTokenName() const;

    void finishRegistration();
    void cenceledRegistration();

    void setFullStageList(const QList<QPair<LaunchStage, int>>& stages);

    void createDemoNode();
    //    name     path
    QPair<QString, QString> parsePath(const QString& filePath, bool isCert = true);

    QString getStageString(LaunchStage stage) const;
    QString launchStageString(LaunchStage value);
private:
    DapStakeDelegate* m_stakeDelegate = nullptr;
    DapSrvStakeInvalidateStage* m_srvStakeInvalidate = nullptr;
    DapWaitingPermission* m_waitingPermission = nullptr;
    DapUpdateConfigStage* m_updateConfig = nullptr;
    DapNodeDelStage* m_nodeDelStage = nullptr;

    QString m_currentNetwork = "";

    QList<QVariantMap> m_startedMasterNodeList;

    QVariantMap m_currentStartMaster;
    QMap<QString, QVariantMap> m_masterNodes;

    QList<QPair<LaunchStage, int>> m_startStage;

    QString m_certName = "-";
    QString m_signature = "-";
    QString m_certPath;
    bool m_isNetworkStatusRequest = false;
    bool m_isNodeListRequest = false;

    bool m_certMovedKeyRequest = false;
    bool m_walletMovedKeyRequest = false;

    bool m_isNeedStartRegistration = false;

    int m_errorStage = -1;
    int m_errorCode = -1;

    const QMap<QString, QPair<QString, QString>> m_tokens = {{"Backbone", qMakePair(QString("mCELL"), QString("CELL"))},
                                                             {"KelVPN", qMakePair(QString("mKEL"), QString("KEL"))},
                                                             {"raiden", qMakePair(QString("mtCELL"), QString("tCELL"))},
                                                             {"riemann", qMakePair(QString("mtKEL"), QString("tKEL"))},
                                                             {"mileena", qMakePair(QString("mtMIL"), QString("tMIL"))},
                                                             {"subzero", qMakePair(QString("mtCELL"), QString("tCELL"))}};


    QMap<QString, MasterNodeInfo> m_masterNodeInfo;
    QList<QPair<LaunchStage, int>> m_currentFullStages;

    const QList<QPair<LaunchStage, int>> PATTERN_STAGE = {{LaunchStage::CHECK_PUBLIC_KEY, 0},
                                                          {LaunchStage::UPDATE_CONFIG, 1},
                                                          {LaunchStage::RESTARTING_NODE, 2},
                                                          {LaunchStage::ADDINNG_NODE_DATA, 3},
                                                          {LaunchStage::SENDING_STAKE, 4},
                                                          {LaunchStage::SEND_FORM, 5},
                                                          {LaunchStage::ORDER_VALIDATOR, 6},
                                                          {LaunchStage::RESTARTING_NODE, 7}};
};

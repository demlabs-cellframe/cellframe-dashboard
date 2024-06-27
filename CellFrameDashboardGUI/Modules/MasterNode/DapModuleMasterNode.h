#pragma once

#include <QObject>
#include <QWidget>
#include <QDebug>
#include <QMap>
#include <QList>

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
        CHECKING_ALL_DATA
    };

    enum TransctionStage
    {
        UNKNOWN = 0,
        QUEUE,
        MEMPOOL,
        CHECK
    };

    Q_OBJECT
public:
    explicit DapModuleMasterNode(DapModulesController *parent);

    Q_PROPERTY(QString stakeTokenName READ stakeTokenName NOTIFY currentNetworkChanged)
    QString stakeTokenName() const;

    Q_PROPERTY(QString currentNetwork READ currentNetwork NOTIFY currentNetworkChanged)
    QString currentNetwork() const { return m_currentNetwork;}
    void setCurrentNetwork(const QString& networkName);

    Q_PROPERTY(int creationStage READ creationStage NOTIFY creationStageChanged)
    int creationStage() const;

    Q_INVOKABLE int startMasterNode(const QVariantMap& value);

signals:
    void currentNetworkChanged();
    void creationStageChanged();
    void masterNodeCreated();
private slots:
    void respondCreateCertificate(const QVariant &rcvData);
    void nodeRestart();

    void workNodeChanged();
    void addedNode(const QVariant &rcvData);

    void respondStakeDelegate(const QVariant &rcvData);
    void respondCheckStakeDelegate(const QVariant &rcvData);
    void respondMempoolCheck(const QVariant &rcvData);

    void mempoolCheck();
    void checkStake();
private:
    void createMasterNode();
    void stageComplated();

    void saveStageList();
    void loadStageList();

    void createCertificate();
    void getInfoCertificate();
    void getHashCertificate(const QString& certName);
    void tryStopCreationMasterNode(const QString &message);
    void addNode();
    void stakeDelegate();
    void tryCheckStakeDelegate();

    void tryUpdateNetworkConfig();
    void tryRestartNode();
    void startWaitingNode();

private:
    DapModulesController  *m_modulesCtrl;
    QTimer* m_checkStakeTimer = nullptr;

    QString m_currentNetwork = "raiden";

    QList<QVariantMap> m_startedMasterNodeList;

    QVariantMap m_currantStartMaster;
    QList<LaunchStage> m_startStage;

    const int TIME_OUT_CHECK_STAKE = 5000;

    const QMap<QString, QString> m_stakeTokens = {{"Backbone","mCELL"},
                                                  {"KelVPN","mKEL"},
                                                  {"raiden","mtCELL"},
                                                  {"riemann","mtKEL"},
                                                  {"mileena","mtMIL"},
                                                  {"subzero","mtCELL"}};

    const QList<LaunchStage> PATTERN_STAGE = {LaunchStage::CHECK_PUBLIC_KEY,
                                               LaunchStage::UPDATE_CONFIG,
                                               LaunchStage::RESTARTING_NODE,
                                               LaunchStage::ADDINNG_NODE_DATA,
                                               LaunchStage::SENDING_STAKE,
                                               LaunchStage::CHECKING_STAKE,
                                               LaunchStage::RESTARTING_NODE,
                                               LaunchStage::CHECKING_ALL_DATA};

    const QString STAKE_HASH_KEY = "stakeHash";
    const QString QUEUE_HASH_KEY = "queueHash";
};

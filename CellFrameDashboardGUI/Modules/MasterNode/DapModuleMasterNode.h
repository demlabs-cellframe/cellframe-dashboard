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

class DapModuleMasterNode : public DapAbstractModule
{
    enum LaunchStage
    {
        CHECK_PUBLIC_KEY = 1,
        UPDATE_CONFIG,
        TRY_RESTART_NODE,
        RESTARTING_NODE,
        CREATING_ORDER,
        ADDINNG_NODE_DATA,
        CHECKING_STAKE,
        SENDING_STAKE,
        CHECKING_ALL_DATA
    };

    Q_OBJECT
public:
    explicit DapModuleMasterNode(DapModulesController *parent);

    Q_PROPERTY(QString stakeTokenName READ stakeTokenName NOTIFY currentNetworkChanged)
    QString stakeTokenName() const;

    Q_PROPERTY(QString mainTokenName READ mainTokenName NOTIFY currentNetworkChanged)
    QString mainTokenName() const;

    Q_PROPERTY(QString currentNetwork READ currentNetwork NOTIFY currentNetworkChanged)
    QString currentNetwork() const { return m_currentNetwork;}
    void setCurrentNetwork(const QString& networkName);

    Q_PROPERTY(int creationStage READ creationStage NOTIFY creationStageChanged)
    int creationStage() const;

    Q_INVOKABLE int startMasterNode(const QVariantMap& value);

    Q_PROPERTY(QString networksList READ networksList NOTIFY networksListChanged)
    QString networksList() const;


signals:
    void currentNetworkChanged();
    void creationStageChanged();
    void masterNodeCreated();
    void networksListChanged();
private slots:
    void respondCreateCertificate(const QVariant &rcvData);
    void nodeRestart();
    void networkListUpdateSlot();
private:
    void createMasterNode();
    void stageComplated();

    void saveStageList();
    void loadStageList();

    void createCertificate();
    void getInfoCertificate();
    void tryStopCreationMasterNode();

    void tryUpdateNetworkConfig();
    void tryRestartNode();
    void startWaitingNode();

    //    void tryPublishingNode();
    //    void tryBlockToken();

private:
    DapModulesController  *m_modulesCtrl;

    QString m_currentNetwork = "raiden";

    QVariantMap m_currantStartMaster;
    QList<LaunchStage> m_startStage;

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
        bool isMaster;
        QString walletName;
        QString publicKey;
        QString nodeAddress;
        QString nodeIP;
        QString nodePort;
        QString stakeAmount;
        QString hash;
        MasterNodeValidator validator;
        MasterNodeVPN vpn;
        MasterNodeDEX dex;
    };


    const QMap<QString, QPair<QString, QString>> m_tokens = {{"Backbone", qMakePair(QString("mCELL"), QString("CELL"))},
                                                             {"KelVPN", qMakePair(QString("mKEL"), QString("KEL"))},
                                                             {"raiden", qMakePair(QString("mtCELL"), QString("tCELL"))},
                                                             {"riemann", qMakePair(QString("mtKEL"), QString("tKEL"))},
                                                             {"mileena", qMakePair(QString("mtMIL"), QString("tMIL"))},
                                                             {"subzero", qMakePair(QString("mtCELL"), QString("tCELL"))}};



    QMap<QString, MasterNodeInfo> m_masterNodeInfo;

    void addNetwork(const QString &net);
    bool checkTokenName() const;


    const QList<LaunchStage> PATTERN_STAGE = {LaunchStage::CHECK_PUBLIC_KEY,
                                              LaunchStage::UPDATE_CONFIG,
                                              LaunchStage::TRY_RESTART_NODE,
                                              LaunchStage::RESTARTING_NODE,
                                              LaunchStage::CREATING_ORDER,
                                              LaunchStage::ADDINNG_NODE_DATA,
                                              LaunchStage::CHECKING_STAKE,
                                              LaunchStage::SENDING_STAKE,
                                              LaunchStage::TRY_RESTART_NODE,
                                              LaunchStage::RESTARTING_NODE,
                                              LaunchStage::CHECKING_ALL_DATA};
};

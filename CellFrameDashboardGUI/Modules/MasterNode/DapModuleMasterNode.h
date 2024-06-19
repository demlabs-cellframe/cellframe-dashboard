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



    const QMap<QString, QString> m_stakeTokens = {{"Backbone","mCELL"},
                                                  {"KelVPN","mKEL"},
                                                  {"raiden","mtCELL"},
                                                  {"riemann","mtKEL"},
                                                  {"mileena","mtMIL"},
                                                  {"subzero","mtCELL"}};

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

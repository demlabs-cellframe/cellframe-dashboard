#pragma once

#include <QObject>
#include <QWidget>
#include <QDebug>
#include <QMap>
#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleMasterNode : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleMasterNode(DapModulesController *parent);

    Q_PROPERTY(QString stakeTokenName READ stakeTokenName NOTIFY currentNetworkChanged)
    QString stakeTokenName() const;

    Q_PROPERTY(QString currentNetwork READ currentNetwork NOTIFY currentNetworkChanged)
    QString currentNetwork() const { return m_currentNetwork;}
    void setCurrentNetwork(const QString& networkName);

signals:
    void currentNetworkChanged();

private:
    DapModulesController  *m_modulesCtrl;

    QString m_currentNetwork = "";

    const QMap<QString, QString> m_stakeTokens = {{"Backbone","mCELL"},
                                                  {"KelVPN","mKEL"},
                                                  {"raiden","mtCELL"},
                                                  {"riemann","mtKEL"},
                                                  {"mileena","mtMIL"},
                                                  {"subzero","mtCELL"}};
};

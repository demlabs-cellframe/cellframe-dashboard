#ifndef DAPMODULESETTINGS_H
#define DAPMODULESETTINGS_H

#include <QObject>
#include <QDebug>
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleSettings : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleSettings(DapModulesController * modulesCtrl);
    ~DapModuleSettings();

    Q_PROPERTY(QString nodeVersion READ nodeVersion NOTIFY nodeVersionChanged)
    Q_INVOKABLE QString nodeVersion(){return m_nodeVersion;};

    Q_PROPERTY(QString dashboardVersion READ dashboardVersion NOTIFY dashboardVersionChanged)
    Q_INVOKABLE QString dashboardVersion(){return m_dashboardVersion;};

    Q_PROPERTY(bool guiRequest READ guiRequest NOTIFY guiRequestChanged)
    Q_INVOKABLE bool guiRequest(){return m_guiVersionRequest;};

    Q_PROPERTY(bool clearDataProcessing READ clearDataProcessing NOTIFY clearDataProcessingChanged)
    Q_INVOKABLE bool clearDataProcessing(){return m_isNodeAutoRun;}

    Q_PROPERTY(bool isNodeStarted READ isNodeStarted NOTIFY isNodeStartedChanged)
    Q_INVOKABLE bool isNodeStarted(){return m_isNodeStarted;}

    Q_PROPERTY(bool isNodeAutorun READ isNodeAutorun NOTIFY isNodeAutorunChanged)
    Q_INVOKABLE bool isNodeAutorun(){return m_isNodeStarted;}

    Q_INVOKABLE void checkVersion();
    Q_INVOKABLE void guiVersionRequest();

    Q_INVOKABLE void clearNodeData();
public:
    QString m_nodeVersion{""};
    QString m_dashboardVersion{DAP_VERSION};
    bool m_guiVersionRequest{false};
    bool m_clearDataProcessing{false};

signals:
    void sigVersionInfo(const QVariant& result);

    void sigNodeDataRemoved();

    void nodeVersionChanged();
    void dashboardVersionChanged();
    void guiRequestChanged();
    void clearDataProcessingChanged();
    void isNodeStartedChanged();
    void isNodeAutorunChanged();

    void resultNodeRequest(QString);
    void errorNodeRequest(QString);
private slots:
    void rcvVersionInfo(const QVariant& result);
    void timeoutVersionInfo();
    void resultCrearData(const QVariant& result);

    void nodeInfoRcv(const QVariant& rcvData);
private:
    void initConnect();

    void setNodeStatus(bool isStart);
    void setNodeAutorun(bool isEnable);

private:
    DapModulesController  *m_modulesCtrl;
    QTimer *m_timerVersionCheck;
    QTimer *m_timerTimeoutService;

    bool m_isNodeStarted = true;
    bool m_isNodeAutoRun = true;

    const QString SETTINGS_NODE_ENABLE_KEY = "nodeEnable";

};

#endif // DAPMODULESETTINGS_H

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
    Q_INVOKABLE bool clearDataProcessing(){return m_clearDataProcessing;};

public:
    QString m_nodeVersion{""};
    QString m_dashboardVersion{DAP_VERSION};
    bool m_guiVersionRequest{false};
    bool m_clearDataProcessing{false};

private:
    DapModulesController  *m_modulesCtrl;
    QTimer *m_timerVersionCheck;
    QTimer *m_timerTimeoutService;


private:
    void initConnect();

public:
    Q_INVOKABLE void checkVersion();
    Q_INVOKABLE void guiVersionRequest();

    Q_INVOKABLE void clearNodeData();

private slots:
    void rcvVersionInfo(const QVariant& result);
    void timeoutVersionInfo();
    void resultCrearData(const QVariant& result);

signals:
    void sigVersionInfo(const QVariant& result);

    void sigNodeDataRemoved();

    void nodeVersionChanged();
    void dashboardVersionChanged();
    void guiRequestChanged();
    void clearDataProcessingChanged();
};

#endif // DAPMODULESETTINGS_H

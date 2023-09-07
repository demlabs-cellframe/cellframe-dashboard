#ifndef DAPMODULEDIAGNOSTICS_H
#define DAPMODULEDIAGNOSTICS_H

#include <QObject>
#include <QTimer>
#include <QElapsedTimer>
#include <QThread>
#include "Models/DapDiagnosticModel.h"

#ifdef Q_OS_LINUX
    #include <unistd.h>
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include "LinuxDiagnostic.h"
#elif defined Q_OS_WIN
    #include "WinDiagnostic.h"
#elif defined Q_OS_MAC
    #include "MacDiagnostic.h"
#endif

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleDiagnostics : public DapAbstractModule
{
    Q_OBJECT

public:
    Q_PROPERTY(bool flagSendData        READ flagSendData       WRITE setflagSendData       NOTIFY flagSendDataChanged)
    Q_PROPERTY(bool flagSendSysTime     READ flagSendSysTime    WRITE setFlagSendSysTime    NOTIFY flagSendSysTimeChanged)
    Q_PROPERTY(bool flagSendDahsTime    READ flagSendDahsTime   WRITE setFlagSendDahsTime   NOTIFY flagSendDahsTimeChanged)
    Q_PROPERTY(bool flagSendMemory      READ flagSendMemory     WRITE setFlagSendMemory     NOTIFY flagSendMemoryChanged)
    Q_PROPERTY(bool flagSendMemoryFree  READ flagSendMemoryFree WRITE setFlagSendMemoryFree NOTIFY flagSendMemoryFreeChanged)

    Q_PROPERTY(QByteArray nodeList          READ nodeList           NOTIFY nodeListChanged);
    Q_PROPERTY(QByteArray nodeListSelected  READ nodeListSelected   NOTIFY nodeListSelectedChanged);
    Q_PROPERTY(QByteArray dataSelectedNodes READ dataSelectedNodes  NOTIFY dataSelectedNodesChanged);

    Q_PROPERTY(int trackedNodesCount  READ trackedNodesCount   NOTIFY nodesCountChanged);
    Q_PROPERTY(int allNodesCount      READ allNodesCount  NOTIFY nodesCountChanged);

    Q_INVOKABLE bool flagSendData() const;
    Q_INVOKABLE void setflagSendData(const bool &flagSendData);

    Q_INVOKABLE bool flagSendSysTime() const;
    Q_INVOKABLE void setFlagSendSysTime(const bool &flagSendSysTime);

    Q_INVOKABLE bool flagSendDahsTime() const;
    Q_INVOKABLE void setFlagSendDahsTime(const bool &flagSendDahsTime);

    Q_INVOKABLE bool flagSendMemory() const;
    Q_INVOKABLE void setFlagSendMemory(const bool &flagSendMemory);

    Q_INVOKABLE bool flagSendMemoryFree() const;
    Q_INVOKABLE void setFlagSendMemoryFree(const bool &flagSendMemoryFree);

    Q_INVOKABLE QByteArray nodeList() const;
    Q_INVOKABLE QByteArray nodeListSelected() const;
    Q_INVOKABLE QByteArray dataSelectedNodes() const;

    Q_INVOKABLE int trackedNodesCount() const;
    Q_INVOKABLE int allNodesCount() const;

    Q_INVOKABLE void addNodeToList(QString mac);
    Q_INVOKABLE void removeNodeFromList(QString mac);

    Q_INVOKABLE void searchSelectedNodes(QString filtr);
    Q_INVOKABLE void searchAllNodes(QString filtr);

    friend class DapModulesController;

public:
    explicit DapModuleDiagnostics(DapModulesController * modulesCtrl, DapAbstractModule *parent = nullptr);
    ~DapModuleDiagnostics();


private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;

    QThread *s_thread;

    QString m_node_version{""};
    QSettings m_settings;

    bool m_flag_stop_send_data{false};

    AbstractDiagnostic* m_diagnostic;

private slots:
    void slot_diagnostic_data(QJsonDocument);
    void slot_uptime();
    void slot_update_node_list();

private:
    void try_update_data(const QJsonDocument list, const QJsonDocument data);

public:

    QTimer *s_uptime_timer, *s_node_list_timer;
    QElapsedTimer *s_elapsed_timer;
    QString s_uptime{"00:00:00"};

    QJsonDocument s_node_list, s_node_list_selected, s_data_selected_nodes;


signals:
    void signalDiagnosticData(QByteArray);

    void flagSendSysTimeChanged();
    void flagSendDahsTimeChanged();
    void flagSendMemoryChanged();
    void flagSendMemoryFreeChanged();
    void flagSendDataChanged();

    void nodeListChanged();
    void nodeListSelectedChanged();
    void dataSelectedNodesChanged();
    void nodesCountChanged();

    void filtrSelectedNodesDone(QByteArray);
    void filtrAllNodesDone(QByteArray);
};

#endif // DAPMODULEDIAGNOSTICS_H

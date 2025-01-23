#ifndef DAPMODULEDIAGNOSTICS_H
#define DAPMODULEDIAGNOSTICS_H

#include <QObject>
#include <QThread>
#include <QSettings>

#include "Models/DapDiagnosticModel.h"

#include "AbstractDiagnostic.h"
#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleDiagnostics : public DapAbstractModule
{
    Q_OBJECT

public:
    Q_PROPERTY(bool flagSendData        READ flagSendData         WRITE setflagSendData       NOTIFY flagSendDataChanged)
    Q_PROPERTY(bool socketConnectStatus READ socketConnectStatus  NOTIFY socketConnectStatusChanged)

    Q_PROPERTY(QByteArray nodeList          READ nodeList           NOTIFY nodeListChanged)
    Q_PROPERTY(QByteArray nodeListSelected  READ nodeListSelected   NOTIFY nodeListSelectedChanged)
    Q_PROPERTY(QByteArray dataSelectedNodes READ dataSelectedNodes  NOTIFY dataSelectedNodesChanged)

    Q_PROPERTY(int trackedNodesCount  READ trackedNodesCount   NOTIFY nodesCountChanged)
    Q_PROPERTY(int allNodesCount      READ allNodesCount  NOTIFY nodesCountChanged)

    Q_INVOKABLE bool flagSendData() const;
    Q_INVOKABLE void setflagSendData(const bool &flagSendData);

    Q_INVOKABLE bool socketConnectStatus() const;

    Q_INVOKABLE QByteArray nodeList() const;
    Q_INVOKABLE QByteArray nodeListSelected() const;
    Q_INVOKABLE QByteArray dataSelectedNodes() const;
    Q_INVOKABLE QByteArray getDiagData() const;

    Q_INVOKABLE int trackedNodesCount() const;
    Q_INVOKABLE int allNodesCount() const;

    Q_INVOKABLE void addNodeToList(QString mac);
    Q_INVOKABLE void removeNodeFromList(QString mac);

    Q_INVOKABLE void searchSelectedNodes(QString filtr);
    Q_INVOKABLE void searchAllNodes(QString filtr);

    friend class DapModulesController;

public:
    explicit DapModuleDiagnostics(DapModulesController *parent = nullptr);
    ~DapModuleDiagnostics();


private:
    QThread *s_thread;

    QString m_node_version{""};
    QSettings m_settings;

    bool m_flag_stop_send_data{false};

    AbstractDiagnostic* m_diagnostic;

    bool s_flagSendData{false};
    bool s_socketConnectStatus{false};

private slots:
    void slot_diagnostic_data(QJsonDocument);
    void slot_update_node_list();

    void slot_connect_status_changed(bool status);

private:
    void try_update_data(const QJsonDocument list, const QJsonDocument data);
    void updateNode(const QJsonArray& array);

    QJsonDocument s_node_list, s_node_list_selected, s_data_selected_nodes;

    QTimer  *s_node_list_timer;


signals:
    void signalDiagnosticData(QByteArray);

    void flagSendDataChanged();

    void nodeListChanged();
    void nodeListSelectedChanged();
    void dataSelectedNodesChanged();
    void nodesCountChanged();
    void socketConnectStatusChanged();

    void filtrSelectedNodesDone(QByteArray);
    void filtrAllNodesDone(QByteArray);
};

#endif // DAPMODULEDIAGNOSTICS_H

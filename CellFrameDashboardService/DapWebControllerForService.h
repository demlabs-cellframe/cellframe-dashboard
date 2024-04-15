#pragma once

#include "DapWebControll.h"
#ifdef Q_OS_ANDROID
#include "DapRpcTCPServer.h"
typedef class DapRpcTCPServer DapUiService;
#else
#include "DapRpcLocalServer.h"
typedef class DapRpcLocalServer DapUiService;
#endif

class DapWebControllerForService : public DapWebControll
{
    Q_OBJECT

public:
    explicit DapWebControllerForService(QObject *parent = nullptr);
    void setCommandList(QList<DapRpcService *> *commanList);
    void initConnectToServise(const QList<DapRpcService*>* services);

protected slots:
    void clientRequest(QString req, int clientIndex) override;

private slots:
    void respondFromServise(const QVariant& result);

private:
    void sendSignalToService(const QString &commandName, const QVariant& args);
private:
    QList<DapRpcService*>* m_servicePool = nullptr;

    QMap<QString, QString> m_serviceSignals = {{"GetNetworks", "DapGetListNetworksCommand"}
                                               , {"GetWallets", "DapGetListWalletsCommand"}
                                               , {"GetVersions", "DapVersionController"}
                                               , {"GetDataWallet", "DapGetWalletInfoCommand"}
                                               , {"GetTransactions", "DapTransactionListCommand"}
                                               , {"GetMempoolList", "DapMempoolListCommand"}
                                               , {"CondTxCreate", "DapTXCondCreateCommand"}};
    QSet<QString> m_listCommand = {"DapGetListNetworksCommand"
                                    , "DapGetListWalletsCommand"
                                    , "DapVersionController"
                                    , "DapGetWalletInfoCommand"
                                    , "DapTransactionListCommand"
                                    , "DapMempoolListCommand"
                                    , "DapTXCondCreateCommand"};

    const QString RESULT_KEY = "result";
    const QString WEB3_KEY = "web3";
    const QString ERROR_KEY = "error";
};

#ifndef DAPWEBCONTROLL_H
#define DAPWEBCONTROLL_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include <QProcess>
#include <QRegularExpression>
#include <QJsonArray>
#include <QDateTime>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <QRegularExpressionMatchIterator>
#include <QTcpServer>
#include <QTcpSocket>
#include <QTextStream>
#include <QString>
#include <QRandomGenerator>
#include <dap_hash.h>
#include <QFile>
#include <QTextCodec>
#include <QUrl>
//#include <QtNetwork>

class DapWebControll : public QObject
{
    Q_OBJECT
public:
    explicit DapWebControll(QObject *parent = nullptr);
    bool startServer(int port);

private slots:
  void onNewConnetion();
  void onClientSocketReadyRead();


private:
    QJsonDocument getWallets();
    QJsonDocument getNetworks();
    QJsonDocument getDataWallets(QString walletName);
    QJsonDocument sendTransaction(QString walletName, QString to, QString value, QString tokenName, QString net);
    QJsonDocument getTransactions(QString addr, QString net);
    QJsonDocument sendJsonTransaction(QJsonDocument jsonCommand);
    QJsonDocument getLedgetTxHash(QString hash, QString net);
    QJsonDocument getLedgetTxListAll(QString net);
    QJsonDocument getMempoolList(QString net, QString addr, QString chain);

    QJsonDocument getMempoolTxHash(QString net, QString hash);
    QJsonDocument createCondTx(QString net, QString tokenName, QString walletName, QString cert, QString value, QString unit, QString srv_uid);
    QJsonDocument getNodeStatus();
    QJsonDocument getVersions();

    QJsonDocument getCertificates(QString categoryCert);
    QJsonDocument createCertificate(QString type, QString name, QString categoryCert);

    QJsonDocument stakeLockTake(QString walletName, QString net, QString hash);
    QJsonDocument stakeLockHold(QString tokenName, QString walletName,  QString time_staking,  QString net, QString coins, QString reinvest, QString baseFlag);

    QJsonDocument getOrdersList(QString net, QString direction, QString srv_uid, QString unit, QString tokenName, QString price_min, QString price_max);
    QJsonDocument createOrder(QString net, QString direction, QString srv_uid, QString value, QString unit, QString tokenName,
                              QString addr, QString hashTx,QString expires, QString certName,
                              QString ext, QString region, QString continent);


    QJsonDocument processingResult(QString status, QString errorMsg, QJsonObject data);
    QJsonDocument processingResult(QString status, QString errorMsg, QJsonArray data);
    QJsonDocument processingResult(QString status, QString errorMsg, QString data);
    QJsonDocument processingResult(QString status, QString errorMsg);

    QString send_cmd(QString cmd);

    QString getRandomString();
    QString getNewId();

    void sendResponce(QJsonDocument data, QTcpSocket* socket);

private:
    QString s_pathJsonCmd;
    bool s_connectFrontendStatus;
    QString s_nodeStatus;

//    QMap <int,QString> s_id;
    QStringList s_id;

    QTcpServer * _tcpServer;

    QMap <int,QTcpSocket*> s_tcpSocketList;

    const QString BACKUP = "Backup";
    const QString REGULAR_WALLET_ACTIVE = R"(^Wallet: (\S+)( \((\S+)\))?)";

signals:
    void signalConnectRequest(QString site, int index);

public slots:
    void rcvAccept(QString accept, int index);

    void rcvFrontendConnectStatus(bool status) {s_connectFrontendStatus = status; if(!status) s_id.clear();};
    void rcvNodeStatus(QVariant);

};

#endif // DAPWEBCONTROLL_H

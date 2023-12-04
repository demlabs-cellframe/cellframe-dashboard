#ifndef SERVICEIMITATOR_H
#define SERVICEIMITATOR_H

#include <QVariant>
#include <QObject>

class ServiceImitator : public QObject
{
    Q_OBJECT
public:
    explicit ServiceImitator(QObject *parent = nullptr);

    void requestToService(const QString& asServiceName, const QVariant &args = QVariant());
signals:
    void versionControllerResult(const QVariant& versionResult);

    void walletsReceived(const QVariant& walletList);

    void rcvXchangeTokenPair(const QVariant& rcvData);

    void signalXchangeTokenPairReceived(const QVariant& rcvData);

    void rcvXchangeTokenPriceAverage(const QVariant& rcvData);

    void rcvXchangeTokenPriceHistory(const QVariant& rcvData);

    void signalXchangeOrderListReceived(const QVariant& rcvData);

    void rcvXchangeCreate(const QVariant& rcvData);

    void rcvXchangeTxList(const QVariant& rcvData);

private:
    void DapVersionController(const QStringList &arg);

    void DapGetWalletsInfoCommand();

    void DapGetXchangeTokenPair(const QStringList &args);

    void DapGetXchangeTokenPriceAverage(const QStringList &args);

    void DapGetXchangeTokenPriceHistory(const QStringList& args);

    void DapGetXchangeOrdersList();

    void DapXchangeOrderCreate(const QStringList &args);

    void DapGetXchangeTxList(const QStringList &args);

};

#endif // SERVICEIMITATOR_H

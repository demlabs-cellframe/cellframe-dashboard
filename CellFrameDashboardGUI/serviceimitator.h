#ifndef SERVICEIMITATOR_H
#define SERVICEIMITATOR_H

#include <QObject>

class ServiceImitator : public QObject
{
    Q_OBJECT
public:
    explicit ServiceImitator(QObject *parent = nullptr);

    void requestToService(const QString& asServiceName, const QVariant &arg1,
                             const QVariant &arg2, const QVariant &arg3,
                             const QVariant &arg4, const QVariant &arg5,
                             const QVariant &arg6, const QVariant &arg7,
                             const QVariant &arg8, const QVariant &arg9,
                             const QVariant &arg10);
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
    void DapVersionController(const QString& arg1);

    void DapGetWalletsInfoCommand();

    void DapGetXchangeTokenPair(const QString &arg1, const QString &arg2);

    void DapGetXchangeTokenPriceAverage(
            const QString &arg1, const QString &arg2, const QString &arg3,
            const QString &arg4, const QString &arg5);

    void DapGetXchangeTokenPriceHistory(
            const QString &arg1, const QString &arg2, const QString &arg3,
            const QString &arg4, const QString &arg5);

    void DapGetXchangeOrdersList();

    void DapXchangeOrderCreate(
            const QString &arg1, const QString &arg2, const QString &arg3,
            const QString &arg4, const QString &arg5, const QString &arg6);

    void DapGetXchangeTxList(
            const QString &arg1, const QString &arg2, const QString &arg3,
            const QString &arg4, const QString &arg5);

};

#endif // SERVICEIMITATOR_H

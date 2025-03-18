#include "testcontroller.h"

#include <QDebug>

void TestController::requestToService(const QString &asServiceName, const QVariant &arg1, const QVariant &arg2, const QVariant &arg3, const QVariant &arg4, const QVariant &arg5, const QVariant &arg6, const QVariant &arg7, const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
{
    qDebug() << "TestController::requestToService";

    QList<QObject*> walletHistory;

    emit walletHistoryReceived(walletHistory);
}

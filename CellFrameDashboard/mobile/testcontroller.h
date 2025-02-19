#ifndef TESTCONTROLLER_H
#define TESTCONTROLLER_H

#include <QObject>
#include <QVariant>

class TestController : public QObject
{
    Q_OBJECT
public:
    explicit TestController(QObject *parent = 0) : QObject(parent) {
    }

public:
    Q_INVOKABLE void requestToService(const QString& asServiceName, const QVariant &arg1 = QVariant(),
                         const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                         const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                         const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                         const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                         const QVariant &arg10 = QVariant());
signals:
    void walletHistoryReceived(const QList<QObject*>& walletHistory);

};

#endif // TESTCONTROLLER_H

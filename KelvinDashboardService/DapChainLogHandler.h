#ifndef DAPCHAINLOGHANDLER_H
#define DAPCHAINLOGHANDLER_H

#include <QObject>
#include <QString>
#include <QProcess>
#include <algorithm>
#include <QDebug>

#include "DapLogMessage.h"

class DapChainLogHandler : public QObject
{
    Q_OBJECT

protected:
    virtual QStringList parse(const QByteArray& aLogMessages);

public:
    explicit DapChainLogHandler(QObject *parent = nullptr);

public slots:
    QStringList request(int aiTimeStamp, int aiRowCount);
};

#endif // DAPCHAINLOGHANDLER_H

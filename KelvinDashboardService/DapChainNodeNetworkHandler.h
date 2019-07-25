#ifndef DAPCHAINNODENETWORKHANDLER_H
#define DAPCHAINNODENETWORKHANDLER_H

#include <QObject>
#include <QProcess>
#include <QRegExp>
#include <QDebug>
//#include "DapNetworkType.h"

class DapChainNodeNetworkHandler : public QObject
{
    Q_OBJECT

public:
    explicit DapChainNodeNetworkHandler(QObject *parent = nullptr);

public slots:
    QVariant getNodeNetwork() const;
};

#endif // DAPCHAINNODENETWORKHANDLER_H

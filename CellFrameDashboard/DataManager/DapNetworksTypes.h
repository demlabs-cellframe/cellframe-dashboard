#pragma once

#include "qobject.h"
#include <QString>

struct NetworkLoadProgress{
    QString name{""};
    QString state{""};
    QString percent{""};
};

struct NetworkInfo
{
    QString networkName = "";
    QString networkState = "";
    QString targetState = "";
    QString address = "";
    QString activeLinksCount = "";
    QString linksCount = "";
    QString syncPercent = "";
    QString errorMessage = "";
    QString displayNetworkState = "";
    QString displayTargetState = "";
};
Q_DECLARE_METATYPE(NetworkInfo)

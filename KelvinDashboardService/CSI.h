#ifndef CSI_H
#define CSI_H


#include <QCommandLineParser>
#include <QSettings>
#include <QDebug>

#include "Config.h"

void csi(const QCoreApplication &, sConfig*);
void readConfig(sConfig*);
void showConfig(sConfig*);

#endif // CSI_H

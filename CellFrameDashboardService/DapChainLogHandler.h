#ifndef DAPCHAINLOGHANDLER_H
#define DAPCHAINLOGHANDLER_H

#include <QObject>
#include <QString>
#include <QProcess>
#include <algorithm>
#include <QFile>
#include <QFileSystemWatcher>
#include <QDebug>

#include "DapLogMessage.h"

class DapChainLogHandler : public QObject
{
    Q_OBJECT

    ///  Log file change watcher.
    QFileSystemWatcher  m_fileSystemWatcher;

public:
    explicit DapChainLogHandler(QObject *parent = nullptr);

signals:
    void onUpdateModel();
    void onChangedLog();

public slots:
    QStringList request();
};

#endif // DAPCHAINLOGHANDLER_H

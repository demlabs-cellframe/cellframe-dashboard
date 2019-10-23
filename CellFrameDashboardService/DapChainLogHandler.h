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

/// Class read logs from system file when it's changed
class DapChainLogHandler : public QObject
{
    Q_OBJECT

    ///  Log file change watcher.
    QFileSystemWatcher  m_fileSystemWatcher;
    ///  Current caret position in log file
    qint64 m_currentCaretPosition{0};
public:
    /// Standard constructor
    /// Add path to system logs file
    explicit DapChainLogHandler(QObject *parent = nullptr);

signals:
    /// The signal is emitted when system logs file was changed
    void onChangedLog();

public slots:
    /// Request new logs from system logs file
    /// @return list of new logs
    QStringList request();
};

#endif // DAPCHAINLOGHANDLER_H

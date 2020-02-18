#ifndef DAPUPDATELOGSCOMMAND_H
#define DAPUPDATELOGSCOMMAND_H

#include <QFile>
#include <QFileInfo>
#include <QFileSystemWatcher>

#include "DapAbstractCommand.h"

#define DEFAULT_BUFFER_SIZE 20

class DapUpdateLogsCommand : public DapAbstractCommand
{
    ///The cursor position from which to start reading the file.
    qint64 m_seekFile {0};
    ///The number of rows that are stored in memory.
    int m_bufferSize {DEFAULT_BUFFER_SIZE};
    ///The container with the lines from the log.
    QStringList m_bufLog;

    const QString m_csLogFile;
    ///Monitors changes in the log file.
    QFileSystemWatcher *m_watcherLogFile {nullptr};

    bool m_isNoifyClient {false};

public:
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param parent Parent.
    explicit DapUpdateLogsCommand(const QString &asServicename, QObject *parent, const QString &asLogFile = QString());

protected slots:
    ///The slot reads logs to the buffer.
    void readLogFile();

public slots:
    /// Process the notification from the client on the service side.
    /// @details Performed on the service side.
    /// @param arg1...arg10 Parameters.
    virtual void notifedFromClient(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant()) override;
    /// Process the notification from the service on the client side.
    /// @details Performed on the client side.
    /// @param arg1...arg10 Parameters.
    Q_INVOKABLE virtual void notifedFromService(const QVariant &arg1 = QVariant(),
                                     const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                     const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                     const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                     const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                     const QVariant &arg10 = QVariant()) override;
};

#endif // DAPUPDATELOGSCOMMAND_H

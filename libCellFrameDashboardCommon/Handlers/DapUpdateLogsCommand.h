#ifndef DAPUPDATELOGSCOMMAND_H
#define DAPUPDATELOGSCOMMAND_H

#include <QFile>
#include <QFileSystemWatcher>

#include "DapAbstractCommand.h"


#define LOG_FILE "/opt/cellframe-node/var/log/cellframe-node.log"
#define DEFAULT_BUFFER_SIZE 200

class DapUpdateLogsCommand : public DapAbstractCommand
{
    ///The cursor position from which to start reading the file.
    qint64 m_seekFile {0};
    ///The number of rows that are stored in memory.
    int m_bufferSize {0};
    ///The container with the lines from the log.
    QStringList m_bufLog;
    ///Monitors changes in the log file.
    QFileSystemWatcher *m_watcherDapLogFile {nullptr};

public:
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param apSocket Client connection socket with service.
    /// @param parent Parent.
    explicit DapUpdateLogsCommand(const QString &asServicename, DapRpcSocket *apSocket = nullptr, QObject *parent = nullptr);

protected slots:
    ///The slot reads logs to the buffer.
    void dapGetLog();
public slots:
    /// Send a response to the service.
    /// @param arg1...arg10 Parameters.
    /// @return Reply to service.
    QVariant respondToService(const QVariant &arg1 = QVariant(), const QVariant &arg2 = QVariant(),
                              const QVariant &arg3 = QVariant(), const QVariant &arg4 = QVariant(),
                              const QVariant &arg5 = QVariant(), const QVariant &arg6 = QVariant(),
                              const QVariant &arg7 = QVariant(), const QVariant &arg8 = QVariant(),
                              const QVariant &arg9 = QVariant(), const QVariant &arg10 = QVariant())override;
    /// Send a response to the client.
    /// @param arg1...arg10 Parameters.
    /// @return Reply to client.
    QVariant respondToClient(const QVariant &arg1 = QVariant(), const QVariant &arg2 = QVariant(),
                             const QVariant &arg3 = QVariant(), const QVariant &arg4 = QVariant(),
                             const QVariant &arg5 = QVariant(), const QVariant &arg6 = QVariant(),
                             const QVariant &arg7 = QVariant(), const QVariant &arg8 = QVariant(),
                             const QVariant &arg9 = QVariant(), const QVariant &arg10 = QVariant()) override;
    /// Reply from service.
    /// @return Service reply.
    virtual void replyFromService()override;
};

#endif // DAPUPDATELOGSCOMMAND_H

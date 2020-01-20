#include "DapUpdateLogsCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param apSocket Client connection socket with service.
/// @param parent Parent.
DapUpdateLogsCommand::DapUpdateLogsCommand(const QString &asServiceName, DapRpcSocket *apSocket, QObject *parent)
    : DapAbstractCommand(asServiceName, apSocket, parent),m_seekFile(0),m_bufferSize(DEFAULT_BUFFER_SIZE),m_bufLog(),m_watcherDapLogFile(nullptr)
{
    if(apSocket == nullptr)
    {
        m_watcherDapLogFile = new QFileSystemWatcher(parent);


        if (! m_watcherDapLogFile->addPath(LOG_FILE))
        {
            qCritical("File not found");
        }

        connect(m_watcherDapLogFile, &QFileSystemWatcher::fileChanged, this,&DapUpdateLogsCommand::dapGetLog);
    }
}
/// Send a response to the service.
/// @param arg1...arg10 Parameters.
/// @return Reply to service.
QVariant DapUpdateLogsCommand::respondToService(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                                const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                                const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                                const QVariant &arg10)
{
    Q_UNUSED(arg1)
    Q_UNUSED(arg2)
    Q_UNUSED(arg3)
    Q_UNUSED(arg4)
    Q_UNUSED(arg5)
    Q_UNUSED(arg6)
    Q_UNUSED(arg7)
    Q_UNUSED(arg8)
    Q_UNUSED(arg9)
    Q_UNUSED(arg10)

    return QVariant();
}

/// The log file is being read.
/// @param arg1...arg10 Parameters.
/// @return Reply to client.
QVariant DapUpdateLogsCommand::respondToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                               const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                               const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                               const QVariant &arg10)
{
    Q_UNUSED(arg2)
    Q_UNUSED(arg3)
    Q_UNUSED(arg4)
    Q_UNUSED(arg5)
    Q_UNUSED(arg6)
    Q_UNUSED(arg7)
    Q_UNUSED(arg8)
    Q_UNUSED(arg9)
    Q_UNUSED(arg10)

    if(m_bufferSize != arg1.toInt()||m_bufLog.isEmpty())
    {
        m_bufferSize = arg1.toInt();
        m_seekFile = 0;
        dapGetLog();
    }
    return m_bufLog;
}

///The slot reads logs to the buffer.
void DapUpdateLogsCommand::dapGetLog()
{
    QFile dapLogFile(LOG_FILE);
    if (!dapLogFile.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qCritical("The node log file does not open.");
        return;
    }

    QTextStream readFile(&dapLogFile);
    QString line;

    readFile.seek(m_seekFile);

    while(!readFile.atEnd())
    {
        m_bufLog.append(readFile.readLine());

        if(m_bufLog.size() > m_bufferSize)
        {
             m_bufLog.removeFirst();
        }
    }
    m_seekFile = readFile.pos();

    dapLogFile.close();
}

/// Reply from service.
/// @return Service reply.
void DapUpdateLogsCommand::replyFromService()
{
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    emit serviceResponded(reply->response().toJsonValue());
}

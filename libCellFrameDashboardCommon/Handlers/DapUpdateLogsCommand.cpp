#include "DapUpdateLogsCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
DapUpdateLogsCommand::DapUpdateLogsCommand(const QString &asServiceName, QObject *parent, const QString &asLogFile)
    : DapAbstractCommand(asServiceName, parent), m_cslogFile(asLogFile)
{
    DapRpcLocalServer * server = dynamic_cast<DapRpcLocalServer *>(m_parent);

    if(server)
    {
        m_watcherDapLogFile = new QFileSystemWatcher(parent);


        if (! m_watcherDapLogFile->addPath(m_cslogFile))
        {
            qCritical() << ("File not found");
        }

        connect(m_watcherDapLogFile, &QFileSystemWatcher::fileChanged, this, [&]
        {
            notifyToClient();
        });
    }
}

/// Send a notification to the client. At the same time, you should not expect a response from the client.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
void DapUpdateLogsCommand::notifyToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                        const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                        const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                        const QVariant &arg10)
{
    if(m_bufferSize != arg1.toInt()||m_bufLog.isEmpty())
    {
        m_bufferSize = arg1.toInt();
        m_seekFile = 0;
        dapGetLog();
    }

    DapAbstractCommand::notifyToClient(m_bufLog, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
}

/// Process the notification from the service on the client side.
/// @details Performed on the client side.
/// @param arg1...arg10 Parameters.
void DapUpdateLogsCommand::notifedFromService(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                            const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                            const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                            const QVariant &arg10)
{
    Q_UNUSED(arg1);
    Q_UNUSED(arg2);
    Q_UNUSED(arg3);
    Q_UNUSED(arg4);
    Q_UNUSED(arg5);
    Q_UNUSED(arg6);
    Q_UNUSED(arg7);
    Q_UNUSED(arg8);
    Q_UNUSED(arg9);
    Q_UNUSED(arg10);

    emit clientNotifed(arg1);
}

/// Send a response to the client.
/// @details Performed on the service side.
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
    QFile dapLogFile(m_cslogFile);
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
/// @details Performed on the service side.
/// @return Service reply.
QVariant DapUpdateLogsCommand::replyFromService()
{
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());

    emit serviceResponded(reply->response().toJsonValue());

    return reply->response().toJsonValue();
}

#include "DapUpdateLogsCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
DapUpdateLogsCommand::DapUpdateLogsCommand(const QString &asServiceName, QObject *parent, const QString &asLogFile)
    : DapAbstractCommand(asServiceName, parent), m_csLogFile(asLogFile)
{
    qInfo() << "Initialization of DapUpdateLogsCommand...";
    DapRpcLocalServer * server = dynamic_cast<DapRpcLocalServer *>(m_parent);

    // Watcher is created only on the service side
    if(server)
    {
        // Initialize the watcher for the log file of the node
        m_watcherLogFile = new QFileSystemWatcher(this);
        QFileInfo fileInfo(m_csLogFile);
        m_watcherLogFile->addPath(m_csLogFile);
        m_watcherLogFile->addPath(fileInfo.absolutePath());

        if (!(m_watcherLogFile->addPath(m_csLogFile) || fileInfo.exists()))
        {
            qWarning() << "Node log file not found";
        }

        connect(m_watcherLogFile, &QFileSystemWatcher::fileChanged, this, [&]
        {
            if(m_isNoifyClient)
            {
                readLogFile();
                notifyToClient(m_bufLog);
            }
            if(!m_watcherLogFile->files().contains(m_csLogFile))
            {
                m_watcherLogFile->addPath(m_csLogFile);
            }
        });
        // Signal-slot connection restoring control over the log file of the node
        // if it is deleted during the operation of the service
        connect(m_watcherLogFile, &QFileSystemWatcher::directoryChanged, this, [=]
        {
            qDebug() << "Log file directory changed";
            if(!m_watcherLogFile->files().contains(m_csLogFile))
            {
                m_watcherLogFile->addPath(m_csLogFile);
            }
        });
    }
}

/// Process the notification from the client on the service side.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
void DapUpdateLogsCommand::notifedFromClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
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



    if(arg1.toString() == "start")
    {
        m_isNoifyClient = true;
        m_bufferSize = arg2.toInt();
        readLogFile();
        notifyToClient(m_bufLog);
    }
    else if(arg1.toString() == "stop")
    {
        m_isNoifyClient = false;
    }
}

///The slot reads logs to the buffer.
void DapUpdateLogsCommand::readLogFile()
{
    QFile dapLogFile(m_csLogFile);
    if (!dapLogFile.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qWarning() << "The node log file does not open";
        return;
    }
    QTextStream readFile(&dapLogFile);
    m_bufLog.clear();
    while(!readFile.atEnd())
    {
        m_bufLog.append(readFile.readLine());

        if(m_bufLog.size() > m_bufferSize)
        {
             m_bufLog.removeFirst();
        }
    }

    if(readFile.status()!= QTextStream::Ok)
    {
        qWarning() << "Error reading log file";
    }
    dapLogFile.close();
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

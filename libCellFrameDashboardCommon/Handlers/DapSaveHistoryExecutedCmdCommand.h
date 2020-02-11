#ifndef DAPSAVEHISTORYEXECUTEDCMDCOMMAND_H
#define DAPSAVEHISTORYEXECUTEDCMDCOMMAND_H

#include <QFile>
#include <QDir>

#include "DapAbstractCommand.h"

class DapSaveHistoryExecutedCmdCommand : public DapAbstractCommand
{
    /// Command history file.
    QFile * m_File{nullptr};

public:
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param parent Parent.
    /// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
    /// @param asCliPath The path to history file.
    DapSaveHistoryExecutedCmdCommand(const QString &asServicename, QObject *parent = nullptr, const QString &asCliPath = QString());

public slots:
    /// Process the notification from the client on the service side.
    /// @details Performed on the service side.
    /// @param arg1 Command.
    /// @param arg2...arg10 Parameters.
    void notifedFromClient(const QVariant &arg1 = QVariant(), const QVariant &arg2 = QVariant(),
                             const QVariant &arg3 = QVariant(), const QVariant &arg4 = QVariant(),
                             const QVariant &arg5 = QVariant(), const QVariant &arg6 = QVariant(),
                             const QVariant &arg7 = QVariant(), const QVariant &arg8 = QVariant(),
                             const QVariant &arg9 = QVariant(), const QVariant &arg10 = QVariant()) override;
};

#endif // DAPSAVEHISTORYEXECUTEDCMDCOMMAND_H

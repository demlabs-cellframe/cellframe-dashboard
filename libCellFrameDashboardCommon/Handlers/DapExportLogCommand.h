#ifndef DAPSAVELOGCOMMAND_H
#define DAPSAVELOGCOMMAND_H

#include <QFile>

#include "DapAbstractCommand.h"

class DapExportLogCommand : public DapAbstractCommand
{

public:
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param apSocket Client connection socket with service.
    /// @param parent Parent.
    explicit DapExportLogCommand(const QString &asServicename, QObject *parent = nullptr);

public slots:
    /// Send a response to the client.
    /// /// A log file is saved from the GUI window.
    /// @param arg1...arg10 Parameters.
    /// @return Reply to client.
    QVariant respondToClient(const QVariant &arg1 = QVariant(), const QVariant &arg2 = QVariant(),
                             const QVariant &arg3 = QVariant(), const QVariant &arg4 = QVariant(),
                             const QVariant &arg5 = QVariant(), const QVariant &arg6 = QVariant(),
                             const QVariant &arg7 = QVariant(), const QVariant &arg8 = QVariant(),
                             const QVariant &arg9 = QVariant(), const QVariant &arg10 = QVariant()) override;
};

#endif // DAPSAVELOGCOMMAND_H

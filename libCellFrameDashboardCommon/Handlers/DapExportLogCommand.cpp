#include "DapExportLogCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param apSocket Client connection socket with service.
/// @param parent Parent.
DapExportLogCommand::DapExportLogCommand(const QString &asServicename, QObject *parent)
    : DapAbstractCommand(asServicename, parent)
{

}

/// Send a response to the client.
/// A log file is saved from the GUI window.
/// @param arg1...arg10 Parameters.
/// @return Reply to client.
QVariant DapExportLogCommand::respondToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                              const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                              const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                              const QVariant &arg10)
{
    Q_UNUSED(arg3)
    Q_UNUSED(arg4)
    Q_UNUSED(arg5)
    Q_UNUSED(arg6)
    Q_UNUSED(arg7)
    Q_UNUSED(arg8)
    Q_UNUSED(arg9)
    Q_UNUSED(arg10)

    QFile saveDapLog(arg1.toString());
    if (!saveDapLog.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        qCritical("The file does not write.");
        return false;
       }
    QTextStream saveLog(&saveDapLog);
    saveLog << arg2.toString();

    saveDapLog.close();
    return QVariant();
}

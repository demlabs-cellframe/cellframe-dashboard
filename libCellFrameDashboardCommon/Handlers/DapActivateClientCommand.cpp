#include "DapActivateClientCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
/// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
DapActivateClientCommand::DapActivateClientCommand(const QString &asServicename, QObject *parent)
    : DapAbstractCommand(asServicename, parent)
{

}



/****************************************************************************
**
** This file is part of the libCellFrameDashboardClient library.
**
** The class implements the command to activate the GUI client. That is,
** by clicking on the icon in the system tray, the main window of the GUI
** client is minimized / expanded.
**
****************************************************************************/

#ifndef DAPACTIVATECLIENTCOMMAND_H
#define DAPACTIVATECLIENTCOMMAND_H

#include <QObject>

#include "DapAbstractCommand.h"

class DapActivateClientCommand : public DapAbstractCommand
{
public:
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param parent Parent.
    /// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
    DapActivateClientCommand(const QString &asServicename, QObject *parent = nullptr);
};

#endif // DAPACTIVATECLIENTCOMMAND_H

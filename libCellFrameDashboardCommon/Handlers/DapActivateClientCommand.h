#ifndef DAPACTIVATECLIENTCOMMAND_H
#define DAPACTIVATECLIENTCOMMAND_H

#include <QObject>
#include <QSystemTrayIcon>

#include "DapAbstractCommand.h"

class DapActivateClientCommand : public DapAbstractCommand
{
public:
    /// Overloaded constructor.
    /// @param asServiceName Service name.
    /// @param parent Parent.
    DapActivateClientCommand(const QString &asServicename, QObject *parent = nullptr);

public slots:

};

#endif // DAPACTIVATECLIENTCOMMAND_H

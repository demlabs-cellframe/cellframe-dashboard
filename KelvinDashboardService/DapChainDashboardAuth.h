/****************************************************************************
**
** This file is part of the KelvinDashboardService application.
** 
** The class implements the authorization object. Stores the user password, 
** provides a user authorization mechanism in the service.
**
****************************************************************************/

#ifndef DAPCHAINDASHBOARDAUTH_H
#define DAPCHAINDASHBOARDAUTH_H

#include <QObject>

#include "DapCommand.h"

class DapChainDashboardAuth : public QObject
{
    Q_OBJECT
    
protected:
    /// User password.
    QString     m_password = "123";
    
public:
    /// Standart constructor.
    explicit DapChainDashboardAuth(QObject *parent = nullptr);
    
    ///********************************************
    ///                 Interface
    /// *******************************************
    /// Get user password.
    /// @return User password.
    QString getPassword() const;
    /// Set user password.
    /// @param password User password.
    void setPassword(const QString &password);
    /// Execute the command.
    /// @param command Executable command.
    void runCommand(const DapCommand& command);
    
signals:
    /// The signal is emitted when the command is successful.
    /// @param command The executed command.
    void onCommandCompleted(const DapCommand& command);
};

#endif // DAPCHAINDASHBOARDAUTH_H

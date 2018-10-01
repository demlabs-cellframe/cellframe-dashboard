#include "DapChainDashboardAuth.h"

/// Standart constructor.
DapChainDashboardAuth::DapChainDashboardAuth(QObject *parent) : QObject(parent)
{
    
}

/// Get user password.
/// @return User password.
QString DapChainDashboardAuth::getPassword() const
{
    return m_password;
}

/// Set user password.
/// @param password User password.
void DapChainDashboardAuth::setPassword(const QString &password)
{
    m_password = password;
}

/// Execute the command.
/// @param command Executable command.
void DapChainDashboardAuth::runCommand(const DapCommand &command)
{
    qDebug() << "Run command authorization";
    DapCommand *answerCommand = new DapCommand(TypeDapCommand::Authorization);
    answerCommand->setCountArguments(1);
    if(getPassword() == command.getArgument(0).toString())
        answerCommand->addArgument(true);
    else
        answerCommand->addArgument(false);
    emit onCommandCompleted(*answerCommand);
}




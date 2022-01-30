#ifndef COMMANDSCMDCONTROLLER_H
#define COMMANDSCMDCONTROLLER_H

#include <QObject>

#include <dap_chain_node_commands.h>

class CommandsCmdController : public QObject
{
    Q_OBJECT
    QStringList allCommands;
    QStringList shortCommands;
    QStringList commands;
    QStringList commandsWithParams;

    void getCommands();
    void getShortCommands();
    void getCommandsWithParams();
    void getAllCommands();
public:
    explicit CommandsCmdController(QObject *parent = nullptr);

    QString commandsIncludedValue(const QString &value);

signals:

};

#endif // COMMANDSCMDCONTROLLER_H

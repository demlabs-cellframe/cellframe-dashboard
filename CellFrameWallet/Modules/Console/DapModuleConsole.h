#ifndef DAPMODULECONSOLE_H
#define DAPMODULECONSOLE_H

#include <QObject>
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "QSettings"

class DapModuleConsole : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleConsole(DapModulesController *parent);

    Q_INVOKABLE void runCommand(const QString &command);
    Q_INVOKABLE void clearModel();

    enum ConsoleMode{
        CLI_MODE = 0,
        TOOL_MODE = 1
    };

    ConsoleMode m_currentMode{ConsoleMode::CLI_MODE};

    Q_PROPERTY(int Mode READ Mode WRITE setMode NOTIFY ModeChanged)
    int Mode();
    void setMode(int mode);

    Q_PROPERTY(QString currentInputCommand      READ getCurrentInputCommand     WRITE setCurrentInputCommand);
    QString getCurrentInputCommand() { return m_currentInputCommand; };
    void setCurrentInputCommand(QString& command) { m_currentInputCommand = command; };

private slots:
    void getAnswer(const QVariant &answer);

private:
    QString m_currentInputCommand;
    QVariantList model;

signals:
    void ModeChanged();
};

#endif // DAPMODULECONSOLE_H

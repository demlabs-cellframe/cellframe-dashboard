#include "DapModuleConsole.h"

#include <QDebug>
#include "consoleitem.h"
#include "qqmlcontext.h"

DapModuleConsole::DapModuleConsole(DapModulesController *parent)
    : DapAbstractModule(parent)
{
    m_currentMode = (ConsoleMode)QSettings().value("ConsoleMode", 0).toInt();
    connect(s_serviceCtrl, &DapServiceController::cmdRunned, this, &DapModuleConsole::getAnswer);

    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("modelConsoleCommand", model);
}

void DapModuleConsole::runCommand(const QString &command)
{
    QVariantList args;
    args.append(command);
    args.append("isConsole");
    args.append((int)m_currentMode);

    s_serviceCtrl->requestToService("DapRunCmdCommand", args);
}

void DapModuleConsole::getAnswer(const QVariant &answer)
{
    qDebug()<<"DapModuleConsole::getAnswer " << answer;
    QVariantList list = answer.toList();

    if (list.size() < 2)
        return;

    model << QVariant::fromValue(
                 ConsoleInfo(list.at(0).toString(), list.at(1).toString()));

    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("modelConsoleCommand", model);
}

void DapModuleConsole::clearModel()
{
    model.clear();
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("modelConsoleCommand", model);

}

int DapModuleConsole::Mode()
{
    return (int)m_currentMode;
}

void DapModuleConsole::setMode(int mode)
{
    m_currentMode = (ConsoleMode)mode;
    QSettings().setValue("ConsoleMode", mode);

    emit ModeChanged();
}

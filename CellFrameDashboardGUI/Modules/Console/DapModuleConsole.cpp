#include "DapModuleConsole.h"

#include <QDebug>
#include "consoleitem.h"
#include "qqmlcontext.h"

DapModuleConsole::DapModuleConsole(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
{
    connect(s_serviceCtrl, &DapServiceController::cmdRunned, this, &DapModuleConsole::getAnswer);

    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelConsoleCommand", model);
}

void DapModuleConsole::runCommand(const QString &command)
{
//    qDebug() << "DapModuleConsole::runCommand" << command;

    QVariantList args;
    args.append(command);
    args.append("isConsole");
    args.append("");

    s_serviceCtrl->requestToService("DapRunCmdCommand", args);

    s_serviceCtrl->notifyService("DapSaveHistoryExecutedCmdCommand", args);
}

void DapModuleConsole::getAnswer(const QVariant &answer)
{
    QVariantList list = answer.toList();

    if (list.size() < 2)
        return;

    model << QVariant::fromValue(
                 ConsoleInfo(list.at(0).toString(), list.at(1).toString()));

    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelConsoleCommand", model);
}

void DapModuleConsole::clearModel()
{
    model.clear();
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelConsoleCommand", model);

}

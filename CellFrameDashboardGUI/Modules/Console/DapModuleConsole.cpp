#include "DapModuleConsole.h"

#include <QDebug>
#include "consoleitem.h"

DapModuleConsole::DapModuleConsole(QQmlContext *context, QObject *parent)
    : DapAbstractModule(parent)
    , s_context(context)
{
    connect(s_serviceCtrl, &DapServiceController::cmdRunned, this, &DapModuleConsole::getAnswer);
}

void DapModuleConsole::runCommand(const QString &command)
{
    qDebug() << "DapModuleConsole::runCommand" << command;

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

    s_context->setContextProperty("modelConsoleCommand", model);
}

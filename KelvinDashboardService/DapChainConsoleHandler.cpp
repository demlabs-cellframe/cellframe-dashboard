#include "DapChainConsoleHandler.h"

DapChainConsoleHandler::DapChainConsoleHandler(QObject *parent) : QObject(parent)
{

}

QString DapChainConsoleHandler::getResult(const QString& aQuery) const
{
    QProcess process;
    process.start(QString(CLI_PATH) + " " + aQuery);
    process.waitForFinished(-1);

    return QString::fromStdString(process.readAll().toStdString());
}

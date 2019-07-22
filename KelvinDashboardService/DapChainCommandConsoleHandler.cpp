#include <DapChainCommandConsoleHandler.h>
#include <QProcess>
DapChainCommandConsoleHandler::DapChainCommandConsoleHandler(QObject *parent) : QObject(parent)
{

}

QString DapChainCommandConsoleHandler::executeCommand(const QString &command)
{
    try {
        QProcess process;
        process.start(QString("%1 %2").arg(CLI_PATH).arg(command));
        process.waitForFinished(-1);
        return QString::fromLatin1(process.readAll());
    }
    catch (QProcess::ProcessError error){
        return QString("Error kelvin-node-cli %1").arg(error);
    }
}



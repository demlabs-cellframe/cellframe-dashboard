#include "DapChainLogHandler.h"

DapChainLogHandler::DapChainLogHandler(QObject *parent) : QObject(parent)
{

}

QStringList DapChainLogHandler::parse(const QByteArray &aLogMessages)
{
    qDebug() << aLogMessages;
    QRegExp rx("(\\t|\\[)([\\w\\s]{1,1}[\\w\\s\\W]+)(\\n|\\r|\\])");
    rx.setMinimal(true);

    int pos{0};
    QStringList list;
    while((pos = rx.indexIn(aLogMessages, pos)) != -1)
    {
        list.append(rx.cap(2));
        pos += rx.matchedLength();
    }
    qDebug() << list;
    return list;
}

QStringList DapChainLogHandler::request(int aiTimeStamp, int aiRowCount)
{
    QByteArray result;
    QProcess process;
    process.start(QString("%1 print_log ts_after %2 limit %3").arg("/opt/kelvin-node/bin/kelvin-node-cli").arg(aiTimeStamp).arg(aiRowCount));
    process.waitForFinished(-1);
    result = process.readAll();

    if(result.isEmpty())
        qDebug() << "FALSE";
    else
    {
        qDebug() << "TRUE";
    }

    return parse(result);
}

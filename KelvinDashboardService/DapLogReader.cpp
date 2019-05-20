#include "DapLogReader.h"



DapLogReader::DapLogReader(QObject *parent) : QObject(parent)
{

}

QStringList DapLogReader::parse(const QByteArray &aLogMessages)
{
    QStringList list = QString::fromLatin1(aLogMessages).split(";");

    auto resultEnd = std::remove_if(list.begin(), list.end(),
    [] (const QString& aLogMessage)
    {
        return !aLogMessage.contains('[');
    });
    list.erase(resultEnd, list.end());
    return list;
}

QStringList DapLogReader::request(int aiTimeStamp, int aiRowCount)
{
    QByteArray result;
    QProcess process;
    process.start(QString("%1 print_log ts_after %2 limit %3").arg("/home/andrey/Demlabs/build-kelvin-node/kelvin-node-cli").arg(aiTimeStamp).arg(aiRowCount));
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

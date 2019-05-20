#include "DapLogReader.h"



DapLogReader::DapLogReader(QObject *parent) : QObject(parent)
{

}

QStringList DapLogReader::parse(const QByteArray &aLogMessages)
{
    auto list = QString::fromLatin1(aLogMessages).split(";");

    for(QString l : list)
    {
        if(l.contains("["))
            qDebug() << l;
    }

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

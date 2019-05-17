#include "DapLogReader.h"

DapLogReader::DapLogReader(QObject *parent) : QObject(parent)
{

}

QList<QString> DapLogReader::request(int aiTimeStamp, int aiRowCount)
{
    QList<QString> str;
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
        qDebug() << QString::fromLatin1(result);
    }
    return str;
}

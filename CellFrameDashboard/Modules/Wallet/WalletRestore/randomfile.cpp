#include "randomfile.h"

#include <QFile>
#include <QVector>
#include <QByteArray>
#include <QRandomGenerator>
#include <QDataStream>
#include <QDebug>

constexpr int data_size {256};

const QByteArray test_string("CellFrame-Dashboard wallet recovery file\n");

RandomFile::RandomFile()
{

}

QByteArray RandomFile::generateRandomData()
{
    QVector<quint32> vector;
    vector.resize(data_size);
    QRandomGenerator::global()->fillRange(vector.data(), vector.size());

    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    for (auto x : vector)
        stream << x;

//    qDebug() << "data_size" << data.size();
//    qDebug() << "toBase64" << data.toBase64();

    return data;
}

bool RandomFile::saveDataToFile(const QString &fileName, const QByteArray & data)
{
    QFile file(fileName);

    qint64 result = 0;

    if (file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        result = file.write(test_string);
        if (result < 0)
        {
            file.close();
            return false;
        }

        result = file.write(data.toBase64());
        if (result < 0)
        {
            file.close();
            return false;
        }

        file.close();

        if(!file.exists())
            return false;
    }
    else return false;

    return true;
}

QByteArray RandomFile::loadDataFromFile(const QString &fileName)
{
    QFile file(fileName);

    QByteArray newData;

    if (file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        QByteArray test = file.readLine();
        if (test != test_string)
        {
            file.close();
            return QByteArray();
        }

        QByteArray data = file.readLine();
        if (data.isEmpty())
        {
            file.close();
            return QByteArray();
        }

        newData = QByteArray::fromBase64(data);

        file.close();
    }

    return newData;
}


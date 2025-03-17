#ifndef RANDOMFILE_H
#define RANDOMFILE_H

#include <QByteArray>

class RandomFile
{
public:
    RandomFile();

    QByteArray generateRandomData();

    bool saveDataToFile(const QString & fileName, const QByteArray & data);

    QByteArray loadDataFromFile(const QString & fileName);
};

#endif // RANDOMFILE_H

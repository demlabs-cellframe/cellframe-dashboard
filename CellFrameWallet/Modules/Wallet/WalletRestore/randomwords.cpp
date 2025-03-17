#include "randomwords.h"

#include <QFile>
#include <QRandomGenerator>

RandomWords::RandomWords()
{
    QFile file("://Modules/Wallet/WalletRestore/english_words.txt");

    if (file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        words = QString::fromUtf8(file.readAll()).split("\n");

        file.close();
    }
}

QStringList RandomWords::getRandomWords(int number) const
{
    if (words.isEmpty())
        return QStringList();

    QStringList result;

    for (int i = 0; i < number; ++i)
    {
        long index = QRandomGenerator::global()->bounded(words.size());
        result.append(words[index]);
    }

    return result;
}

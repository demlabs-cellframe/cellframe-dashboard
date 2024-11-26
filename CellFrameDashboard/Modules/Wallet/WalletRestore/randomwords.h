#ifndef RANDOMWORDS_H
#define RANDOMWORDS_H

#include <QStringList>

class RandomWords
{
public:
    RandomWords();

    QStringList getRandomWords(int number) const;

private:
    QStringList words;

};

#endif // RANDOMWORDS_H

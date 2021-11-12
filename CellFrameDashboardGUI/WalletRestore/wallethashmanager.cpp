#include "wallethashmanager.h"

#include <QGuiApplication>
#include <QDebug>

constexpr int words_number {24};

WalletHashManager::WalletHashManager(QObject *parent) :
    QObject(parent),
    cryptographicHash(QCryptographicHash::Sha256),
    clipboard(QGuiApplication::clipboard())
{

}

void WalletHashManager::setContext(QQmlContext *cont)
{
    context = cont;

    updateWordsModelAndHash();
}

void WalletHashManager::generateNewWords()
{
    currentWords = randomWords.getRandomWords(words_number);

    getHashForWords();

    qDebug() << "WalletHashManager::generateNewWords" << currentWords;

    updateWordsModelAndHash();
}

void WalletHashManager::clearWords()
{

    currentWords.clear();
    currentHash.clear();

    qDebug() << "WalletHashManager::clearWords" << currentWords;

    updateWordsModelAndHash();
}

void WalletHashManager::getHashForWords()
{
    cryptographicHash.reset();

    for (auto word: currentWords)
        cryptographicHash.addData(word.toLocal8Bit());

    currentHash = "0x" + cryptographicHash.result().toHex();

    qDebug() << "WalletHashManager::getHashForWords" << currentHash;
}

void WalletHashManager::copyWordsToClipboard()
{
    QString allWords = currentWords.join(" ");

    qDebug() << "WalletHashManager::copyWordsToClipboard" << allWords;

    clipboard->setText(allWords);
}

void WalletHashManager::pasteWordsFromClipboard()
{
    QString allWords = clipboard->text();

    currentWords = allWords.split(" ");

    if (currentWords.size() != words_number)
    {
        currentWords.clear();
        currentHash.clear();

        emit clipboardError();
    }
    else
        getHashForWords();

    qDebug() << "WalletHashManager::pasteWordsFromClipboard" << currentWords;


    updateWordsModelAndHash();
}

void WalletHashManager::generateNewFile()
{
    currentData = randomFile.generateRandomData();

    getHashForFile();

    emit setHashString(currentHash);
}

void WalletHashManager::getHashForFile()
{
    cryptographicHash.reset();

    cryptographicHash.addData(currentData);

    currentHash = "0x" + cryptographicHash.result().toHex();

    qDebug() << "WalletHashManager::getHashForFile" << currentHash;
}

void WalletHashManager::saveFile(const QString &fileName)
{
    QString tempName = fileName;

    #ifdef Q_OS_WIN
    tempName.remove("file:///");
    #else
    tempName.remove("file://");
    #endif

    qDebug() << "WalletHashManager::saveFile" << tempName;

    if (!randomFile.saveDataToFile(tempName, currentData))
        emit fileError();
    else
        emit setFileName(tempName);
}

void WalletHashManager::openFile(const QString &fileName)
{
    QString tempName = fileName;

    #ifdef Q_OS_WIN
    tempName.remove("file:///");
    #else
    tempName.remove("file://");
    #endif

    qDebug() << "WalletHashManager::openFile" << tempName;

    QByteArray data = randomFile.loadDataFromFile(tempName);

    if (data.isEmpty())
    {
        emit fileError();
        return;
    }
    else
        emit setFileName(tempName);

    currentData = data;

    getHashForFile();

    emit setHashString(currentHash);
}


void WalletHashManager::updateWordsModelAndHash()
{
    context->setContextProperty("wordsModel", QVariant::fromValue(currentWords));

    emit setHashString(currentHash);
}

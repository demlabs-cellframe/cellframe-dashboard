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

void WalletHashManager::generateNewWords(QString pass)
{
    currentWords = randomWords.getRandomWords(words_number);

    getHashForWords(pass);

//    qDebug() << "WalletHashManager::generateNewWords" << currentWords;

    updateWordsModelAndHash();
}

void WalletHashManager::clearWords()
{

    currentWords.clear();
    currentHash.clear();

//    qDebug() << "WalletHashManager::clearWords" << currentWords;

    updateWordsModelAndHash();
}

void WalletHashManager::getHashForWords(QString pass)
{
    cryptographicHash.reset();

    for (auto word: currentWords)
        cryptographicHash.addData(word.toLocal8Bit());

    if(!pass.isEmpty())
        cryptographicHash.addData(pass.toLocal8Bit());

    currentHash = "0x" + cryptographicHash.result().toHex();

//    qDebug() << "WalletHashManager::getHashForWords" << currentHash;
}

void WalletHashManager::copyWordsToClipboard()
{
    QString allWords = currentWords.join(" ");

//    qDebug() << "WalletHashManager::copyWordsToClipboard" << allWords;

    clipboard->setText(allWords);
}

void WalletHashManager::pasteWordsFromClipboard(QString pass)
{
    QString allWords = clipboard->text();
    allWords = allWords.simplified();

    currentWords = allWords.split(" ");

    if (currentWords.size() != words_number)
    {
        currentWords.clear();
        currentHash.clear();

        emit clipboardError();
    }
    else
        getHashForWords(pass);

//    qDebug() << "WalletHashManager::pasteWordsFromClipboard" << currentWords;


    updateWordsModelAndHash();
}

void WalletHashManager::generateNewFile(QString pass)
{
    currentData = randomFile.generateRandomData();

    getHashForFile(pass);

    emit setHashString(currentHash);
}

void WalletHashManager::getHashForFile(QString pass)
{
    cryptographicHash.reset();

    cryptographicHash.addData(currentData);

    if(!pass.isEmpty())
        cryptographicHash.addData(pass.toLocal8Bit());

    currentHash = "0x" + cryptographicHash.result().toHex();

//    qDebug() << "WalletHashManager::getHashForFile" << currentHash;
}

void WalletHashManager::saveFile(const QString &fileName)
{
    QString tempName = fileName;

    #ifdef Q_OS_WIN
    tempName.remove("file:///");
    #else
    tempName.remove("file://");
    #endif

//    qDebug() << "WalletHashManager::saveFile" << tempName;

    if (!randomFile.saveDataToFile(tempName, currentData))
        emit fileError();
    else
        emit setFileName(tempName);
}

void WalletHashManager::openFile(const QString &fileName, QString pass)
{
    QString tempName = fileName;

    #ifdef Q_OS_WIN
    tempName.remove("file:///");
    #else
    tempName.remove("file://");
    #endif

//    qDebug() << "WalletHashManager::openFile" << tempName;

    QByteArray data = randomFile.loadDataFromFile(tempName);

    if (data.isEmpty())
    {
        emit fileError();
        return;
    }
    else
        emit setFileName(tempName);

    currentData = data;

    getHashForFile(pass);

    emit setHashString(currentHash);
}


void WalletHashManager::updateWordsModelAndHash()
{
    context->setContextProperty("wordsModel", QVariant::fromValue(currentWords));

    emit setHashString(currentHash);
}

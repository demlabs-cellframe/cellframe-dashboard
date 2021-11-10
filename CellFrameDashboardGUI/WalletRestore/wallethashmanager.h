#ifndef WALLETHASHMANAGER_H
#define WALLETHASHMANAGER_H

#include <QObject>
#include <QCryptographicHash>
#include <QStringList>
#include <QByteArray>
#include <QQmlContext>
#include <QClipboard>
#include <QSettings>

#include "randomwords.h"
#include "randomfile.h"

class WalletHashManager : public QObject
{
    Q_OBJECT
public:
    explicit WalletHashManager(QObject *parent = nullptr);

    void setContext(QQmlContext *cont);

signals:
    void setHashString(const QString &hash);

    void clipboardError();

    void fileError();

    void setFileName(const QString &fileName);

// 24 words
public slots:
    void generateNewWords();

    void clearWords();

    void getHashForWords();

    void copyWordsToClipboard();

    void pasteWordsFromClipboard();

// backup file
public slots:
    void generateNewFile();

    void getHashForFile();

    void saveFile(const QString &fileName);

    void openFile(const QString &fileName);

private:
    void updateWordsModelAndHash();

    QQmlContext *context;

    QCryptographicHash cryptographicHash;

    QString currentHash;

    // 24 words
    RandomWords randomWords;

    QClipboard *clipboard;

    QStringList currentWords;

    // backup file
    RandomFile randomFile;

    QByteArray currentData;
};

#endif // WALLETHASHMANAGER_H

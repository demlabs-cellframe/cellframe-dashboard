#ifndef WALLETHASHMANAGER_H
#define WALLETHASHMANAGER_H

#include <QObject>
#include <QCryptographicHash>
#include <QStringList>
#include <QQmlContext>
#include <QClipboard>

#include "randomwords.h"

class WalletHashManager : public QObject
{
    Q_OBJECT
public:
    explicit WalletHashManager(QObject *parent = nullptr);

    void setContext(QQmlContext *cont);

signals:
    void setHashString(const QString &hash);

    void clipboardError();

public slots:
    void generateNewWords();

    void clearWords();

    void getHashForWords();

    void copyWordsToClipboard();

    void pasteWordsFromClipboard();

private:
    void updateWordsModelAndHash();

    QQmlContext *context;

    QCryptographicHash cryptographicHash;

    RandomWords randomWords;

    QClipboard *clipboard;

    QStringList currentWords;

    QString currentHash;
};

#endif // WALLETHASHMANAGER_H

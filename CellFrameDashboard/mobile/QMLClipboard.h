#ifndef QMLCLIPBOARD_H
#define QMLCLIPBOARD_H

#include <QApplication>
#include <QClipboard>
#include <QObject>

class QMLClipboard : public QObject
{
    Q_OBJECT
public:
    explicit QMLClipboard(QObject *parent = 0) : QObject(parent) {
        clipboard = QApplication::clipboard();
    }

    Q_INVOKABLE void setText(const QString &text){
        clipboard->setText(text, QClipboard::Clipboard);
    }

    Q_INVOKABLE QString getText(){
        return clipboard->text();
    }

private:
    QClipboard *clipboard;
};

#endif // QMLCLIPBOARD_H

#ifndef DAPCLIPBOARD_H
#define DAPCLIPBOARD_H

#include <QObject>
#include <QClipboard>
#include <QApplication>

class DapClipboard : public QObject
{
    Q_OBJECT

private:
    QClipboard* m_clipboard;

public:
    explicit DapClipboard(QObject *parent = nullptr);
    static DapClipboard& instance();

public slots:
    Q_INVOKABLE void setText(const QString& aText);
};

#endif // DAPCLIPBOARD_H

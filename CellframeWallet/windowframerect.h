#ifndef WINDOWFRAMERECT_H
#define WINDOWFRAMERECT_H

#include <QQuickWindow>
#include <QObject>

class WindowFrameRect : public QObject
{
    Q_OBJECT
public:
    explicit WindowFrameRect(QObject *parent = 0) : QObject(parent) {
    }

    Q_INVOKABLE QRect getFrameRect(QObject *window){
        QQuickWindow *qw = qobject_cast<QQuickWindow *>(window);
        if (qw)
            return qw->frameGeometry();
        return QRect();
    }

private:
};

#endif // WINDOWFRAMERECT_H

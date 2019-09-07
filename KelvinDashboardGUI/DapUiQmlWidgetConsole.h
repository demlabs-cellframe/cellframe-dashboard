#ifndef DAPUIQMLSCREENCONSOLEFORM_H
#define DAPUIQMLSCREENCONSOLEFORM_H

#include <QObject>
#include <QPlainTextEdit>

class DapUiQmlWidgetConsole : public QObject
{
    Q_OBJECT

public:
    explicit DapUiQmlWidgetConsole(QObject *parent = nullptr);

public slots:

signals:
};

#endif // DAPUIQMLSCREENCONSOLEFORM_H

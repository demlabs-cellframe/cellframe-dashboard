#ifndef DAPUIQMLSCREENCONSOLEFORM_H
#define DAPUIQMLSCREENCONSOLEFORM_H

#include <QObject>
#include <QPlainTextEdit>

class DapUiQmlWidgetConsole : public QObject
{
    Q_OBJECT

private:
    QStringList m_CommandList;
    QStringList::iterator m_CommandIterator;

public:
    explicit DapUiQmlWidgetConsole(QObject *parent = nullptr);

public slots:
    void receiveResponse(const QString& aResponse);

    Q_INVOKABLE static DapUiQmlWidgetConsole& getInstance();
    Q_INVOKABLE QString getCommandUp() const;
    Q_INVOKABLE QString getCommandDown() const;
    Q_INVOKABLE void receiveRequest(const QString& aCommand);

signals:
    void sendRequest(QString command);
    void sendResponse(QString response);
};

#endif // DAPUIQMLSCREENCONSOLEFORM_H

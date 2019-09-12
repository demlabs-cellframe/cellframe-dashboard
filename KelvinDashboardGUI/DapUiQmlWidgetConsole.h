#ifndef DAPUIQMLSCREENCONSOLEFORM_H
#define DAPUIQMLSCREENCONSOLEFORM_H

#include <QDebug>
#include <QObject>
#include <QStringList>

class DapUiQmlWidgetConsoleModel : public QObject
{
    Q_OBJECT

private:
    QStringList m_CommandList;
    QStringList::iterator m_CommandIndex;

public:
    explicit DapUiQmlWidgetConsoleModel(QObject *parent = nullptr);

public slots:
    void receiveResponse(const QString& aResponse);

    Q_INVOKABLE static DapUiQmlWidgetConsoleModel& getInstance();
    Q_INVOKABLE QString getCommandUp();
    Q_INVOKABLE QString getCommandDown();
    Q_INVOKABLE void receiveRequest(const QString& aCommand);

signals:
    void sendRequest(QString command);
    void sendResponse(QString response);
};

#endif // DAPUIQMLSCREENCONSOLEFORM_H

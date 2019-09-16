#ifndef DAPUIQMLSCREENCONSOLEFORM_H
#define DAPUIQMLSCREENCONSOLEFORM_H

#include <QDebug>
#include <QAbstractListModel>
#include <QStringList>

class DapUiQmlWidgetConsoleModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum ConsoleRole {
       LastCommand = Qt::DisplayRole
    };

private:
    QStringList m_CommandList;
    QStringList::iterator m_CommandIndex;

public:
    explicit DapUiQmlWidgetConsoleModel(QObject *parent = nullptr);

public slots:
    void receiveResponse(const QString& aResponse);
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE static DapUiQmlWidgetConsoleModel& getInstance();
    Q_INVOKABLE QString getCommandUp();
    Q_INVOKABLE QString getCommandDown();
    Q_INVOKABLE void receiveRequest(const QString& aCommand);

signals:
    void sendRequest(QString command);
    void sendResponse(QString response);


};

#endif // DAPUIQMLSCREENCONSOLEFORM_H

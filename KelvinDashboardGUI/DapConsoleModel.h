#ifndef DAPUIQMLSCREENCONSOLEFORM_H
#define DAPUIQMLSCREENCONSOLEFORM_H

#include <QDebug>
#include <QAbstractListModel>
#include <QStringList>

/// Model for DAP console
class DapConsoleModel : public QAbstractListModel
{
    Q_OBJECT

public:
    /// Enumeration for model roles
    enum ConsoleRole {
       LastCommand = Qt::DisplayRole
    };

private:
    QStringList m_CommandList;
    QStringList::iterator m_CommandIndex;

public:
    explicit DapConsoleModel(QObject *parent = nullptr);

public slots:
    /// Receive response from service about command
    /// @param result
    void receiveResponse(const QString& aResponse);
    /// Override methods of abstract model
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    /// Getting instanse of this class
    /// @return instanse of this class
    Q_INVOKABLE static DapConsoleModel& getInstance();
    /// Get the latest commands
    /// @return the latest commands
    Q_INVOKABLE QString getCommandUp();
    /// Get the earliest commands
    /// @return the earliest commands. If it is last command in the list
    /// it returns QString()
    Q_INVOKABLE QString getCommandDown();
    /// Receive command requst for service
    /// @param command request
    Q_INVOKABLE void receiveRequest(const QString& aCommand);

signals:
    /// Signal to send request to the service
    /// @param command
    void sendRequest(QString command);
    /// Signal for getting response from service
    /// @param result of command
    void sendResponse(QString response);
};

#endif // DAPUIQMLSCREENCONSOLEFORM_H

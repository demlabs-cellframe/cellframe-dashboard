#ifndef DAPSETTINGSNETWORKMODEL_H
#define DAPSETTINGSNETWORKMODEL_H

#include <QAbstractListModel>
#include <QStringList>
#include <QDebug>

class DapSettingsNetworkModel : public QAbstractListModel
{
    Q_OBJECT

public:
    /// Enumeration display role
    enum DisplayRole {
      DisplayName = Qt::UserRole
    };

private:
    QStringList m_NetworkList;
    QString m_CurrentNetwork;
    int m_CurrentIndex;

public:
    explicit DapSettingsNetworkModel(QObject *parent = nullptr);
    /// Get instance of this object
    /// @return instance
    static DapSettingsNetworkModel &getInstance();

    /// Overload methods
    int rowCount(const QModelIndex& parent) const;
    QVariant data(const QModelIndex& index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    /// Get current network which was selected
    /// @return name of current network
    Q_INVOKABLE QString getCurrentNetwork() const;
    /// Get current index which was selected
    /// @return index of current network
    Q_INVOKABLE int getCurrentIndex() const;

public slots:
    /// Set new network list
    /// @param List of network
    void setNetworkList(const QStringList& aNetworkList);
    /// Set current network which was selected in combobox
    /// @param name of network
    /// @param index of network
    void setCurrentNetwork(QString CurrentNetwork, int CurrentIndex);

signals:
    /// Signal about changing current network
    /// @param name of network which was selected
    void currentNetworkChanged(QString currentNetwork);
};

#endif // DAPSETTINGSNETWORKMODEL_H

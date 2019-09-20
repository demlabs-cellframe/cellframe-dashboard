#ifndef DAPSETTINGSNETWORKMODEL_H
#define DAPSETTINGSNETWORKMODEL_H

#include <QAbstractListModel>
#include <QStringList>
#include <QDebug>

class DapSettingsNetworkModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QString CurrentNetwork READ getCurrentNetwork WRITE setCurrentNetwork NOTIFY currentNetworkChanged)

public:
    enum DisplayRole {
      DisplayName = Qt::UserRole
    };

private:
    QStringList m_NetworkList;
    QString m_CurrentNetwork;

public:
    explicit DapSettingsNetworkModel(QObject *parent = nullptr);
    static DapSettingsNetworkModel &getInstance();

    int rowCount(const QModelIndex& parent) const;
    QVariant data(const QModelIndex& index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QString getCurrentNetwork() const;

public slots:
    void setNetworkList(const QStringList& aNetworkList);
    void setCurrentNetwork(QString CurrentNetwork);

signals:
    void currentNetworkChanged(QString currentNetwork);
};

#endif // DAPSETTINGSNETWORKMODEL_H

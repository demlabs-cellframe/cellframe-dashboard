#ifndef DAPCHAINNETWORKHANDLER_H
#define DAPCHAINNETWORKHANDLER_H

#include <QObject>
#include <QString>

class DapChainNetworkHandler : public QObject
{
    Q_OBJECT

private:
    QStringList m_NetworkList;

public:
    explicit DapChainNetworkHandler(QObject *parent = nullptr);

    QStringList getNetworkList() const;

public slots:
    void setCurrentNetwork(const QString& aNetwork);

signals:
    void changeCurrentNetwork(QString network);
};

#endif // DAPCHAINNETWORKHANDLER_H

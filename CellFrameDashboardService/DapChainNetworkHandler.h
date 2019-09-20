#ifndef DAPCHAINNETWORKHANDLER_H
#define DAPCHAINNETWORKHANDLER_H

#include <QObject>
#include <QString>

#include <QFile>

class DapChainNetworkHandler : public QObject
{
    Q_OBJECT

private:
    QString m_CurrentNetwork;
    QStringList m_NetworkList;

public:
    explicit DapChainNetworkHandler(QObject *parent = nullptr);

    QStringList getNetworkList();

public slots:
    void setCurrentNetwork(const QString& aNetwork);

signals:
    void changeCurrentNetwork(QString network);
};

#endif // DAPCHAINNETWORKHANDLER_H

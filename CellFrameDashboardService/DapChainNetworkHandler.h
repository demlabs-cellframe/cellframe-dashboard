#ifndef DAPCHAINNETWORKHANDLER_H
#define DAPCHAINNETWORKHANDLER_H

#include <QObject>
#include <QString>
#include <QProcess>

#include <QFile>

class DapChainNetworkHandler : public QObject
{
    Q_OBJECT

private:
    QStringList m_NetworkList;

public:
    explicit DapChainNetworkHandler(QObject *parent = nullptr);

    /// Get network list
    /// @return Network list
    QStringList getNetworkList();
};

#endif // DAPCHAINNETWORKHANDLER_H

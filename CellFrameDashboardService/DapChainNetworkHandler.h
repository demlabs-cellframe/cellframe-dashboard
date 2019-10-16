#ifndef DAPCHAINNETWORKHANDLER_H
#define DAPCHAINNETWORKHANDLER_H

#include <QObject>
#include <QString>
#include <QProcess>

#include <QFile>

/// Class provides to get network's name list
class DapChainNetworkHandler : public QObject
{
    Q_OBJECT

private:
    /// List of network's name
    QStringList m_NetworkList;

public:
    /// Standard constructor
    explicit DapChainNetworkHandler(QObject *parent = nullptr);

    /// Get network list
    /// @return Network list
    QStringList getNetworkList();
};

#endif // DAPCHAINNETWORKHANDLER_H

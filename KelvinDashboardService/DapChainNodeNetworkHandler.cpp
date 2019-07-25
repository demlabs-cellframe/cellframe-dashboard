#include "DapChainNodeNetworkHandler.h"

DapChainNodeNetworkHandler::DapChainNodeNetworkHandler(QObject *parent) : QObject(parent)
{

}

QVariant DapChainNodeNetworkHandler::getNodeNetwork() const
{
    QProcess process;
    process.start(QString(CLI_PATH) + " node dump -net kelvin-testnet -full");

    process.waitForFinished(-1);
    QByteArray result = process.readAll();

    QMap<QString, QVariant> nodeMap;
    if(!result.isEmpty())
    {
        QStringList nodes = QString::fromStdString(result.toStdString()).split("node ");
        for(int m = 1; m < nodes.count(); m++)
        {
            QString node = nodes.at(m);
            QStringList nodeData;
            QRegExp rx_node("address ((?:[0-9A-F]{4}::){3}[0-9A-F]{4})\\s+\n"
                       "cell (0[xX][0-9A-F]{16})((?:\\d{1,3}\\.){3}\\d{1,3})\\s+\n"
                       "ipv4 ::\\s+\n"
                       "ipv6\\s+\n"
                       "alias (\\S+)\\s+\n"
                       "links (\\d+)\\s+\n");

            rx_node.indexIn(node, 0);
            for(int i = 2; i < 6; i++) nodeData << rx_node.cap(i);

            if(nodeData.last().toUInt() > 0)
            {
                QRegExp rx_links("link\\d+ address : ((?:[0-9A-F]{4}::){3}[0-9A-F]{4})");
                int pos = 0;
                while ((pos = rx_links.indexIn(node, pos)) != -1)
                {
                    nodeData << rx_links.cap(1);
                    pos += rx_links.matchedLength();
                }
            }

            nodeMap[rx_node.cap(1)] = nodeData;
        }
    }

    return nodeMap;
}

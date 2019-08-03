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
            QRegExp rx_node("address ((?:[0-9A-F]{4}::){3}[0-9A-F]{4}).+"
                            "cell (0[xX][0-9A-F]{16}).+"
                            "ipv4 ((?:[0-9]{1,3}\\.){3}[0-9]{1,3}).+"
                            "ipv6 ::.+"
                            "alias (\\S+).+"
                            "links (\\d+).+");

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


    QProcess process_status;
    process_status.start(QString(CLI_PATH) + QString(" net -net kelvin-testnet get status"));

    process_status.waitForFinished(-1);
    QByteArray result_status = process_status.readAll();

    if(!result_status.isEmpty())
    {
        QRegExp reg_exp("Network \"([\\w\\W]+)\" has state (\\w+) \\(target state [\\w]+\\), "
                        "active links \\d+ from \\d+, cur node address ((?:[0-9A-F]{4}::){3}[0-9A-F]{4})");

        reg_exp.indexIn(result_status, 0);
        nodeMap["current"] = QStringList() << reg_exp.cap(2) << reg_exp.cap(1);
    }

    return nodeMap;

//    DapNodeMap nodeMap;

//    if(!result.isEmpty())
//    {
//        QStringList nodes = QString::fromStdString(result.toStdString()).split("node ");
//        for(int m = 1; m < nodes.count(); m++)
//        {
//            QString node = nodes.at(m);
//            DapNodeData nodeData;
//            QRegExp rx_node("address ((?:[0-9A-F]{4}::){3}[0-9A-F]{4}).+"
//                            "cell (0[xX][0-9A-F]{16}).+"
//                            "ipv4 ((?:[0-9]{1,3}\\.){3}[0-9]{1,3}).+"
//                            "ipv6 ::.+"
//                            "alias (\\S+).+"
//                            "links (\\d+).+");

//            rx_node.indexIn(node, 0);
//            nodeData.Cell = rx_node.cap(2).toUInt();
//            nodeData.Ipv4 = rx_node.cap(3);
//            nodeData.Alias = rx_node.cap(4);

//            if(rx_node.cap(5).toUInt() > 0)
//            {
//                QStringList nodeLink;
//                QRegExp rx_links("link\\d+ address : ((?:[0-9A-F]{4}::){3}[0-9A-F]{4})");
//                int pos = 0;

//                while ((pos = rx_links.indexIn(node, pos)) != -1)
//                {
//                    nodeLink << rx_links.cap(1);
//                    pos += rx_links.matchedLength();
//                }
//            }

//            qDebug() << rx_node.cap(1) << nodeMap.count();
//            nodeMap[rx_node.cap(1)] = nodeData;
//        }
//    }

//    QProcess process_status;
//    process_status.start(QString(CLI_PATH) + QString(" net -net kelvin-testnet get status"));

//    process.waitForFinished(-1);
//    QByteArray result_status = process_status.readAll();

//    if(!result_status.isEmpty())
//    {
//        QRegExp reg_exp("Network \"([\\w\\W]+)\" has state (\\w+) \\(target state [\\w]+\\), "
//                        "active links \\d+ from \\d+, cur node address ((?:[0-9A-F]{4}::){3}[0-9A-F]{4})");

//        reg_exp.indexIn(result_status, 0);
//        nodeMap[reg_exp.cap(2)].Status = reg_exp.cap(1) == "NET_STATE_OFFLINE" ? false : true;
//        nodeMap[reg_exp.cap(2)].isCurrentNode = true;
//    }
}

void DapChainNodeNetworkHandler::setNodeStatus(const bool aIsOnline)
{
    QProcess process;
    process.start(QString(CLI_PATH) + QString(" net -net kelvin-testnet go %1").arg(aIsOnline ? "true" : "false"));
    process.waitForFinished(-1);
}

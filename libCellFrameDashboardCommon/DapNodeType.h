#ifndef DAPNODETYPE_H
#define DAPNODETYPE_H

#include <QString>
#include <QStringList>
#include <QDataStream>

/// Structure for node network data
struct DapNodeData {
    quint32 Cell;
    QString Ipv4;
    QString Alias;
    QStringList Link;
    bool Status;
    bool isCurrentNode;

    DapNodeData()
    {
        Status = false;
        isCurrentNode = false;
    }

    DapNodeData& operator = (const DapNodeData& AData) {
        Cell = AData.Cell;
        Alias = AData.Alias;
        Ipv4 = AData.Ipv4;
        Link = AData.Link;
        Status = AData.Status;
        isCurrentNode = AData.isCurrentNode;
        return *this;
    }

    friend QDataStream& operator<< (QDataStream& out, const DapNodeData& aData)
    {
        out << aData.Cell
            << aData.Ipv4
            << aData.Alias
            << aData.Link
            << aData.Status
            << aData.isCurrentNode;

        return out;
    }

    friend QDataStream& operator>> (QDataStream& in, DapNodeData& aData)
    {
        in  >> aData.Cell
            >> aData.Ipv4
            >> aData.Alias
            >> aData.Link
            >> aData.Status
            >> aData.isCurrentNode;
        return in;
    }
};

typedef QMap<QString /*Address*/, DapNodeData /*Data*/> DapNodeMap;


#endif // DAPNODETYPE_H

#ifndef DAPNODETYPE_H
#define DAPNODETYPE_H

#include <QString>
#include <QStringList>

struct DapNodeData {
    quint32 Cell;
    QString Ipv4;
    QString Alias;
    QStringList Link;
    bool Status;

    DapNodeData()
    {
        Status = false;
    }

    DapNodeData& operator = (const DapNodeData& AData) {
        Cell = AData.Cell;
        Alias = AData.Alias;
        Ipv4 = AData.Ipv4;
        Link = AData.Link;
        Status = AData.Status;
        return *this;
    }
};

typedef QMap<QString /*Address*/, DapNodeData /*Data*/> DapNodeMap;


#endif // DAPNODETYPE_H

#include "DapChainNodeNetworkExplorer.h"

//  TEST
//#define VIRTUAL_COLUMN_NUMBER   5
//-----------------------------------

#define DESCRIPTION_NODE            QString("Address: %1\nAlias: %2\nIPv4: %3")
#define DEFAULT_NODE_COLOR_HOVER    QColor("#FF0000")
#define DEFAULT_NODE_COLOR          QColor("#000000")
#define DEFAULT_NODE_SIZE           50
#define DEFAULT_WIDTH_LINE          3

DapChainNodeNetworkExplorer::DapChainNodeNetworkExplorer(QQuickItem *parent) : QQuickPaintedItem(parent)
{
    setAcceptedMouseButtons(Qt::LeftButton);
    setAcceptHoverEvents(true);
    m_colorNormal = DEFAULT_NODE_COLOR;
    m_colorActivated = DEFAULT_NODE_COLOR_HOVER;
    m_sizeNode = DEFAULT_NODE_SIZE;
    m_widthLine = DEFAULT_WIDTH_LINE;
}

void DapChainNodeNetworkExplorer::mousePressEvent(QMouseEvent* event)
{
    QQuickPaintedItem::mousePressEvent(event);
    for(auto Node = m_nodeMap.constBegin(); Node != m_nodeMap.constEnd(); Node++)
    {
        if(Node.value().isFocus)
        {
            const DapNodeData* nodeData = &Node.value();
            QString textToolTip = DESCRIPTION_NODE
                                  .arg(Node.key())
                                  .arg(nodeData->Alias)
                                  .arg(nodeData->AddressIpv4.toString());
            emit selectNode("Node description", textToolTip);
            return;
        }
    }
}

void DapChainNodeNetworkExplorer::wheelEvent(QWheelEvent* event)
{
    if(event->modifiers() == Qt::ControlModifier)
    {
        if(event->delta() > 1) {
            if(scale() < 1.8) setScale(scale() + 0.1);
        }
        else {
            if(scale() > 0.5) setScale(scale() - 0.1);
        }
    }
}

void DapChainNodeNetworkExplorer::hoverMoveEvent(QHoverEvent* event)
{
    QQuickPaintedItem::hoverMoveEvent(event);

    for(auto Node = m_nodeMap.begin(); Node != m_nodeMap.end(); Node++)
    {
        DapNodeData* NodeData = &Node.value();
        if(NodeData->Rect.contains(event->pos()))
        {
            NodeData->isFocus = true;
            break;
        }
        else
        {
            if(NodeData->isFocus)
            {
                NodeData->isFocus = false;
                break;
            }
        }
    }

    update();
}

void DapChainNodeNetworkExplorer::paint(QPainter* painter)
{
    QString address;
    const DapNodeData* activatedNode = nullptr;

    QPen pen(QBrush(m_colorNormal), m_widthLine);
    painter->setPen(pen);
    painter->setBrush(QBrush("#FFFFFF"));

    for(auto Node = m_nodeMap.constBegin(); Node != m_nodeMap.constEnd(); Node++)
    {
        const DapNodeData* NodeData = &Node.value();
        for(int i = 0; i < NodeData->Link.count(); i++)
            painter->drawLine(NodeData->Rect.center(), NodeData->Link.at(i)->Rect.center());

        if(NodeData->isFocus)
        {
            address = Node.key();
            activatedNode = NodeData;
            continue;
        }

        painter->drawEllipse(NodeData->Rect);
    }

    if(activatedNode != nullptr)
    {
        QPen penActivated(QBrush(m_colorActivated), m_widthLine);
        QPen penWhite(QBrush("#FFFFFF"), m_widthLine);
        QRect rect(activatedNode->Rect.center(), QSize(200, 50));

        painter->setPen(penActivated);
        painter->drawEllipse(activatedNode->Rect);

        painter->setPen(penWhite);
        painter->drawRect(rect);

        painter->setPen(pen);
        painter->drawText(rect, DESCRIPTION_NODE
                          .arg(address)
                          .arg(activatedNode->Alias)
                          .arg(activatedNode->AddressIpv4.toString()));
    }
}

QVariant DapChainNodeNetworkExplorer::getData() const
{
    return m_data;
}

QColor DapChainNodeNetworkExplorer::getColorNormal() const
{
    return m_colorNormal;
}

QColor DapChainNodeNetworkExplorer::getColorActivated() const
{
    return m_colorActivated;
}

int DapChainNodeNetworkExplorer::getWidthLine() const
{
    return m_widthLine;
}

int DapChainNodeNetworkExplorer::getSizeNode() const
{
    return m_sizeNode;
}

void DapChainNodeNetworkExplorer::setData(const QVariant& AData)
{
    if (m_data == AData) return;
    m_data = AData;
    m_nodeMap.clear();
    emit dataChanged(m_data);

    QMap<QString, QVariant> dataMap = m_data.toMap();

    int pointX = m_sizeNode;
    int heightConten = dataMap.count() * m_sizeNode;

    QList<QString> addressList = dataMap.keys();
    foreach(auto address, addressList)
        m_nodeMap[address] = DapNodeData();

    for(auto node = m_nodeMap.begin(); node != m_nodeMap.end(); node++)
    {
        DapNodeData* nodeData = &node.value();
        QStringList nodeDataList = dataMap[node.key()].toStringList();
        nodeData->Cell = nodeDataList.at(0).toUInt();
        nodeData->AddressIpv4 = QHostAddress(nodeDataList.at(1));
        nodeData->Alias = nodeDataList.at(2);

        if(nodeDataList.at(3).toUInt() > 0)
        {
            for(int i = 4; i < nodeDataList.count(); i++)
                nodeData->Link.append(&m_nodeMap[nodeDataList.at(i)]);
        }

        int posY = (qrand() % ((heightConten + 1) - m_sizeNode) + m_sizeNode);
        nodeData->Rect = QRect(pointX, posY, m_sizeNode, m_sizeNode);
        pointX += m_sizeNode * 2;
    }

    setSize(QSize(pointX + m_sizeNode * 2, heightConten + m_sizeNode * 2));
    update();
}

void DapChainNodeNetworkExplorer::setColorNormal(const QColor& AColorNormal)
{
    if (m_colorNormal == AColorNormal)
        return;

    m_colorNormal = AColorNormal;
    emit colorNormalChanged(m_colorNormal);
}

void DapChainNodeNetworkExplorer::setColorActivated(const QColor& AColorActivated)
{
    if (m_colorActivated == AColorActivated) return;
    m_colorActivated = AColorActivated;
    emit colorActivatedChanged(m_colorActivated);
}

void DapChainNodeNetworkExplorer::setWidthLine(const int widthLine)
{
    if (m_widthLine == widthLine) return;
    m_widthLine = widthLine;
    emit widthLineChanged(m_widthLine);
}

void DapChainNodeNetworkExplorer::setSizeNode(const int sizeNode)
{
    if (m_sizeNode == sizeNode) return;
    m_sizeNode = sizeNode;
    emit sizeNodeChanged(m_sizeNode);
}

#include "DapChainNodeNetworkExplorer.h"

//  TEST
//#define VIRTUAL_COLUMN_NUMBER   5
//-----------------------------------

//#define DESCRIPTION_NODE            QString("Address: %1\nAlias: %2\nIPv4: %3")
#define DEFAULT_NODE_COLOR_HOVER    QColor("#FF0000")
#define DEFAULT_NODE_COLOR          QColor("#000000")
#define DEFAULT_NODE_SIZE           50
#define DEFAULT_WIDTH_LINE          3

DapChainNodeNetworkExplorer::DapChainNodeNetworkExplorer(QQuickItem *parent) :
    QQuickPaintedItem(parent),
    m_model(nullptr),
    m_colorNormal(DEFAULT_NODE_COLOR),
    m_colorFocused(DEFAULT_NODE_COLOR_HOVER),
    m_widthLine(DEFAULT_WIDTH_LINE),
    m_sizeNode(DEFAULT_NODE_SIZE)
{
    setAcceptedMouseButtons(Qt::RightButton);
    setAcceptHoverEvents(true);
}

void DapChainNodeNetworkExplorer::mousePressEvent(QMouseEvent* event)
{
    QQuickPaintedItem::mousePressEvent(event);

    for(auto Node = m_nodeMap.begin(); Node != m_nodeMap.end(); Node++)
    {
        if (Node.value().State == DapNodeState::Selected)
        {
            Node.value().State = DapNodeState::Normal;
            emit selectNodeChanged();
        }

        if(Node.value().State == DapNodeState::Focused)
        {
            DapNodeData* nodeData = &Node.value();
            nodeData->State = DapNodeState::Selected;
            m_currentSelectedNode = Node.key();
            emit selectNode(Node.key());
        }
    }

    update();
}

void DapChainNodeNetworkExplorer::wheelEvent(QWheelEvent* event)
{
    if(event->modifiers() == Qt::ControlModifier)
    {
        if(event->delta() > 1)
        {
            if(scale() < 1.8) setScale(scale() + 0.1);
        }
        else
        {
            if(scale() > 0.5) setScale(scale() - 0.1);
        }
    }
}

void DapChainNodeNetworkExplorer::hoverMoveEvent(QHoverEvent* event)
{
    QQuickPaintedItem::hoverMoveEvent(event);

    for(auto Node = m_nodeMap.begin(); Node != m_nodeMap.end(); Node++)
    {
        DapNodeData* nodeData = &Node.value();
        if(nodeData->Rect.contains(event->pos()))
        {
            if(nodeData->State == DapNodeState::Selected) return;
            nodeData->State = DapNodeState::Focused;
            break;
        }
        else
        {
            if(nodeData->State == DapNodeState::Focused)
            {
                nodeData->State = DapNodeState::Normal;
                break;
            }
        }
    }

    update();
}

void DapChainNodeNetworkExplorer::paint(QPainter* painter)
{
    if(m_model == nullptr) return;
    QString address;
    const DapNodeData* activatedNode = nullptr;

    QPen pen(QBrush(m_colorNormal), m_widthLine);
    painter->setPen(pen);
    painter->setBrush(QBrush("#FFFFFF"));

    for(auto node = m_nodeMap.constBegin(); node != m_nodeMap.constEnd(); node++)
    {
        const DapNodeData* nodeData = &node.value();
        for(int i = 0; i < nodeData->Link.count(); i++)
            painter->drawLine(nodeData->Rect.center(), nodeData->Link.at(i)->Rect.center());

        if(nodeData->State == DapNodeState::Focused)
        {
            address = node.key();
            activatedNode = nodeData;
            continue;
        }
        else if (nodeData->State == DapNodeState::Selected)
        {
            QPen penSelected(QBrush("#0000FF"), m_widthLine);
            painter->setPen(penSelected);
            painter->drawEllipse(nodeData->Rect);
            painter->setPen(pen);
            continue;
        }

        painter->drawEllipse(nodeData->Rect);
    }

    if(activatedNode != nullptr)
    {
        QPen penActivated(QBrush(m_colorFocused), m_widthLine);
        QPen penWhite(QBrush("#FFFFFF"), m_widthLine);
        QRect rect(activatedNode->Rect.center(), QSize(200, 15));

        painter->setPen(penActivated);
        painter->drawEllipse(activatedNode->Rect);

        painter->setPen(penWhite);
        painter->drawRect(rect);

        painter->setPen(pen);
        painter->drawText(rect, activatedNode->Alias);
    }
}

QColor DapChainNodeNetworkExplorer::getColorNormal() const
{
    return m_colorNormal;
}

QColor DapChainNodeNetworkExplorer::getColorFocused() const
{
    return m_colorFocused;
}

int DapChainNodeNetworkExplorer::getWidthLine() const
{
    return m_widthLine;
}

int DapChainNodeNetworkExplorer::getSizeNode() const
{
    return m_sizeNode;
}

DapChainNodeNetworkModel* DapChainNodeNetworkExplorer::getModel() const
{
    return m_model;
}


int DapChainNodeNetworkExplorer::getSelectedNodePosX() const
{
    if(m_nodeMap.contains(m_currentSelectedNode))
       return m_nodeMap[m_currentSelectedNode].Rect.center().x();

    return -1;
}

int DapChainNodeNetworkExplorer::getSelectedNodePosY() const
{
    if(m_nodeMap.contains(m_currentSelectedNode))
       return m_nodeMap[m_currentSelectedNode].Rect.center().y();

    return -1;
}

QString DapChainNodeNetworkExplorer::getSelectedNodeAddress() const
{
    return m_currentSelectedNode;
}

QString DapChainNodeNetworkExplorer::getSelectedNodeAlias() const
{
    if(m_nodeMap.contains(m_currentSelectedNode))
       return m_nodeMap[m_currentSelectedNode].Alias;

    return QString();
}

QString DapChainNodeNetworkExplorer::getSelectedNodeIpv4() const
{
    if(m_nodeMap.contains(m_currentSelectedNode))
       return m_nodeMap[m_currentSelectedNode].AddressIpv4.toString();

    return QString();
}

QColor DapChainNodeNetworkExplorer::getColorOnline() const
{
    return m_colorOnline;
}

QColor DapChainNodeNetworkExplorer::getColorOffline() const
{
    return m_colorOffline;
}

QColor DapChainNodeNetworkExplorer::getColorSelect() const
{
    return m_colorSelect;
}

void DapChainNodeNetworkExplorer::setColorNormal(const QColor& aColorNormal)
{
    if (m_colorNormal == aColorNormal)
        return;

    m_colorNormal = aColorNormal;
    emit colorNormalChanged(m_colorNormal);
}

void DapChainNodeNetworkExplorer::setColorFocused(const QColor& aColorActivated)
{
    if (m_colorFocused == aColorActivated) return;
    m_colorFocused = aColorActivated;
    emit colorFocusedChanged(m_colorFocused);
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

void DapChainNodeNetworkExplorer::setModel(DapChainNodeNetworkModel* aModel)
{
    if (m_model == aModel) return;
    m_model = aModel;
    connect(m_model, SIGNAL(dataChanged(QVariant)), this, SLOT(proccessCreateGraph()));
    proccessCreateGraph();
    emit modelChanged(m_model);
}

void DapChainNodeNetworkExplorer::setCurrentNodeStatus(const DapNodeStatus& aNodeStatus)
{
    qDebug() << "changed node status" << m_currentSelectedNode << (int)aNodeStatus;
    if(m_nodeMap.contains(m_currentSelectedNode))
        m_nodeMap[m_currentSelectedNode].Status = aNodeStatus;
}

void DapChainNodeNetworkExplorer::setColorOnline(const QColor& aColorOnline)
{
    if (m_colorOnline == aColorOnline)
        return;

    m_colorOnline = aColorOnline;
    emit colorOnlineChanged(m_colorOnline);
}

void DapChainNodeNetworkExplorer::setColorOffline(const QColor& aColorOffline)
{
    if (m_colorOffline == aColorOffline)
        return;

    m_colorOffline = aColorOffline;
    emit colorOfflineChanged(m_colorOffline);
}

void DapChainNodeNetworkExplorer::setColorSelect(const QColor& aColorSelect)
{
    if (m_colorSelect == aColorSelect)
        return;

    m_colorSelect = aColorSelect;
    emit colorSelectChanged(m_colorSelect);
}

void DapChainNodeNetworkExplorer::proccessCreateGraph()
{
    if(m_model == nullptr) return;
    QVariant m_data = m_model->getData();

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

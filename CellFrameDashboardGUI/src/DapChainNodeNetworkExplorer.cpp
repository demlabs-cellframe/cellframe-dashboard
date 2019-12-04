#include "DapChainNodeNetworkExplorer.h"

#define DEFAULT_NODE_COLOR_HOVER    QColor("#FF0000")
#define DEFAULT_NODE_COLOR          QColor("#000000")
#define DEFAULT_NODE_COLOR_OFFLINE  QColor("#FF0000")
#define DEFAULT_NODE_COLOR_ONLINE   QColor("#00FF00")
#define DEFAULT_NODE_COLOR_SELECTED QColor("#0000FF")
#define DEFAULT_NODE_SIZE           50
#define DEFAULT_WIDTH_LINE          3

DapChainNodeNetworkExplorer::DapChainNodeNetworkExplorer(QQuickItem *parent) :
    QQuickPaintedItem(parent),
    m_model(nullptr),
    m_colorOnline(DEFAULT_NODE_COLOR_ONLINE),
    m_colorOffline(DEFAULT_NODE_COLOR_OFFLINE),
    m_colorSelect(DEFAULT_NODE_COLOR_SELECTED),
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

    emit selectNodeChanged();

    if(m_currentSelectedNode.second != nullptr)
    {
        m_currentSelectedNode.second->State = Normal;
        m_currentSelectedNode.second = nullptr;
    }

    for(auto node = m_nodeMap.begin(); node != m_nodeMap.end(); node++)
    {
        if(node.value().State == DapNodeState::Focused)
        {
            DapNodeGui* nodeData = &node.value();
            nodeData->State = DapNodeState::Selected;
            m_currentSelectedNode = QPair<QString, DapNodeGui*>(node.key(), nodeData);

            const DapNodeData* currentData = m_model->getNodeData(node.key());
            emit selectNode(currentData->isCurrentNode);
            update();
            return;
        }
    }
}

void DapChainNodeNetworkExplorer::wheelEvent(QWheelEvent* event)
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

void DapChainNodeNetworkExplorer::hoverMoveEvent(QHoverEvent* event)
{
    QQuickPaintedItem::hoverMoveEvent(event);

    for(auto node = m_nodeMap.begin(); node != m_nodeMap.end(); node++)
    {
        DapNodeGui* nodeDataGui = &node.value();
        if(nodeDataGui->Rect.contains(event->pos()) && nodeDataGui->State != Selected)
        {
            nodeDataGui->State = DapNodeState::Focused;
            break;
        }
        else if(nodeDataGui->State == DapNodeState::Focused)
        {
            nodeDataGui->State = DapNodeState::Normal;
            break;
        }
    }

    update();
}

void DapChainNodeNetworkExplorer::paint(QPainter* painter)
{
    if(m_model == nullptr) return;
    QString focusedNode = QString();
    QPen penNormal(QBrush(m_colorNormal), m_widthLine);
    QPen penOnline(QBrush(m_colorOnline), m_widthLine);
    QPen penOffline(QBrush(m_colorOffline), m_widthLine);
    QPen penFocused(QBrush(m_colorFocused), m_widthLine);
    QPen penSelected(QBrush(m_colorSelect), m_widthLine);

    painter->setBrush(QBrush("#FFFFFF"));
    for(auto node = m_nodeMap.constBegin(); node != m_nodeMap.constEnd(); node++)
    {
        const DapNodeGui* nodeDataGui = &node.value();
        const DapNodeData* nodeData = m_model->getNodeData(node.key());
        if(nodeData == nullptr) continue;
        for(int i = 0; i < nodeData->Link.count(); i++)
        {
            painter->setPen(penNormal);
            if(nodeData->isCurrentNode)
            {
                if(nodeData->Status) painter->setPen(penOnline);
                else painter->setPen(penOffline);
            }

            painter->drawLine(nodeDataGui->Rect.center(), m_nodeMap[nodeData->Link.at(i)].Rect.center());
        }

        if(nodeDataGui->State == Focused)
        {
            painter->setPen(penFocused);
            focusedNode = node.key();
        }
        else if(nodeDataGui->State == Selected) painter->setPen(penSelected);
        else painter->setPen(penNormal);

        painter->drawEllipse(nodeDataGui->Rect);
    }

    if(!focusedNode.isEmpty())
    {
        QPen penWhite(QBrush("#FFFFFF"), m_widthLine);
        QRect rect(m_nodeMap[focusedNode].Rect.center(), QSize(200, 15));
        const DapNodeData* nodeData = m_model->getNodeData(focusedNode);

        painter->setPen(penWhite);
        painter->drawRect(rect);
        painter->setPen(penNormal);
        painter->drawText(rect, nodeData->Alias);
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
    if(m_currentSelectedNode.second != nullptr)
        return m_currentSelectedNode.second->Rect.center().x();
    return -1;
}

int DapChainNodeNetworkExplorer::getSelectedNodePosY() const
{
    if(m_currentSelectedNode.second != nullptr)
        return m_currentSelectedNode.second->Rect.center().y();
    return -1;
}

QString DapChainNodeNetworkExplorer::getSelectedNodeAddress() const
{
    if(m_currentSelectedNode.second != nullptr)
        return m_currentSelectedNode.first;
    return QString();
}

QString DapChainNodeNetworkExplorer::getSelectedNodeAlias() const
{
    if(m_currentSelectedNode.second != nullptr)
    {
        const DapNodeData* nodeData = m_model->getNodeData(m_currentSelectedNode.first);
        if(nodeData != nullptr)
            return nodeData->Alias;
    }

    return QString();
}

QString DapChainNodeNetworkExplorer::getSelectedNodeIpv4() const
{
    if(m_currentSelectedNode.second != nullptr)
    {
        const DapNodeData* nodeData = m_model->getNodeData(m_currentSelectedNode.first);
        if(nodeData != nullptr)
            return nodeData->Ipv4;
    }

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
    QObject::connect(m_model, SIGNAL(changeNodeNetwork()), this, SLOT(proccessCreateGraph()));
    QObject::connect(m_model, SIGNAL(changeStatusNode(QString, bool)), this, SLOT(update()));
    proccessCreateGraph();
    emit modelChanged(m_model);
}

QString DapChainNodeNetworkExplorer::getAddressByPos(const int aX, const int aY)
{
    for(auto node = m_nodeMap.constBegin(); node != m_nodeMap.constEnd(); node++)
    {
        if(node->Rect.contains(aX, aY))
            return node.key();
    }

    return QString();
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

    const DapNodeMap* const nodeMap = m_model->getDataMap();
    int pointX = m_sizeNode;
    int heightConten = nodeMap->count() * m_sizeNode;

    qsrand(150);
    for (auto node = nodeMap->constBegin(); node != nodeMap->constEnd(); node++)
    {
        DapNodeGui nodeData;

        int posY = (qrand() % ((heightConten + 1) - m_sizeNode) + m_sizeNode);
        nodeData.Rect = QRect(pointX, posY, m_sizeNode, m_sizeNode);
        pointX += m_sizeNode * 2;

        m_nodeMap[node.key()] = nodeData;
    }

    setSize(QSize(pointX + m_sizeNode * 2, heightConten + m_sizeNode * 2));
    update();
}

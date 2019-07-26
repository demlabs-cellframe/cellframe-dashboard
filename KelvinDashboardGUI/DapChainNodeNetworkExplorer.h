#ifndef DAPCHAINNODENETWORKEXPLORER_H
#define DAPCHAINNODENETWORKEXPLORER_H

#include <QQuickPaintedItem>
#include <QPainter>
#include <QHostAddress>
#include <QVariant>
#include <QToolTip>

#include "DapChainNodeNetworkModel.h"

enum class DapNodeState {
    Normal,
    Focused,
    Selected
};

enum class DapNodeStatus {
    Offline,
    Online
};

struct DapNodeData {
    quint32 Cell;
    QHostAddress AddressIpv4;
    QString Alias;
    QVector<DapNodeData*> Link;
    QRect Rect;
    DapNodeState State;
    DapNodeStatus Status;

    DapNodeData()
    {
        State = DapNodeState::Normal;
        Status = DapNodeStatus::Offline;
        Link = QVector<DapNodeData*>();
    }

    DapNodeData& operator << (DapNodeData& AData)
    {
        Link.append(&AData);
        return *this;
    }

    DapNodeData& operator = (const DapNodeData& AData) {
        Cell = AData.Cell;
        Alias = AData.Alias;
        AddressIpv4 = AData.AddressIpv4;
        Rect = AData.Rect;
        Link = AData.Link;
        State = AData.State;
        Status = AData.Status;
        return *this;
    }
};

class DapChainNodeNetworkExplorer : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor colorNormal READ getColorNormal WRITE setColorNormal NOTIFY colorNormalChanged)
    Q_PROPERTY(QColor colorActivated READ getColorActivated WRITE setColorActivated NOTIFY colorActivatedChanged)
    Q_PROPERTY(int widthLine READ getWidthLine WRITE setWidthLine NOTIFY widthLineChanged)
    Q_PROPERTY(int sizeNode READ getSizeNode WRITE setSizeNode NOTIFY sizeNodeChanged)

    Q_PROPERTY(DapChainNodeNetworkModel* model READ getModel WRITE setModel NOTIFY modelChanged)

private:
    DapChainNodeNetworkModel* m_model;
    QMap<QString /*Address*/, DapNodeData /*Data*/> m_nodeMap;

    QColor m_colorNormal;
    QColor m_colorActivated;
    int m_widthLine;
    int m_sizeNode;

protected:
    void mousePressEvent(QMouseEvent* event);
    void wheelEvent(QWheelEvent* event);
    void hoverMoveEvent(QHoverEvent* event);

public:
    explicit DapChainNodeNetworkExplorer(QQuickItem *parent = nullptr);
    void paint(QPainter* painter);
    QColor getColorNormal() const;
    QColor getColorActivated() const;
    int getWidthLine() const;
    int getSizeNode() const;

    DapChainNodeNetworkModel* getModel() const;

    const DapNodeData* findNodeData(const QPoint& aPos) const;
//    Q_INVOKABLE QPoint selectedNodePos() const;

public slots:
    void setColorNormal(const QColor& AColorNormal);
    void setColorActivated(const QColor& AColorActivated);
    void setWidthLine(const int widthLine);
    void setSizeNode(const int sizeNode);

    void setModel(DapChainNodeNetworkModel* aModel);

private slots:
    void proccessCreateGraph();

signals:
    void dataChanged(QVariant data);
    void colorNormalChanged(QColor colorNormal);
    void colorActivatedChanged(QColor colorActivated);
    void widthLineChanged(int widthLine);
    void sizeNodeChanged(int sizeNode);
    void modelChanged(DapChainNodeNetworkModel* model);

    void selectNode(int posX, int posY, QString address, QString alias, QString ipv4);
    void selectNodeChanged();
};

#endif // DAPCHAINNODENETWORKEXPLORER_H

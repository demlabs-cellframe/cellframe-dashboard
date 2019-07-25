#ifndef DAPCHAINNODENETWORKEXPLORER_H
#define DAPCHAINNODENETWORKEXPLORER_H

#include <QQuickPaintedItem>
#include <QPainter>
#include <QHostAddress>
#include <QVariant>
#include <QToolTip>

//#include "DapChainNode.h"
//#include "DapNetworkType.h"

struct DapNodeData {
    quint32 Cell;
    QHostAddress AddressIpv4;
    QString Alias;
    QVector<DapNodeData*> Link;
    QRect Rect;
    bool isFocus;

    DapNodeData()
    {
        isFocus = false;
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
        isFocus = AData.isFocus;
        return *this;
    }
};

class DapChainNodeNetworkExplorer : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QVariant data READ getData WRITE setData NOTIFY dataChanged)
    Q_PROPERTY(QColor colorNormal READ getColorNormal WRITE setColorNormal NOTIFY colorNormalChanged)
    Q_PROPERTY(QColor colorActivated READ getColorActivated WRITE setColorActivated NOTIFY colorActivatedChanged)
    Q_PROPERTY(int widthLine READ getWidthLine WRITE setWidthLine NOTIFY widthLineChanged)
    Q_PROPERTY(int sizeNode READ getSizeNode WRITE setSizeNode NOTIFY sizeNodeChanged)

private:
    QVariant m_data;
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
    QVariant getData() const;
    QColor getColorNormal() const;
    QColor getColorActivated() const;
    int getWidthLine() const;
    int getSizeNode() const;

public slots:
    void setData(const QVariant& AData);
    void setColorNormal(const QColor& AColorNormal);
    void setColorActivated(const QColor& AColorActivated);
    void setWidthLine(const int widthLine);
    void setSizeNode(const int sizeNode);

signals:
    void selectNode(QString title, QString text);
    void dataChanged(QVariant data);
    void colorNormalChanged(QColor colorNormal);
    void colorActivatedChanged(QColor colorActivated);
    void widthLineChanged(int widthLine);
    void sizeNodeChanged(int sizeNode);
    void testChanged(QObject* test);
};

#endif // DAPCHAINNODENETWORKEXPLORER_H

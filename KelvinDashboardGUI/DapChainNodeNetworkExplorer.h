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

enum DapNodeStatus {
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
    Q_ENUM(DapNodeStatus)
    Q_PROPERTY(QColor colorSelect READ getColorSelect WRITE setColorSelect NOTIFY colorSelectChanged)
    Q_PROPERTY(QColor colorNormal READ getColorNormal WRITE setColorNormal NOTIFY colorNormalChanged)
    Q_PROPERTY(QColor colorFocused READ getColorFocused WRITE setColorFocused NOTIFY colorFocusedChanged)
    Q_PROPERTY(QColor colorOnline READ getColorOnline WRITE setColorOnline NOTIFY colorOnlineChanged)
    Q_PROPERTY(QColor colorOffline READ getColorOffline WRITE setColorOffline NOTIFY colorOfflineChanged)
    Q_PROPERTY(int widthLine READ getWidthLine WRITE setWidthLine NOTIFY widthLineChanged)
    Q_PROPERTY(int sizeNode READ getSizeNode WRITE setSizeNode NOTIFY sizeNodeChanged)
    Q_PROPERTY(DapChainNodeNetworkModel* model READ getModel WRITE setModel NOTIFY modelChanged)

private:
    QString m_currentSelectedNode;
    DapChainNodeNetworkModel* m_model;
    QMap<QString /*Address*/, DapNodeData /*Data*/> m_nodeMap;

    QColor m_colorOnline;
    QColor m_colorOffline;
    QColor m_colorSelect;
    QColor m_colorNormal;
    QColor m_colorFocused;
    int m_widthLine;
    int m_sizeNode;

protected:
    void mousePressEvent(QMouseEvent* event);
    void wheelEvent(QWheelEvent* event);
    void hoverMoveEvent(QHoverEvent* event);

public:
    explicit DapChainNodeNetworkExplorer(QQuickItem *parent = nullptr);
    void paint(QPainter* painter);
    DapNodeStatus getNodeStatus() const;
    QColor getColorOnline() const;
    QColor getColorOffline() const;
    QColor getColorSelect() const;
    QColor getColorNormal() const;
    QColor getColorFocused() const;
    int getWidthLine() const;
    int getSizeNode() const;

    DapChainNodeNetworkModel* getModel() const;

    Q_INVOKABLE void setCurrentNodeStatus(const DapNodeStatus& aNodeStatus);
    Q_INVOKABLE int getSelectedNodePosX() const;
    Q_INVOKABLE int getSelectedNodePosY() const;
    Q_INVOKABLE QString getSelectedNodeAddress() const;
    Q_INVOKABLE QString getSelectedNodeAlias() const;
    Q_INVOKABLE QString getSelectedNodeIpv4() const;

public slots:
    void setColorSelect(const QColor& aColorSelect);
    void setColorNormal(const QColor& aColorNormal);
    void setColorFocused(const QColor& aColorActivated);
    void setColorOnline(const QColor& aColorOnline);
    void setColorOffline(const QColor& aColorOffline);
    void setWidthLine(const int widthLine);
    void setSizeNode(const int sizeNode);

    void setModel(DapChainNodeNetworkModel* aModel);

private slots:
    void proccessCreateGraph();

signals:
    void colorSelectChanged(QColor colorSelect);
    void colorNormalChanged(QColor colorNormal);
    void colorFocusedChanged(QColor colorActivated);
    void colorOnlineChanged(QColor colorOnline);
    void colorOfflineChanged(QColor colorOffline);
    void widthLineChanged(int widthLine);
    void sizeNodeChanged(int sizeNode);
    void modelChanged(DapChainNodeNetworkModel* model);

    void selectNode(QString address);
    void selectNodeChanged();
};

#endif // DAPCHAINNODENETWORKEXPLORER_H

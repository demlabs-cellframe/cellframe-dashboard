#ifndef DAPCHAINNODENETWORKEXPLORER_H
#define DAPCHAINNODENETWORKEXPLORER_H

#include <QQuickPaintedItem>
#include <QPainter>
#include <QVariant>
#include <QToolTip>

#include "DapChainNodeNetworkModel.h"
#include "DapNodeType.h"

/*!
 * \brief The DapChainNodeNetworkExplorer class
 * \details Class paiting DapKelvin map
 * \warning To use this class it requers to send DapChainNodeNetworkModel model to slot setModel()
 * \author Tagiltsev Evgenii
 */
class DapChainNodeNetworkExplorer : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor colorSelect READ getColorSelect WRITE setColorSelect NOTIFY colorSelectChanged)
    Q_PROPERTY(QColor colorNormal READ getColorNormal WRITE setColorNormal NOTIFY colorNormalChanged)
    Q_PROPERTY(QColor colorFocused READ getColorFocused WRITE setColorFocused NOTIFY colorFocusedChanged)
    Q_PROPERTY(QColor colorOnline READ getColorOnline WRITE setColorOnline NOTIFY colorOnlineChanged)
    Q_PROPERTY(QColor colorOffline READ getColorOffline WRITE setColorOffline NOTIFY colorOfflineChanged)
    Q_PROPERTY(int widthLine READ getWidthLine WRITE setWidthLine NOTIFY widthLineChanged)
    Q_PROPERTY(int sizeNode READ getSizeNode WRITE setSizeNode NOTIFY sizeNodeChanged)
    Q_PROPERTY(DapChainNodeNetworkModel* model READ getModel WRITE setModel NOTIFY modelChanged)

public:
    enum DapNodeState {
        Normal,
        Focused,
        Selected
    };

    struct DapNodeGui {
        DapNodeState State;
        QRect Rect;
    };

private:
    DapChainNodeNetworkModel* m_model;
    QMap<QString /*Address*/, DapNodeGui /*NodeDataGui*/> m_nodeMap;                //  node map for gui
    QPair<QString /*Address*/, DapNodeGui* /*NodeDataGui*/> m_currentSelectedNode;  //  selected node

    QColor m_colorOnline;       //  Property color for online status
    QColor m_colorOffline;      //  Property color for offline status
    QColor m_colorSelect;       //  Property color for selected state
    QColor m_colorNormal;       //  Property color for normal state
    QColor m_colorFocused;      //  Property color for focused state
    int m_widthLine;            //  Property width line for borders
    int m_sizeNode;             //  Property lenght of square's side

protected:
    void mousePressEvent(QMouseEvent* event);
    void wheelEvent(QWheelEvent* event);
    void hoverMoveEvent(QHoverEvent* event);

public:
    explicit DapChainNodeNetworkExplorer(QQuickItem *parent = nullptr);
    void paint(QPainter* painter);                                      //!<    Overload method for paiting

    QColor getColorOnline() const;                                      //!<    Get color for online nodes
    QColor getColorOffline() const;                                     //!<    Get color for offline nodes
    QColor getColorSelect() const;                                      //!<    Get color for selected node
    QColor getColorNormal() const;                                      //!<    Get color for normal state for node
    QColor getColorFocused() const;                                     //!<    Get color for focused node
    int getWidthLine() const;                                           //!<    Get line width for borders
    int getSizeNode() const;                                            //!<    Get lenght of square's side

    DapChainNodeNetworkModel* getModel() const;                         //!<    Get model

    Q_INVOKABLE int getSelectedNodePosX() const;                        //!<    Get X position for selected node
    Q_INVOKABLE int getSelectedNodePosY() const;                        //!<    Get Y position for selected node
    Q_INVOKABLE QString getSelectedNodeAddress() const;                 //!<    Get address for selected node
    Q_INVOKABLE QString getSelectedNodeAlias() const;                   //!<    Get alias for selected node
    Q_INVOKABLE QString getSelectedNodeIpv4() const;                    //!<    Get Ipv4 address for selected node
    Q_INVOKABLE QString getAddressByPos(const int aX, const int aY);    //!<    Find node address by coordinate

public slots:
    void setColorSelect(const QColor& aColorSelect);                    //!<    Set color for selected node
    void setColorNormal(const QColor& aColorNormal);                    //!<    Set color for normal state for node
    void setColorFocused(const QColor& aColorActivated);                //!<    Set color for focused node
    void setColorOnline(const QColor& aColorOnline);                    //!<    Set color for online nodes
    void setColorOffline(const QColor& aColorOffline);                  //!<    Set color for offline nodes
    void setWidthLine(const int widthLine);                             //!<    Set line width for borders
    void setSizeNode(const int sizeNode);                               //!<    Set lenght of square's side

    void setModel(DapChainNodeNetworkModel* aModel);                    //!<    Set model

private slots:
    void proccessCreateGraph();                                         //  Slot for repainting map if it was changed

signals:
    void colorSelectChanged(QColor colorSelect);
    void colorNormalChanged(QColor colorNormal);
    void colorFocusedChanged(QColor colorActivated);
    void colorOnlineChanged(QColor colorOnline);
    void colorOfflineChanged(QColor colorOffline);
    void widthLineChanged(int widthLine);
    void sizeNodeChanged(int sizeNode);
    void modelChanged(DapChainNodeNetworkModel* model);

    void selectNode();                                                  //!<    Signal selected node
    void selectNodeChanged();                                           //!<    Signal deselect node
};

#endif // DAPCHAINNODENETWORKEXPLORER_H

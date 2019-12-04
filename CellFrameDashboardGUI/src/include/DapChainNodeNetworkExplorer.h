#ifndef DAPCHAINNODENETWORKEXPLORER_H
#define DAPCHAINNODENETWORKEXPLORER_H

#include <QQuickPaintedItem>
#include <QPainter>
#include <QVariant>
#include <QToolTip>

#include "DapChainNodeNetworkModel.h"
#include "DapNodeType.h"

/// The DapChainNodeNetworkExplorer class
/// details Class painting DapCellFrame map
/// @warning To use this class it requers to send DapChainNodeNetworkModel model to slot setModel()
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
    /**
     * @brief The DapNodeState enum
     * The values are used to display state of nodes
     */
    enum DapNodeState {
        /// Normal
        Normal,
        /// Focused
        Focused,
        /// Selected
        Selected
    };

    /**
     * @brief The DapNodeGui struct
     * Structure which has state of node and size of area node
     */
    struct DapNodeGui {
        /// State of node
        DapNodeState State;
        /// Graphic area node
        QRect Rect;
    };

private:
    /// Model for Network Explorer
    DapChainNodeNetworkModel* m_model;
    /// node map for gui
    QMap<QString /*Address*/, DapNodeGui /*NodeDataGui*/> m_nodeMap;
    ///  selected node
    QPair<QString /*Address*/, DapNodeGui* /*NodeDataGui*/> m_currentSelectedNode;

    /// Color online state
    QColor m_colorOnline;
    /// Color offline state
    QColor m_colorOffline;
    /// Color selected state
    QColor m_colorSelect;
    /// Color normal state
    QColor m_colorNormal;
    /// Color focused state
    QColor m_colorFocused;
    /// Width of line
    int m_widthLine;
    /// Size of node
    int m_sizeNode;

protected:
    /// Event occurs when moused pressed
    /// @param event Mouse event
    void mousePressEvent(QMouseEvent* event);
    /// Event occurs when wheel moves
    /// @param event Wheel event
    void wheelEvent(QWheelEvent* event);
    /// Event occurs when mouse hover under item
    /// @param event Hover move
    void hoverMoveEvent(QHoverEvent* event);

public:
    /// Standard constructor
    explicit DapChainNodeNetworkExplorer(QQuickItem *parent = nullptr);
    /// Overload method for paiting
    void paint(QPainter* painter);

    /// Get color for online nodes
    /// @return color of online nodes
    QColor getColorOnline() const;
    /// Get color for offline nodes
    /// @return color of offline nodes
    QColor getColorOffline() const;
    /// Get color for selected node
    /// @return color of seletected node
    QColor getColorSelect() const;
    /// Get color for normal state for node
    /// @return color of normal state
    QColor getColorNormal() const;
    /// Get color for focused node
    /// @return color of focused node
    QColor getColorFocused() const;
    /// Get line width for borders
    /// @return width of line
    int getWidthLine() const;
    /// Get lenght of square's side
    /// @return diameter of node element
    int getSizeNode() const;

    /// Get model
    /// @return model for network explorer
    DapChainNodeNetworkModel* getModel() const;

    /// Get X position for selected node
    /// @return X position of selected node
    Q_INVOKABLE int getSelectedNodePosX() const;
    /// Get Y position for selected node
    /// @return Y position of selected node
    Q_INVOKABLE int getSelectedNodePosY() const;
    /// Get address for selected node
    /// @return address of selected node
    Q_INVOKABLE QString getSelectedNodeAddress() const;
    /// Get alias for selected node
    /// @return alias of selected node
    Q_INVOKABLE QString getSelectedNodeAlias() const;
    /// Get Ipv4 address for selected node
    /// @return Ipv4 address of selected node
    Q_INVOKABLE QString getSelectedNodeIpv4() const;
    /// Find node address by coordinate
    /// @param X position
    /// @param Y position
    /// @return address of node
    Q_INVOKABLE QString getAddressByPos(const int aX, const int aY);

public slots:
    /// Set color for selected node
    /// @param color for selected node
    void setColorSelect(const QColor& aColorSelect);
    /// Set color for normal state for node
    /// @param color for normal state of node
    void setColorNormal(const QColor& aColorNormal);
    /// Set color for focused node
    /// @param color for focused node
    void setColorFocused(const QColor& aColorActivated);
    /// Set color for online nodes
    /// @param color for online nodes
    void setColorOnline(const QColor& aColorOnline);
    /// Set color for offline nodes
    /// @param color offline nodes
    void setColorOffline(const QColor& aColorOffline);
    /// Set line width for borders
    /// @param width of line
    void setWidthLine(const int widthLine);
    /// Set lenght of square's side
    /// @param diameter of node element
    void setSizeNode(const int sizeNode);

    /// Set model
    /// @param model for explorer
    void setModel(DapChainNodeNetworkModel* aModel);

private slots:
    /// Create graph
    void proccessCreateGraph();

signals:
    /// Signals emitted when select color was changed
    /// @param colorSelect Color for select state
    void colorSelectChanged(QColor colorSelect);
    /// Signals emitted when normal state color was changed
    /// @param colorNormal Color for normal state
    void colorNormalChanged(QColor colorNormal);
    /// Signals emitted when focused state color was changed
    /// @param colorActivated Color for focused state
    void colorFocusedChanged(QColor colorActivated);
    /// Signals emitted when online state color was changed
    /// @param colorOnline Color for online state
    void colorOnlineChanged(QColor colorOnline);
    /// Signals emitted when offline state color was changed
    /// @param colorOffline Color for offline state
    void colorOfflineChanged(QColor colorOffline);
    /// Signals emitted when width line was changed
    /// @param widthLine Width of line
    void widthLineChanged(int widthLine);
    /// Signals emitted when size node was changed
    /// @param sizeNode Size of node
    void sizeNodeChanged(int sizeNode);
    /// Signals emitted when model was changed
    /// @param model New model for Network Explorer
    void modelChanged(DapChainNodeNetworkModel* model);

    /// Signal selected node
    /// @param status current selected node. It is true
    /// if current node was selected
    void selectNode(bool isCurrentNode);
    /// Signal skip selected node to normal state
    void selectNodeChanged();
};

#endif // DAPCHAINNODENETWORKEXPLORER_H

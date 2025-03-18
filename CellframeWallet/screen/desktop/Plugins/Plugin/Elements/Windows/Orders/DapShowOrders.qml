import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0

Item {
    anchors.fill: parent

    Rectangle
    {
        id: gridViewOrder
        property int halfMargin: margin * 0.5
        property int margin: 14 
        anchors.fill: parent
        color: "#363A42"
        radius: 16*pt
        visible: true
        Rectangle
        {
            anchors.fill: parent
            color: gridViewOrder.color
            radius: gridViewOrder.radius
            layer.enabled: true
            layer.effect: OpacityMask
            {
                maskSource: Rectangle
                {
                    width: gridViewOrder.width
                    height: gridViewOrder.height
                    radius: gridViewOrder.radius
                }
            }

            Text {
                id: textMyVPNOrders
                x: 18 
                y: 10 
                font.family: "Quicksand"
                font.pixelSize: 14
                font.bold: true
                color: "#ffffff"
                text: qsTr("Orders")
            }

            DapOrdersGrid {
                id: vpnOrdersView

                anchors { left: parent.left; top: textMyVPNOrders.bottom; right: parent.right; bottom: parent.bottom }
                anchors.leftMargin: 52 
                anchors.topMargin: 10 
                delegateMargin: gridViewOrder.halfMargin
            }
        }
    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: gridViewOrder
        horizontalOffset: 2
        verticalOffset: 2
        radius: 10
        samples: 10
        cached: true
        color: "#2A2C33"
        source: gridViewOrder
        visible: gridViewOrder.visible
    }
    InnerShadow {
        anchors.fill: gridViewOrder
        horizontalOffset: -1
        verticalOffset: -1
        radius: 0
        samples: 10
        cached: true
        color: "#4C4B5A"
        source: topLeftSadow
        visible: gridViewOrder.visible
    }
}

import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0

Rectangle {
    anchors.fill: parent
    color: "#2E3138"

    Rectangle
    {
        id: gridViewOrder
        property int halfMargin: margin * 0.5
        property int margin: 14 * pt
        anchors.fill: parent
        color: "#363A42"
        radius: 16*pt
        visible: true

        Text {
            id: textMyVPNOrders
            x: 18 * pt
            y: 10 * pt
            font.family: "Quicksand"
            font.pixelSize: 14
            font.bold: true
            color: currTheme.textColor
            text: qsTr("Orders")
        }

        DapOrdersGrid {
            id: vpnOrdersView

            anchors { left: parent.left; top: textMyVPNOrders.bottom; right: parent.right; bottom: parent.bottom }
            anchors.leftMargin: 27 * pt
            anchors.topMargin: 10 * pt
            delegateMargin: gridViewOrder.halfMargin
        }
    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: gridViewOrder
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: gridViewOrder
        visible: gridViewOrder.visible
    }
    InnerShadow {
        anchors.fill: gridViewOrder
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
        color: "#4C4B5A"
        source: topLeftSadow
        visible: gridViewOrder.visible
    }
}

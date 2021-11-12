import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"
import "../../desktop/VPNService_New"

DapAbstractScreen {
    id:dapVPNCientScreen


    property alias dapAddOrderButton: addOrderButton
    property alias dapOrderCreateFrame: orderCreateFrame
    property alias dapGridViewOrder: gridViewOrder
    property alias dapFrameTitleCreateOrder: frameTitleCreateOrder
    property alias dapGridViewFrame: vpnOrdersView

    anchors
    {
        top: parent.top
        topMargin: 24 * pt
        right: parent.right
        rightMargin: 44 * pt
        left: parent.left
        leftMargin: 24 * pt
        bottom: parent.bottom
        bottomMargin: 20 * pt
    }

    Rectangle
    {
        id: orderCreateFrame
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        Column
        {
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle
            {
                height: 82.79 * pt
                width: parent.width
                color: "transparent"
            }

            Image
            {
                id: iconCreateOrder
                sourceSize: Qt.size(500 * pt, 261 * pt)
                source: "qrc:/resources/illustrations/illustration_vpn-service.svg"
//                    width: 500 * pt
//                    height: 300 * pt
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: 45 * pt
                width: parent.width
                color: "transparent"
            }

            Text
            {
                id: titleTextOrderCreate
                font.family: "Quiksand"
                font.pixelSize: 26 * pt
                color: currTheme.textColor
                text: qsTr("Create your first VPN order")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: 21 * pt
                width: parent.width
                color: "transparent"
            }
            DapButton
            {
                id: addOrderButton
                implicitWidth: 180 * pt
                implicitHeight: 36 * pt
                radius: currTheme.radiusButton
                anchors.horizontalCenter: parent.horizontalCenter
                textButton: "New VPN order"
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                horizontalAligmentText:Qt.AlignCenter
                colorTextButton: "#FFFFFF"

            }
            Rectangle
            {
                height: Layout.fillHeight
                width: parent.width
            }
        }
    }
    Rectangle
    {
        id: frameTitleCreateOrder
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
//        anchors.verticalCenter: parent.verticalCenter
        Text
        {
//            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Quiksand"
            font.pixelSize: 26 * pt
            color: currTheme.textColor
            text: qsTr("Creating VPN order in process...")
        }
    }

    Rectangle
    {
        id: gridViewOrder
        property int halfMargin: margin * 0.5
        property int margin: 14 * pt
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: 16*pt
        visible: false

        Text {
            id: textMyVPNOrders
            x: gridViewOrder.halfMargin
            y: gridViewOrder.halfMargin
            font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14;
            color: currTheme.textColor
        }

        DapVPNOrdersGridView {
            id: vpnOrdersView

            anchors { left: parent.left; top: textMyVPNOrders.bottom; right: parent.right; bottom: parent.bottom }
            anchors.leftMargin: 27 * pt
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

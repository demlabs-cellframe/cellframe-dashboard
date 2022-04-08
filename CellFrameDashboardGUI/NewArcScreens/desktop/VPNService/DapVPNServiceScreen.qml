import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0
import QtQuick.Controls 2.2
import "qrc:/widgets"
import "../../"
import "Parts"
//import "../../desktop/VPNService_New"

Page {
    id:dapVPNCientScreen


    property alias dapAddOrderButton: addOrderButton
    property alias dapOrderCreateFrame: orderCreateFrame
    property alias dapGridViewOrder: gridViewOrder
    property alias dapFrameTitleCreateOrder: frameTitleCreateOrder
    property alias dapGridViewFrame: vpnOrdersView

//    anchors
//    {
//        top: parent.top
//        topMargin: 24 * pt
//        right: parent.right
//        rightMargin: 44 * pt
//        left: parent.left
//        leftMargin: 24 * pt
//        bottom: parent.bottom
//        bottomMargin: 20 * pt
//    }
    background: Rectangle
    {
        color: currTheme.backgroundMainScreen
    }

//    Rectangle
//    {
//        id: orderCreateFrame
//        anchors.fill: parent
//        anchors.horizontalCenter: parent.horizontalCenter
//        color: "transparent"
    DapRectangleLitAndShaded
    {
        id: orderCreateFrame
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter

        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:

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
                fontButton: _dapQuicksandFonts.dapFont.regular16
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

    DapRectangleLitAndShaded
    {
        id: frameTitleCreateOrder
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter

        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight
        visible: false

        contentData:
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



    DapRectangleLitAndShaded
    {
        property int halfMargin: margin * 0.5
        property int margin: 14 * pt

        id: gridViewOrder
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter

        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight
        visible: false

        contentData:
        Item {
            anchors.fill: parent

            Text {
                id: textMyVPNOrders
                x: gridViewOrder.halfMargin
                y: gridViewOrder.halfMargin
                font:  _dapQuicksandFonts.dapFont.bold14;
                color: currTheme.textColor
            }

            DapVPNOrdersGridView {
                id: vpnOrdersView

                anchors { left: parent.left; top: textMyVPNOrders.bottom; right: parent.right; bottom: parent.bottom }
                anchors.leftMargin: 27 * pt
                delegateMargin: gridViewOrder.halfMargin
            }
        }
    }
}

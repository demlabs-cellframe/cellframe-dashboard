import QtQuick 2.4
import QtQuick.Layouts 1.2
import "qrc:/widgets"
import "../../"
import "../../desktop/VPNService_New"

DapAbstractScreen {
    id:dapVPNCientScreen

    dapFrame.color: "#FFFFFF"
    anchors.fill: parent
    anchors.leftMargin: 24 * pt
    anchors.rightMargin: 24 * pt

    property alias dapAddOrderButton: addOrderButton
    property alias dapOrderCreateFrame: orderCreateFrame
    property alias dapGridViewOrder: gridViewOrder
    property alias dapFrameTitleCreateOrder: frameTitleCreateOrder
    property alias dapGridViewFrame: vpnOrdersView

    Rectangle
    {
        id: orderCreateFrame
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        Column
        {
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle
            {
                height: 82.79 * pt
                width: parent.width
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
            }
            Text
            {
                id: titleTextOrderCreate
                font.family: "Quiksand"
                font.pixelSize: 26 * pt
                color: "#070023"
                text: qsTr("Create your first VPN order")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: 21 * pt
                width: parent.width
            }
            DapButton
            {
                id: addOrderButton

                implicitWidth: 180 * pt
                implicitHeight: 36 * pt
                radius: 4 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                heightImageButton: 21 * pt
                widthImageButton: 22 * pt
                textButton: "New VPN order"
//                    normalImageButton: "qrc:/resources/icons/new-wallet_icon_dark.svg"
//                    hoverImageButton: "qrc:/resources/icons/new-wallet_icon_dark_hover.svg"
                indentImageLeftButton: 41 * pt
                colorBackgroundNormal: "#070023"
                colorBackgroundHover: "#D51F5D"
                colorButtonTextNormal: "#FFFFFF"
                colorButtonTextHover: "#FFFFFF"
                indentTextRight: 37 * pt
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                borderColorButton: "#000000"
                borderWidthButton: 0
                horizontalAligmentText:Qt.AlignRight
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
//        anchors.verticalCenter: parent.verticalCenter
        Text
        {
//            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Quiksand"
            font.pixelSize: 26 * pt
            color: "#070023"
            text: qsTr("Creating VPN order in process...")
        }
    }

    Item
    {
        id: gridViewOrder
        property int halfMargin: margin * 0.5
        property int margin: 14 * pt
        anchors.fill: parent
        anchors.margins: halfMargin
        visible: false

        Text {
            id: textMyVPNOrders
            x: gridViewOrder.halfMargin
            y: gridViewOrder.halfMargin
            font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14;
            color: "#3E3853"
//            text: qsTr("My VPN orders")
        }

        DapVPNOrdersGridView {
            id: vpnOrdersView

            anchors { left: parent.left; top: textMyVPNOrders.bottom; right: parent.right; bottom: parent.bottom }
            delegateMargin: gridViewOrder.halfMargin
        }

//        Connections
//        {
//            target: vpnOrdersView
//            onOrderDetailsShow:
//            {
//                console.log("Index " + index)
//            }
//        }
    }
}

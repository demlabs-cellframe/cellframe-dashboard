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

    background: Rectangle
    {
        color: currTheme.backgroundMainScreen
    }

    Rectangle
    {
        id: orderCreateFrame
        anchors.fill: parent
//        anchors.topMargin: 41 * pt
        anchors.leftMargin: 301 * pt
        anchors.rightMargin: 281 * pt
        anchors.bottomMargin: 131 * pt
        anchors.topMargin: 50

        color: "transparent"


        Column
        {
            y: 50 * pt
            x: 40 * pt
            anchors.horizontalCenter: parent.horizontalCenter

            Item
            {
                width: iconCreateWallet.implicitWidth
                height: iconCreateWallet.implicitHeight

                Image
                {
                    anchors.fill: parent
                    id: iconCreateWallet
                    source: "qrc:/resources/illustrations/illustration_vpn-service.svg"
                    sourceSize.width: 500 * pt
                    sourceSize.height: 261 * pt
                    fillMode: Image.PreserveAspectFit
                }
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Item
            {
                height: 30 * pt
                width: parent.width
            }

            Text
            {
                id: titleTextOrderCreate
                font: mainFont.dapFont.medium26
                color: currTheme.textColor
                text: qsTr("Create your first VPN order")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Item
            {
                height: 21 * pt
                width: parent.width
            }
            DapButton
            {
                enabled: false
                id: addOrderButton


                implicitWidth: 165 * pt
                implicitHeight: 36 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                textButton: qsTr("New VPN order")
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText:Qt.AlignCenter
            }
            Item
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
                font:  mainFont.dapFont.bold14;
                color: currTheme.textColor
            }

            DapVPNOrdersGridView {
                id: vpnOrdersView

                anchors { left: parent.left; top: textMyVPNOrders.bottom; right: parent.right; bottom: parent.bottom }
                anchors.leftMargin: 27 * pt
                delegateMargin: gridViewOrder.halfMargin

                Component.onCompleted: vpnOrdersController.retryConnection()
            }



            Connections
            {
                target: vpnOrdersController

                onVpnOrdersReceived:
                {
                    var json = JSON.parse(doc)
                    vpnOrdersView.model = json
                    vpnOrdersView.visible = true
                    connectingText.visible = false
                    errorItem.visible = false
                }

                onConnectionError:
                {
                    vpnOrdersView.visible = false
                    connectingText.visible = false
                    errorItem.visible = true
                }
            }

            Item
            {
                id: connectingText
                anchors { left: parent.left; top: textMyVPNOrders.bottom; right: parent.right; bottom: parent.bottom }
                anchors.leftMargin: 27 * pt
                Text
                {
                    anchors.centerIn: parent
                    color: currTheme.textColor
                    font: mainFont.dapFont.medium16
                    text: "Connecting..."
                }
            }

            Item
            {
                id: errorItem
                anchors { left: parent.left; top: textMyVPNOrders.bottom; right: parent.right; bottom: parent.bottom }
                anchors.leftMargin: 27 * pt
                visible: false

                Text
                {
                    id: errorText
                    anchors.centerIn: parent
                    color: currTheme.textColor
                    font: mainFont.dapFont.medium16
                    text: "Connection error"
                }

                DapButton {
                    textButton: qsTr("Retry")

                    Layout.preferredHeight: 36 * pt

                    x: parent.width * 0.5 - width * 0.5
                    y: errorText.y + errorText.height + 16 * pt
                    implicitHeight: 36 * pt
                    implicitWidth: 100 * pt

                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.regular16

                    onClicked:
                    {
                        vpnOrdersController.retryConnection()
                        connectingText.visible = true
                        errorItem.visible = false
                    }
                }
            }
        }
    }
}

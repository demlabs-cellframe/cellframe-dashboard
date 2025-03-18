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
        color: currTheme.mainBackground
    }

    Rectangle
    {
        id: orderCreateFrame
        anchors.fill: parent
//        anchors.topMargin: 41 
        anchors.leftMargin: 301 
        anchors.rightMargin: 281 
        anchors.bottomMargin: 131 
        anchors.topMargin: 50

        color: "transparent"


        Column
        {
            y: 50 
            x: 40 
            anchors.horizontalCenter: parent.horizontalCenter

            Item
            {
                width: iconCreateWallet.implicitWidth
                height: iconCreateWallet.implicitHeight

                Image
                {
                    anchors.fill: parent
                    id: iconCreateWallet
                    source: "qrc:/Resources/" + pathTheme + "/Illustratons/illustration_vpn-service.svg"
                    sourceSize.width: 500 
                    sourceSize.height: 261 
                    fillMode: Image.PreserveAspectFit
                }
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Item
            {
                height: 30 
                width: parent.width
            }

            Text
            {
                id: titleTextOrderCreate
                font: mainFont.dapFont.medium26
                color: currTheme.white
                text: qsTr("Create your first VPN order")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Item
            {
                height: 21 
                width: parent.width
            }
            DapButton
            {
                enabled: false
                id: addOrderButton


                implicitWidth: 165 
                implicitHeight: 36 
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

        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
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
            font.pixelSize: 26 
            color: currTheme.white
            text: qsTr("Creating VPN order in process...")
        }
    }



    DapRectangleLitAndShaded
    {
        property int halfMargin: margin * 0.5
        property int margin: 14 

        id: gridViewOrder
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter

        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
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
                color: currTheme.white
            }

            DapVPNOrdersGridView {
                id: vpnOrdersView

                anchors { left: parent.left; top: textMyVPNOrders.bottom; right: parent.right; bottom: parent.bottom }
                anchors.leftMargin: 27 
                delegateMargin: gridViewOrder.halfMargin
            }
        }
    }
}

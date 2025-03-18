import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0

Item {
    anchors.fill: parent
    id:controlWallets

    property var dapWallets: []

    Rectangle
    {
        id: viewWallets
        anchors.fill: parent
        color: "#363A42"
        radius: 16 

        Rectangle
        {
            anchors.fill: parent
            color: viewWallets.color
            radius: viewWallets.radius
            layer.enabled: true
            layer.effect: OpacityMask
            {
                maskSource: Rectangle
                {
                    width: viewWallets.width
                    height: viewWallets.height
                    radius: viewWallets.radius
                }
            }

            // Header
            Item
            {
                id: waalletsHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 38 

                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 18 
                    anchors.topMargin: 10 
                    anchors.bottomMargin: 10 
                    verticalAlignment: Qt.AlignVCenter
                    text: qsTr("Wallets")
                    font.family: "Quicksand"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#ffffff"
                }
            }

            ListView
            {
                id: listViewWallets
                anchors.top: waalletsHeader.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                clip: true

                model: ListModel{
                    id: dapModelWallets
                }

                delegate: DapWalletsComponent { }
            }
        }
    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: viewWallets
        horizontalOffset: 2
        verticalOffset: 2
        radius: 10
        samples: 10
        cached: true
        color: "#2A2C33"
        source: viewWallets
        visible: viewWallets.visible
    }
    InnerShadow {
        anchors.fill: viewWallets
        horizontalOffset: -1
        verticalOffset: -1
        radius: 0
        samples: 10
        cached: true
        color: "#4C4B5A"
        source: topLeftSadow
        visible: viewWallets.visible
    }

    Connections
    {
        target: dapServiceController
        onWalletsReceived:
        {
            var jsonDocument = JSON.parse(walletList)

            if(!jsonDocument.length)
            {
                dapModelWallets.clear()
                return
            }
            dapModelWallets.clear()
            dapModelWallets.append(jsonDocument)
        }
    }
}

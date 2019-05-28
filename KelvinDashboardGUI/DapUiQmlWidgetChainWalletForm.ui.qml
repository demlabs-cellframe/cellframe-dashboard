import QtQuick 2.11
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2

Page {
    id: dapUiQmlWidgetChainWallet

    title: qsTr("Wallet")

    property alias listViewWallet: listViewWallet
    property alias save: save
    property alias dialogAddWallet: dialogAddWallet

    ListView {
        id: listViewWallet
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        model: dapChainWalletsModel

       delegate: Item {
            width: parent.width
            height: 150

            Rectangle {
                id: rectangleWallet
                anchors.fill: parent
               color: "lightgray"
                opacity: 0.5
                radius: 5
                border.color: "gray"
                clip: true

                Rectangle
                {
                    id: iconWallet
                    height: 140
                    width: 140
                    border.color: "gray"
                    anchors.left: parent.left
                   anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 3.5

                    Image
                    {
                        anchors.fill: parent
                        source: "qrc:/Resources/Icons/add.png"
                    }
                }

               Column
                {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: iconWallet.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    spacing: 5

                    Text {
                        id: nameWallet
                        text: name
                        bottomPadding: 15
                        font.bold: true
                        font.pixelSize: 20
                    }

                    Text {
                        id: lableAddress
                       text: "Address:"
                        font.pixelSize: 18
                        color: "gray"
                    }

                    TextEdit {
                        id: addressWallet
                        text:  address
                        width: parent.width
                        font.pixelSize: 16
                        wrapMode: Text.Wrap
                        selectByMouse: true
   //                    clip: true
    //                    elide: Text.ElideRight
                    }
                }
            }
        }


    }
    DapUiQmlScreenDialogAddWallet {
        id: dialogAddWallet
            }

    RoundButton {
            id: save
           text: qsTr("+")
           highlighted: true
           anchors.margins: 10
           anchors.right: parent.right
           anchors.bottom: parent.bottom
    }
}


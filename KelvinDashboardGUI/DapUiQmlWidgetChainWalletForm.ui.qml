import QtQuick 2.11
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2

Page {
    id: dapUiQmlWidgetChainWallet

    title: qsTr("Wallet")

    property alias listViewWallet: listViewWallet
    property alias save: save
    property alias dialogAddWallet: dialogAddWallet

    Rectangle
    {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "#353841"
        width: 100
        ListView {
            id: listViewWallet
            anchors.fill: parent
            keyNavigationEnabled: true
            model: dapChainWalletsModel

           delegate: Item {
                width: parent.width
                height: 100

                   Column
                    {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            id: nameWallet
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr(name)
                            font.pixelSize: 14
                            color: "#BBBEBF"
                            font.family: "Roboto"
                        }

                        Text {
                            id: lableBalance
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr(balance)
                            font.pixelSize: 18
                            color: "#BBBEBF"
                            font.family: "Roboto"
                        }

                        Text {
                            id: lableCurrency
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Dollars"
                            font.pixelSize: 14
                            color: "#BBBEBF"
                            font.weight: Font.Light
                            font.family: "Roboto"
                        }

//                        TextEdit {
//                            id: addressWallet
//                            text:  address
//                            width: parent.width
//                            font.pixelSize: 16
//                            wrapMode: Text.Wrap
//                            selectByMouse: true
//       //                    clip: true
//        //                    elide: Text.ElideRight
//                        }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: listViewWallet.currentIndex = index
                }
            }

           focus: true
        }
    }


    DapUiQmlScreenDialogAddWallet {
        id: dialogAddWallet
            }

    RoundButton {
            id: deleteWallet
           text: qsTr("-")
           highlighted: true
           anchors.margins: 10
           anchors.right: parent.right
           anchors.bottom: save.top
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


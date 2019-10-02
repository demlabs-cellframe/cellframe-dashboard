import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle {

    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 1
        color: "#F2F2F4"

        ListModel {
            id: testModel
            ListElement {
                name: "First wallet"
                balance: "$ 3 000"
            }
            ListElement {
                name: "Second wallet"
                balance: "$ 1 500"
            }
        }

        ComboBox {
            id: comboboxWallet
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 30 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
//            model: dapChainWalletsModel
            model: testModel
            textRole: "name"

            indicator: Image {
                source: comboboxWallet.popup.visible ? "qrc:/Resources/Icons/ic_arrow_drop_up.png" : "qrc:/Resources/Icons/ic_arrow_drop_down.png"
                width: 24 * pt
                height: 24 * pt
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10 * pt
            }

            onCurrentIndexChanged: {
                fieldWalletBalance.text = testModel.get(currentIndex).balance;
            }
        }

        Label {
            id: titleWalletBalance
            anchors.top: parent.top
            anchors.left: comboboxWallet.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 40 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            verticalAlignment: Qt.AlignVCenter
            text: "Wallet balance:"
            font.family: "Regular"
            font.pixelSize: 12 * pt
            color: "#A7A7A7"
        }

        Label {
            id: fieldWalletBalance
            anchors.top: parent.top
            anchors.left: titleWalletBalance.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            verticalAlignment: Qt.AlignVCenter
            font.family: "Regular"
            font.pixelSize: 16 * pt
            color: "#797979"
        }

        Button {
            width: 130 * pt
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 10 * pt
            anchors.rightMargin: 20 * pt
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * pt

            contentItem: Rectangle {
                anchors.fill: parent
                border.color: "#B5B5B5"
                border.width: 1 * pt
                color: "transparent"

                Text {
                    anchors.fill: parent
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignRight
                    anchors.rightMargin: 20 * pt
                    font.family: "Regular"
                    color: "#505559"
                    text: qsTr("New wallet")
                }

                Image {
                    id: iconNewWallet
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * pt
                    source: "qrc:/Resources/Icons/defaul_icon.png"
                    width: 28 * pt
                    height: 28 * pt
                }
            }
        }
    }
}

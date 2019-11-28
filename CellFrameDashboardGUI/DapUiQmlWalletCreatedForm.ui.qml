import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1

DapUiQmlScreen {
//    property alias pressedCloseAddWallet: mouseAreaCloseAddWallet.pressed
//    property alias pressedDoneCreateWallet: doneCreateWalletButton.pressed

    property alias buttonDone: doneCreateWalletButton

    id: walletCreatedMenu
//    width: 400
//    height: 640
//    border.color: "#B5B5B5"
//    border.width: 1 * pt
    color: "#edeff2"

//    anchors {
//        top: parent.top
//        right: parent.right
//        bottom: parent.bottom
//    }

//    Rectangle {
//        id: newWalletArea
//        height: 36
//        color: "#edeff2"
//        anchors.right: parent.right
//        anchors.rightMargin: 1
//        anchors.left: parent.left
//        anchors.leftMargin: 1
//        anchors.top: parent.top
//        anchors.topMargin: 0

//        Button {
//            id: closeButton
//            width: 20
//            height: 20
//            anchors.leftMargin: 16
//            anchors.verticalCenterOffset: 0
//            anchors.verticalCenter: parent.verticalCenter
//            anchors.left: parent.left
//            anchors.horizontalCenter: newNameArea.Center

//            MouseArea {
//                id: mouseAreaCloseAddWallet
//                width: parent.width
//                height: parent.height
//                anchors.left: parent.left
//                anchors.leftMargin: 0
//                hoverEnabled: true
//            }

//            background: Image {
//                id: imageButton
//                source: mouseAreaCloseAddWallet.containsMouse ? "Resources/Icons/close_icon_hover.png" : "Resources/Icons/close_icon.png"
//                fillMode: Image.PreserveAspectFit
//            }
//        }
//    }

    Button {
        id: doneCreateWalletButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 189 + 24
        height: 44
        width: 130

        Text {
            id: doneCreateWalletButtonText
            text: qsTr("Done")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: doneCreateWalletButton.checked ? "#3E3853" : "#FFFFFF"
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            font.pointSize: 16
            horizontalAlignment: Text.AlignLeft
        }

        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
            color: "#3E3853"
        }


    }

    Rectangle {
        id: createWalletDescription
        color: "#edeff2"
        height: 50
        anchors.bottom: doneCreateWalletButton.top
        anchors.bottomMargin: 24 + 118 + 24
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 1 * pt
        anchors.rightMargin: 1 * pt

        Text {
            anchors.fill: parent
            text: qsTr("Wallet created\nsuccessfully")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#070023"

            font {
                pointSize: 16
                family: "Roboto"
                styleName: "Normal"
                weight: Font.Normal
            }
        }
    }
}

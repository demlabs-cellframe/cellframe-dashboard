import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1
import "../"

DapUiQmlScreen {
    property alias buttonDone: doneCreateWalletButton

    id: walletCreatedMenu
    color: "#edeff2"

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

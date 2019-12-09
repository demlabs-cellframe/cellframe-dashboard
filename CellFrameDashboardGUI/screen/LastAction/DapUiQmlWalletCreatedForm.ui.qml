import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1
import "../"

DapUiQmlScreen {
    property alias buttonDone: doneCreateWalletButton

    id: walletCreatedMenu
    color: "#F8F7FA"

    Button {
        id: doneCreateWalletButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 213 * pt
        height: 44 * pt
        width: 130 * pt

        Text {
            id: doneCreateWalletButtonText
            text: qsTr("Done")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: doneCreateWalletButton.checked ? "#3E3853" : "#FFFFFF"
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            font.pointSize: 18 * pt
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
        height: 50 * pt
        anchors.bottom: doneCreateWalletButton.top
        anchors.bottomMargin: 166 * pt
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
                pointSize: 16 * pt
                family: "Roboto"
                styleName: "Normal"
                weight: Font.Normal
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/


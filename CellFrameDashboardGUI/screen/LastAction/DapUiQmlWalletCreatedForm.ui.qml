import QtQuick 2.0
import QtQuick.Controls 2.0
import "../"
import "qrc:/"

DapUiQmlScreen {
    property alias buttonDone: doneCreateWalletButton

    id: walletCreatedMenu
    color: "#F8F7FA"


    DapButton{
        id: doneCreateWalletButton

        heightButton: 44 * pt
        widthButton: 130 * pt
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 213 * pt
        checkable: true
        textButton: qsTr("Done")
        existenceImage: false
        horizontalAligmentText: Text.AlignHCenter
        indentTextRight: 0
        fontSizeButton: 18 * pt
        colorTextButton: doneCreateWalletButton.checked ? "#3E3853" : "#FFFFFF"
        colorBackgroundButton: "#3E3853"
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

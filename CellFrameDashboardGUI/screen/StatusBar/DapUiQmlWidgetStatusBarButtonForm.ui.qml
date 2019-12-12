import QtQuick 2.0
import QtQuick.Controls 2.0

Button {
    property alias name: templateText.text
    property alias fontHeight: templateText.font.pixelSize
    property alias backgroundColor: background.color

    property int defaultHeight: 50 * pt
    property int defaultWidth: 100 * pt
    property string normalButton: "qrc:/res/icons/new-wallet_icon_dark.png"
    property string hoverButton: "qrc:/res/icons/new-wallet_icon_dark_hover.png"

    id: button
    width: defaultHeight
    height: defaultWidth

    contentItem: Rectangle {
        id: background
        anchors.fill: parent
        color: "#070023"

        Text {
            id: templateText
            anchors.fill: parent
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignRight
            anchors.rightMargin: 20
            font.family: "Roboto"
            font.weight: Font.Normal
            color: "#FFFFFF"
            text: qsTr("template")
        }

        Image {
            id: iconNewWallet
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10 * pt
            source: button.hovered ? hoverButton : normalButton
            width: 28 * pt
            height: 28 * pt
        }
    }
}

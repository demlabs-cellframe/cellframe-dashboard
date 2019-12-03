import QtQuick 2.0
import QtQuick.Controls 2.5

Button {
    property alias name: templateText.text
    property alias fontHeight: templateText.font.pixelSize
    property alias backgroundColor: background.color

    property int defaultHeight: 50 * pt
    property int defaultWidth: 100 * pt

    id: button
    width: defaultHeight
    height: defaultWidth

    contentItem: Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"

        Text {
            id: templateText
            anchors.fill: parent
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignRight
            anchors.rightMargin: 20 * pt
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
            source: "qrc:/res/icons/defaul_icon.png"
            width: 28 * pt
            height: 28 * pt
        }
    }
}

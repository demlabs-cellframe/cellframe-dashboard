import QtQuick 2.0
import QtQuick.Controls 2.5

Button {
    id: button
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
            source: "qrc:/res/icons/defaul_icon.png"
            width: 28 * pt
            height: 28 * pt
        }
    }
}

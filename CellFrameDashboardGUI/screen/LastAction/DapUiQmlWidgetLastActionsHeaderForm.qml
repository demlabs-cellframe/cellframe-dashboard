import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    height: 36 * pt
    color: "#F8F7FA"

    Text {
        anchors.fill: parent
        anchors.leftMargin: 16 * pt
        text: qsTr("Last actions")
        verticalAlignment: Qt.AlignVCenter
        font.family: fontRobotoRegular.name
        font.pixelSize: 12 * pt
        color: "#3E3853"
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#757184"
    }
}

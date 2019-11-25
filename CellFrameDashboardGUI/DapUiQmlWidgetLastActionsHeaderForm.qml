import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Rectangle {
    anchors.fill: parent
    color: "transparent"

    Text {
        anchors.fill: parent
        anchors.leftMargin: 16 * pt
        text: qsTr("Last actions")
        verticalAlignment: Qt.AlignVCenter
        font.family: fontRobotoRegular.name
        font.pixelSize: 12 * pt
        color: "#5F5F63"
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#757184"
    }
}

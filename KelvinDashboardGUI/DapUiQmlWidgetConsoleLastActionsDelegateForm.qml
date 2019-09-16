import QtQuick 2.0

Rectangle {
    color: "transparent"

    Text {
        anchors.fill: parent
        verticalAlignment: Qt.AlignVCenter
        text: lastCommand
        color: "#5F5F63"
        font.family: "Roboto Regular"
        font.pixelSize: 14 * pt
    }
}

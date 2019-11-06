import QtQuick 2.4

Rectangle {
    width: 400 * pt
    color: "#E3E2E6"
    anchors {
        top: parent.top
        right: parent.right
        bottom: parent.bottom
    }

    Rectangle {
        anchors.fill: parent
        color: "#F8F7FA"
        anchors.leftMargin: 1
    }

}

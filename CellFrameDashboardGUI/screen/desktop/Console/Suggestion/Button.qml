import QtQuick 2.0

Rectangle {
    id: buttonRoot
    property bool hovered: false

    width: childrenRect.width
    height: childrenRect.height

    signal clicked

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        onEntered: buttonRoot.hovered = true
        onExited: buttonRoot.hovered = false

        onClicked: {
            buttonRoot.clicked()
        }
    }
}

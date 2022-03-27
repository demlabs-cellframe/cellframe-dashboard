import QtQuick 2.12
import QtQuick.Controls 2.12

Page {
    title: qsTr("Second")

    background: Rectangle {
        radius: 16 * pt
        color: currTheme.backgroundElements
        border.color: "white"
    }

    Rectangle {
        id: rect
        width: 50
        height: 50
        color: "green"
        anchors.centerIn: parent
    }

    Button {
        text: qsTr("Close 2")
        anchors.top: rect.bottom
        onClicked: {
            pop()
        }
    }
}

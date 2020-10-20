import QtQuick 2.7

Rectangle {
    id: control

    property alias text: _text.text

    property bool highlight: enabled && (mouseArea.containsMouse || mouseArea.pressed)
    property int spacing: 6 * pt

    signal clicked

    color: highlight ? "#D51F5D" : "#FFFFFF"

    Rectangle {
        id: icon
        anchors.verticalCenter: control.verticalCenter
        anchors.right: _text.left
        anchors.rightMargin: control.spacing
        width: 10
        height: 10
        color: control.enabled ? control.highlight ? "#FFFFFF" :  "#453F5A" : "gray"
    }

    Text {
        id: _text

        anchors.verticalCenter: control.verticalCenter
        x: Math.floor(icon.width + control.spacing + (control.width - (width + icon.width + control.spacing)) * 0.5)
        width: Math.min(implicitWidth, control.width - icon.width - control.spacing)
        font: quicksandFonts.medium12
        color: control.enabled ? control.highlight ? "#FFFFFF" :  "#453F5A" : "gray"
        elide: Text.ElideRight
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {

        }
    }
}

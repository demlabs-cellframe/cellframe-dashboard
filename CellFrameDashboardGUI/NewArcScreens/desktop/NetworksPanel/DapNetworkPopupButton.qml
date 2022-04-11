import QtQuick 2.7

Rectangle {
    id: control

    property alias text: _text.text
    property string iconNormal
    property string iconHover

    property bool highlight: mouseArea.containsMouse
    property int spacing: 6 * pt

    signal clicked

    color: highlight ? "#D51F5D" : "#FFFFFF"

    Image {
        id: icon
        anchors.verticalCenter: control.verticalCenter
        anchors.right: _text.left
        anchors.rightMargin: control.spacing
        sourceSize: Qt.size(24 * pt, 24 * pt)
        source: control.highlight ? control.iconHover : control.iconNormal
    }

    Text {
        id: _text

        anchors.verticalCenter: control.verticalCenter
        x: Math.floor(icon.width + control.spacing + (control.width - (width + icon.width + control.spacing)) * 0.5)
        width: Math.min(implicitWidth, control.width - icon.width - control.spacing)
        font: mainFont.dapFont.medium12
        color: control.highlight ? "#FFFFFF" :  "#453F5A"
        elide: Text.ElideRight
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: control.clicked()
    }
}

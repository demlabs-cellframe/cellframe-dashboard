import QtQuick 2.7
import QtQuick.Controls 2.2

Button {
    id: control

    property color textColor: "#FFFFFF"
    property color textColorHover: "#FFFFFF"
    property color backgroundColor: "#271C4E"
    property color backgroundColorHover: "#D51F5D"
    property real backgroudRadius: 4 
    property int borderWidth: 0
    property color borderColor

    font:  mainFont.dapFont.medium14

    contentItem: Text {
        font: control.font
        elide: Text.ElideRight
        color: control.hovered ? control.textColorHover : control.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: control.text
    }

    background: Rectangle {
        border { width: control.borderWidth; color: control.borderColor }
        radius: control.backgroudRadius
        color: control.hovered ? control.backgroundColorHover : control.backgroundColor
    }
}

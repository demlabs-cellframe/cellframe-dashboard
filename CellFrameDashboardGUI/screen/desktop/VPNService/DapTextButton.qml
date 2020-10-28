import QtQuick 2.7
import QtQuick.Controls 2.2

Button {
    id: control

    property color textColor
    property color textColorHover
    property color backgroundColor
    property color backgroundColorHover
    property real backgroudRadius: 0
    property int borderWidth: 0
    property color borderColor

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

import QtQuick 2.12
import QtQuick.Controls 2.12

TextField {
    id: control
    color: currTheme.textColor
    placeholderTextColor: currTheme.placeHolderTextColor

    background: Rectangle {
        anchors.fill: parent
        color: currTheme.backgroundElements
        border.color: currTheme.borderColor
        radius: 5 
    }
}

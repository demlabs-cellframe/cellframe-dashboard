import QtQuick 2.0
import QtQuick.Layouts 1.0
import "../"

DapUiQmlScreen {
    height: 36 * pt
    color: "#FFFFFF"

    property string buttonNormal : "qrc:/res/icons/close_icon.png"
    property string buttonHovered : "qrc:/res/icons/close_icon_hover.png"
    property alias mouseArea : mouseArea
    property alias pressedClose: mouseArea.pressed

    Rectangle {
        width: 16 * pt
        height: 16 * pt
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8 * pt

        Image {
            id: buttonClose
            anchors.fill: parent
            source: buttonNormal
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true

            onEntered: buttonClose.source = buttonHovered
            onExited: buttonClose.source = buttonNormal

            onClicked: {
                rightPanel.header.pop();
                rightPanel.content.pop();
            }
        }
    }
}

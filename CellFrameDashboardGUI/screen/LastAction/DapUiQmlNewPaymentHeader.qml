import QtQuick 2.0

import QtQuick 2.0
import QtQuick.Layouts 1.0
import "../"

DapUiQmlScreen {
    height: 36 * pt
    color: "#FFFFFF"
    border.width: 1 * pt
    border.color: "#E3E2E6"

    property string closeButtonNormal : "qrc:/res/icons/close_icon.png"
    property string closeButtonHovered : "qrc:/res/icons/close_icon_hover.png"
    property string title : qsTr("New payment")
    property alias mouseArea : mouseArea
    property alias pressedClose: mouseArea.pressed

    RowLayout
    {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8 * pt
        spacing: 12 * pt

        Rectangle {
            width: 16 * pt
            height: 16 * pt
            color: "transparent"

            Image {
                id: buttonClose
                anchors.fill: parent
                source: closeButtonNormal
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: buttonClose.source = closeButtonHovered
                onExited: buttonClose.source = closeButtonNormal

                onClicked: {
                    rightPanel.header.pop();
                    rightPanel.content.pop();
                }
            }
        }

        Text {
            text: title
            horizontalAlignment: Qt.AlignLeft
            font.pointSize: 14 * pt
            font.family: "Roboto"
            font.weight: Font.Normal
            font.styleName: "Normal"
            color: "#3E3853"
        }
    }
}

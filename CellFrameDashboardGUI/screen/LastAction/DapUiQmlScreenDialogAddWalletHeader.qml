import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../"

DapUiQmlScreen {
    height: 36 * pt
    color: "#F8F7FA"
    border.width: 1 * pt
    border.color: "#E3E2E6"

    property string backButtonNormal : "qrc:/res/icons/close_icon.png"
    property string backButtonHovered : "qrc:/res/icons/close_icon_hover.png"
    property string title : qsTr("New wallet")
    property alias mouseArea : mouseArea
    property alias pressedCloseAddWallet: mouseArea.pressed

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
                id: buttonCloseAddWallet
                anchors.fill: parent
                source: backButtonNormal
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: buttonCloseAddWallet.source = backButtonHovered
                onExited: buttonCloseAddWallet.source = backButtonNormal

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

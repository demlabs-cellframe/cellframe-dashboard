import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

DapUiQmlScreen {
    height: 36 * pt
    color: "#edeff2"

    property string backButtonNormal : "qrc:/Resources/Icons/close_icon.png"
    property string backButtonHovered : "qrc:/Resources/Icons/close_icon_hover.png"
    property string title : qsTr("New wallet")
    property alias mouseArea : mouseArea

    RowLayout
    {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8
        spacing: 12

        Rectangle {
            width: 20
            height: 20
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
            font.pointSize: 14
        }
    }
}

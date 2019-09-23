import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.13

Component {
    ColumnLayout {

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 18 * pt
        anchors.rightMargin: 18 * pt

        Rectangle {
            height: 18 * pt
        }

        Text {
            id: textLastCmd
            Layout.fillWidth: true
            verticalAlignment: Qt.AlignVCenter
            wrapMode: Text.Wrap
            text: lastCommand
            color: "#5F5F63"
            font.family: "Roboto Regular"
            font.pixelSize: 14 * pt
            clip: true

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    consoleData.append("> " + lastCommand);
                    dapConsoleModel.receiveRequest(lastCommand);
                }
            }
        }

        Rectangle {
            height: 18 * pt
        }
    }
}

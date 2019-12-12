import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Component {
    Rectangle {
        id: dapContentDelegate
        width: parent.width
        height: 50 * pt
        color: "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.rightMargin: 20 * pt
            anchors.leftMargin: 16 * pt

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 2

                Text {
                    Layout.fillWidth: true
                    text: tokenName
                    color: "#3E3853"
                    font.family: fontRobotoRegular.name
                    font.pixelSize: 14 * pt
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: txStatus
                    color: "#757184"
                    font.family: fontRobotoRegular.name
                    font.pixelSize: 12 * pt
                }
            }

            Text {
                Layout.fillHeight: true
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: Qt.AlignVCenter
                color: "#3E3853"
                text: cryptocurrency;
                font.family: fontRobotoRegular.name
                font.pixelSize: 12 * pt
            }
        }



        Rectangle {
            width: parent.width
            height: 1
            color: "#E3E2E6"
            anchors.bottom: parent.bottom
        }
    }
}

import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Component {
    Rectangle {
        id: dapContentDelegate
        width: parent.width
        height: 50 * pt
        color: "transparent"

        Rectangle {
            id: dapData
            width: childrenRect.width
            height: childrenRect.height
            Layout.alignment: Qt.AlignVCenter
            anchors.left: dapContentDelegate.left
            anchors.leftMargin: 16 * pt
            anchors.top: parent.top
            anchors.topMargin: 13

            Column {
                anchors.fill: parent
                spacing: 2

                Text {
                    text: tokenName
                    color: "#3E3853"
                    font.family: fontRobotoRegular.name
                    font.pixelSize: 14 * pt
                }

                Text {
                    text: txStatus
                    color: "#757184"
                    font.family: fontRobotoRegular.name
                    font.pixelSize: 12 * pt
                }
            }
        }

        Text {
            anchors.left: dapData.right
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 20 * pt

            horizontalAlignment: Qt.AlignRight
            verticalAlignment: Qt.AlignVCenter
            color: "#3E3853"
            text: cryptocurrency;
            font.family: fontRobotoRegular.name
            font.pixelSize: 12 * pt
        }

        Rectangle {
            width: parent.width
            height: 1
            color: "#E3E2E6"
            anchors.bottom: parent.bottom
        }
    }

}

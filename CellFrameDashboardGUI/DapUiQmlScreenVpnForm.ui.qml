import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.13

Item {
    width: 400
    height: 600

    Text {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 30 * pt
        anchors.topMargin: 18 * pt
        color: "#d61f5d"
        font.family: "Roboto Regular"
        font.pixelSize: 14 * pt
        text: "283 days left"
    }

    Row {
        width: childrenRect.width
        anchors.top: parent.top
        anchors.topMargin: 40 * pt
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10 * pt

        Image {
            id: imageVpn
            Layout.alignment: Qt.AlignVCenter
            width: 48 * pt
            height: 48 * pt
            source: "qrc:/Resources/Icons/defaul_icon.png"
        }

        Text {
            id: titleVpn
            Layout.alignment: Qt.AlignVCenter
            verticalAlignment: Text.AlignVCenter
            text: "KELVPN"
            font.family: "Roboto Regular"
            font.pixelSize: 42 * pt
        }
    }


    Switch {
        id: control
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: 150 * pt
        height: 70 * pt
        text: checked ? "Connected" : "Disconnected"

        indicator: Rectangle {
            implicitWidth: control.width
            implicitHeight: control.height
            x: control.leftPadding
            y: parent.height / 2 - height / 2
            radius: control.height / 2
            color: control.checked ? "#d61f5d" : "#ffffff"
            border.color: control.checked ? "#d61f5d" : "#cccccc"

            Rectangle {
                x: control.checked ? parent.width - width - 10 * pt : 10 * pt
                anchors.verticalCenter: parent.verticalCenter
                width: control.height - 15 * pt
                height: width
                radius: height / 2
                color: control.down ? "#cccccc" : "#ffffff"
                border.color: control.checked ? (control.down ? "#17a81a" : "#d61f5d") : "#999999"
            }
        }

        contentItem: Text {
            text: control.text
            anchors.left: control.left
            anchors.right: control.right
            anchors.bottom: control.top
            anchors.bottomMargin: 10 * pt
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            font.family: "Roboto"
            font.pixelSize: 16 * pt
            color: "#707070"
        }
    }

    ComboBox {
        id: comboboxServer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40 * pt
        width: 150 * pt
        height: 48 * pt
        textRole: "name"

        model: ListModel {
            id: modelTest
            ListElement {name: "first"; icon: "qrc:/Resources/Icons/defaul_icon.png" }
            ListElement {name: "second"; icon: "qrc:/Resources/Icons/defaul_icon.png" }
        }

        background: Rectangle {
            anchors.fill: parent

            Rectangle {
                id: contentCorner
                anchors.fill: parent
                color: "#FFFFFF"
                radius: width / 2
            }

            DropShadow {
                anchors.fill: parent
                source: contentCorner
                verticalOffset: 4 * pt
                samples: 13 * pt
                color: "#40000000"
            }
        }

        contentItem: Rectangle {
            anchors.fill: parent
            color: "transparent"

            Image {
                id: imageServer
                anchors.left: parent.left
                anchors.leftMargin: 22 * pt
                anchors.verticalCenter: parent.verticalCenter
                source: modelTest.get(modelTest.index(comboboxServer.currentIndex, 0)).icon
                width: 24 * pt
                height: 24 * pt
            }

            Text {
                anchors.left: imageServer.right
                anchors.leftMargin: 10 * pt
                anchors.verticalCenter: parent.verticalCenter
                text: comboboxServer.currentText
                font.family: "Roboto Light"
                font.pixelSize: 16 * pt
            }
        }

    }
}

import QtQuick 2.4
import QtQuick.Controls 2.5

Item {
    width: 400
    height: 600

    Text {
        id: titleVpn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 50

        text: "VPN"
        font.family: "Roboto"
        font.pixelSize: 42 * pt
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
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40 * pt
        textRole: "name"

        model: ListModel {
            ListElement {name: "first"}
            ListElement {name: "second"}
        }

        delegate: ItemDelegate {
            Text {
                anchors.fill: parent
                text: name
            }
        }

//        background: Rectangle {
//            radius: parent.height / 2
//        }
    }
}

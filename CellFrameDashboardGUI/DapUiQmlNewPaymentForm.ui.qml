import QtQuick 2.12
import QtQuick.Controls 2.2
import CellFrameDashboard 1.0

Rectangle {
    id: newPayment
    width: 640
    height: 800
    border.color: "#B5B5B5"
    border.width: 1 * pt
    color: "#FFFFFF"

    anchors {
        top: parent.top
        right: parent.right
        bottom: parent.bottom
    }

    Rectangle {
        id: newPaymentTextArea
        height: 56
        color: "#FFFFFF"
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            id: newPaymentText
            text: qsTr("New payment")
            font.pointSize: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 13
            anchors.top: parent.top
            anchors.topMargin: 13
            anchors.left: buttonCloseNewPayment.right
            anchors.leftMargin: 12
            color: "#505559"
        }

        Button {
            id: buttonCloseNewPayment
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            anchors.left: newPaymentTextArea.left
            anchors.horizontalCenter: newPaymentTextArea.Center
            background: Image {
                source: mouseAreaCloseNewPayment.containsMouse ? "qrc:/Resources/Icons/ic_close_hover.png" : "qrc:/Resources/Icons/ic_close.png"
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: mouseAreaCloseNewPayment
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }
}

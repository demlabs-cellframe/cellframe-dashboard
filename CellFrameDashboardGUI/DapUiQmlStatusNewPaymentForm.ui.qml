import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle {
    property alias pressedCloseNewPaymentStatusButton: mouseAreaCloseNewPayment.pressed

    id: newPaymentStatus
    width: 640
    height: 800
    border.color: "#B5B5B5"
    border.width: 1 * pt
    color: "#FFFFFF"

    Button {
        id: buttonCloseNewPaymentStatus
        width: 20
        height: 20
        anchors.top: parent.top
        anchors.topMargin: 13
        anchors.left: parent.left
        anchors.leftMargin: 12

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

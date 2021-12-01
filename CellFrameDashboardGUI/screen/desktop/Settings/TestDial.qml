import QtQuick 2.2
import QtQuick.Controls 2.12

Popup {
    id:dial
    width: 500
    height: 400
    modal: true
    anchors.centerIn: Overlay.overlay

    topInset: -2
        leftInset: -2
        rightInset: -6
        bottomInset: -6

        background: Rectangle {
            anchors.fill: parent

            color: "black"
        }

    contentItem: Rectangle{
            id: loader
            anchors.fill: parent

            color: "gray"
        }

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
}

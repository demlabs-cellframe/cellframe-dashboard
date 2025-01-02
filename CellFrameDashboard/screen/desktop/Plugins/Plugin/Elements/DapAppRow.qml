import QtQuick 2.4
import QtQuick.Layouts 1.3

RowLayout {

    property alias leftButton: leftBut
    property alias rightButton: rightBut

    spacing: 20

    DapAppButton
    {
        id:leftBut

        Layout.fillHeight: true
        Layout.fillWidth: true
        radius: 16

        fontButton.family: "Qicksand"
        fontButton.pixelSize: 20
        horizontalAligmentText: Qt.AlignHCenter
    }

    DapAppButton
    {
        id:rightBut

        Layout.fillHeight: true
        Layout.fillWidth: true
        radius: 16

        fontButton.family: "Qicksand"
        fontButton.pixelSize: 20
        horizontalAligmentText: Qt.AlignHCenter
    }
}

import QtQuick 2.7

Item {
    id: control

    property string normalIcon
    property string hoverIcon
    property alias mirror: img.mirror

    signal clicked

    implicitWidth: 40 * pt
    implicitHeight: 40 * pt

    Image {
        id: img

        anchors.fill: parent
        source: mouseArea.containsMouse ? control.hoverIcon : control.normalIcon
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: control.clicked()
    }
}

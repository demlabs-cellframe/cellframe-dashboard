import QtQuick 2.9

Item {
    id: control

    property string normalIcon
    property string hoverIcon

    signal clicked

    implicitWidth: 40 * pt
    implicitHeight: 40 * pt

    Image {
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

import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    id: button

    width: 60
    height: 30

    color: isActive ? currTheme.border : "transparent"

    radius: 5

    property var index
    property bool isActive: false
    property alias source: image.source

    signal selected()

    Image
    {
        id: image

        anchors.centerIn: parent

    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.selected()
    }

    Connections{
        target: parent
        onSetActive:
        {
            if (ind === index )
                isActive = true
            else
                isActive = false
        }
    }
}

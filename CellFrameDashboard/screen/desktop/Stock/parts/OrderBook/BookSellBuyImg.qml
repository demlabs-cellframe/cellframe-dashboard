import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Image {
    property var index
    property bool isActive: false
    property alias source: control.source
    signal clicked()

    id: control

    opacity: isActive? 1 : 0.6

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: control.clicked()

        onEntered: control.opacity = 1
        onExited: isActive? control.opacity = 1 : control.opacity = 0.6
    }

    Connections{
        target: parent
        function onSetActive(ind){
            if(ind === index )
                isActive = true
            else
                isActive = false
            control.opacity = isActive? 1 : 0.6
        }
    }
}

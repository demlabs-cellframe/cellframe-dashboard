import QtQuick 2.0
import QtQuick.Controls 2.0

ItemDelegate {
    id: itemDelegateDapWidget
    
    checkable: true
    
    contentItem: Rectangle {
        anchors.fill: parent
        border.color: "grey"
        color: "transparent"
        radius: width/50
        anchors.margins: 5
        clip: true
        
        Column {
            width: parent.width
            anchors.centerIn: parent
            spacing: width / 10
            anchors.margins: width / 10
                Image {
                    id: iconWidget
                    source: image
                    width: parent.width * 2/3
                    height: width
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: name
                    color: "darkgrey"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
        }
    }
}

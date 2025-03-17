import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Rectangle {

    property double speed: 30 

    id: gameScreen

    anchors.fill: parent
    anchors.margins: 30

    color: "#363A42"
    radius: 16 


    GameTopPanel
    {
        id: topPanel
        height: 120 
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    SpinBox
    {
        id: speedBox
        anchors.top: topPanel.bottom
        anchors.right: parent.right
        anchors.topMargin: 60
        anchors.rightMargin: 30
        width: 100
        height: 40
        value: speed
        from: 0
        to: 200
    }

    GamePlayer
    {
        id: player
        height: 60 
        width: 100 

        x:parent.width/2 - width/2
        y: parent.height - height

        Behavior on x { SmoothedAnimation { duration: 300 } }

        Connections
        {
            target: dapMainWindow
            onKeyPressed:
            {
                if(event.key === Qt.Key_A || event.key === Qt.Key_Left )
                {
                    var pos = player.x - speedBox.value

                    if(pos < 0 )
                        pos = 0

                   player.x = pos
                }
                if(event.key === Qt.Key_D || event.key === Qt.Key_Right)
                {
                    var pos = player.x + speedBox.value

                    if(pos > gameScreen.width - player.width )
                        pos = gameScreen.width - player.width

                    player.x = pos
                }
            }
        }

//        focus: true
//        Keys.onPressed:
//        {
//            if(event.key === Qt.Key_A)
//            {
//               player.x = player.x - speedBox.value
//            }
//            if(event.key === Qt.Key_D)
//            {
//                player.x = player.x + speedBox.value
//            }
//        }

    }


}

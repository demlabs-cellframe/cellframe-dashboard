import QtQuick 2.9

Rectangle {

    Rectangle{
        id: none
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 30
        height: 30
        color:"gray"
    }

//    Connections
//    {
//        target: dapMainWindow
//        onKeyPressed:
//        {
////            if(event.key === Qt.Key_W && event.key === Qt.Key_A)
//            console.log(event)
//        }
//    }

//    focus: true
//    Keys.onPressed:
//    {
////        if(event.key === Qt.Key_W)
//        console.log(event.key)
//    }

//    Shortcut
//    {
//        sequence: "W + A"
//        onActivated: topLeft.visible = true
//    }
//    Shortcut
//    {
//        sequence: "S + A"
//        onActivated: bottomLeft.visible = true
//    }
//    Shortcut
//    {
//        sequence: "W + D"
//        onActivated: topRight.visible = true
//    }
//    Shortcut
//    {
//        sequence: "S + D"
//        onActivated: bottomRight.visible = true
//    }


}

import QtQuick 2.4

Item {
    id: control

    property string normalIcon: "qrc:/Resources/" + pathTheme + "/icons/other/next-page.png"
    property string hoverIcon: "qrc:/Resources/" + pathTheme + "/icons/other/next-page_hover.png"
    property string pressedIcon: "qrc:/Resources/" + pathTheme + "/icons/other/next-page_pressed.png"
//    property bool isRight
    property bool isPressed:false
    property alias mirror: controlImg.mirror

    signal clicked

    implicitWidth: 40 
    implicitHeight: 40 

    Image {
//        property alias controlMirror: img.mirror
        id: controlImg
//        rotation: isRight ? 0:180
        height: control.implicitHeight
        width: control.implicitWidth
        anchors.fill: parent
        mipmap: true
//        source: mouseArea.containsMouse ? control.hoverIcon : control.normalIcon
        source: control.normalIcon
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onEntered: {controlImg.source = control.hoverIcon}
        onExited: {controlImg.source = control.normalIcon}

//        onClicked: {
//            control.clicked()
//            controlImg.source = control.pressedIcon
//            logicNet.delay(200, function(){controlImg.source = containsMouse ? control.hoverIcon : control.normalIcon})
//        }
        onPressed: {
            controlImg.source = control.pressedIcon
        }
        onReleased: {
            control.clicked()
            logicNet.delay(100, function(){controlImg.source = containsMouse ? control.hoverIcon : control.normalIcon})
        }
    }
}

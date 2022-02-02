import QtQuick 2.4
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "qrc:/"
import "../../"
Item {
    id: control

    property string normalIcon: "qrc:/resources/icons/" + pathTheme + "/next-page.png"
    property string hoverIcon: "qrc:/resources/icons/" + pathTheme + "/next-page_hover.png"
    property string pressedIcon: "qrc:/resources/icons/" + pathTheme + "/next-page_pressed.png"
//    property bool isRight
    property bool isPressed:false
    property alias mirror: controlImg.mirror

    signal clicked

    implicitWidth: 40 * pt
    implicitHeight: 40 * pt

    DapImageLoader {
//        property alias controlMirror: img.mirror
        id: controlImg
//        rotation: isRight ? 0:180
        innerHeight: control.implicitHeight
        innerWidth: control.implicitWidth
        anchors.fill: parent
//        source: mouseArea.containsMouse ? control.hoverIcon : control.normalIcon
        source: control.normalIcon
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onEntered: {controlImg.source = control.hoverIcon}
        onExited: {controlImg.source = control.normalIcon}

        onClicked: control.clicked()
        onPressed: {controlImg.source = control.pressedIcon}
        onReleased: {containsMouse ? control.hoverIcon : control.normalIcon}


    }
}

import QtQuick 2.9

Image{

    signal clickUpdate()

    id: indicator
    mipmap: true
    width: 28
    height: 28
    sourceSize: Qt.size(28,28)
    source: area.containsMouse ? "qrc:/Resources/BlackTheme/icons/other/icon_reload_hover.svg"
                               : "qrc:/Resources/BlackTheme/icons/other/icon_reload.svg"
    MouseArea{
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            clickUpdate()
            animation.start()
        }
    }

    RotationAnimator {
        id: animation
        target: indicator
        from: 0
        to: 360
        duration: 1000

        onRunningChanged: if(!running) indicator.rotation = 0
    }
}

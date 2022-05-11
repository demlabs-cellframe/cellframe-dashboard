import QtQuick 2.4
import QtQuick.Controls 2.5
import "qrc:/widgets"

Popup
{
    id: popup
    width: 170 * pt
    height: 40 * pt
    scale: mainWindow.scale
    opacity: 0

    x: parent.width/2 - width/2
    y: 10 //TODO: wrong position when scaling


    closePolicy: Popup.NoAutoClose

    background: Rectangle
    {
        border.width: 1 * pt
        border.color: currTheme.lineSeparatorColor
        radius: 16 * pt
        color: currTheme.backgroundElements
    }

    Text {
        id: dapContentTitle
        font: mainFont.dapFont.medium14
        color: currTheme.textColor

        y: parent.height * 0.5 - height * 0.5
        x: 2 * pt
        text: "Address copied"
    }

    DapImageLoader
    {
        innerWidth: 20
        innerHeight: 20
        y: parent.height * 0.5 - height * 0.5
        x: parent.width - width - 2 * pt
        source: "qrc:/resources/icons/" + pathTheme + "/check_icon.png"
    }
    onOpacityChanged: if (opacity == 0){popup.close(); destroy()}

    Behavior on opacity {
        NumberAnimation {
            duration: 400
        }
    }

    Component.onCompleted:
    {
        open()
        opacity = 1
        delay(1000,function() {
            popup.opacity = 0;
        })
    }

    Timer{id: popupTimer}

    function delay(delayTime, cb) {
        popupTimer.interval = delayTime;
        popupTimer.repeat = false;
        popupTimer.triggered.connect(cb);
        popupTimer.start();
    }
}

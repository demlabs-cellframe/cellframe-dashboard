import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.4
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Popup {
    id: popup

    property int opacityDelay: 100
    property int showDelay: 1500
    property int hideDelay: 500
    property string iconPath: ""
    property string infoText: ""
    property int commonHeight: 20
    property int yShift: 50

    property real startY: -popup.parent.y - height
    property real stopY: -popup.parent.y + yShift

    width: rectItem.width
    height: rectItem.height

    x: parent.width/2 - width/2

    opacity: 0
    visible: false

    NumberAnimation{
        id:showAnim
        target: popup
        property: "y"
        from: startY
        to: stopY
        duration: 200
        running: false
    }

    Behavior on opacity {
        NumberAnimation {
            id: opacityAnim
            duration: opacityDelay
        }
    }

    Timer {
        id: showTimer
        interval: showDelay
        running: false
        repeat: false
        onTriggered:
        {
            opacityAnim.duration = hideDelay
            popup.opacity = 0.0
        }
    }

    Timer {
        id: hideTimer
        interval: showDelay+hideDelay
        running: false
        repeat: false
        onTriggered:
        {
            visible = false
        }
    }


    background: Item{ }

    //Background
    Rectangle
    {
        id: rectItem
        width: 168
        height: 48
        radius: 16
        color: currTheme.secondaryBackground
    }

    InnerShadow {
        anchors.fill: rectItem
        source: rectItem
        color: currTheme.reflection
        horizontalOffset: 1
        verticalOffset: 2
        radius: 0
        samples: 10
        fast: true
        cached: true
    }
    DropShadow
    {
        id: shadow
        anchors.fill: rectItem
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 10
        opacity: 0.42
        cached: true
        color: currTheme.shadowMain
        source: rectItem
    }



    contentData:
    RowLayout
    {
        anchors.fill: rectItem
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 10

/*        DapImageLoader
        {
            Layout.alignment: Qt.AlignLeft
            id: imageItem
            innerWidth: commonHeight
            innerHeight: commonHeight
            source: iconPath
        }*/
        DapImageRender
        {
            Layout.alignment: Qt.AlignLeft
            id: imageItem
            width: commonHeight
            height: commonHeight
            sourceSize.width: commonHeight
            sourceSize.height: commonHeight
            source: iconPath
        }

        Text
        {
//            Layout.alignment: Qt.AlignRight
            id: textItem
            height: commonHeight
            font: mainFont.dapFont.medium14
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: infoText
        }
    }

    function showInfo(width, height, text, image)
    {
        console.log("showInfo",
            popup.x, popup.y, startY, stopY,
            popup.parent.x, popup.parent.y)

        if(height)
            rectItem.height = height
        if(width)
            rectItem.width = width

        showTimer.stop()
        hideTimer.stop()

        showAnim.start()

        infoText = text
        iconPath = image

        opacityAnim.duration = opacityDelay

        opacity = 1
        visible = true
        popup.open()

        showTimer.start()
        hideTimer.start()
    }
}


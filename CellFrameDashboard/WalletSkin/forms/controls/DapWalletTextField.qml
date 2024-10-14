import QtQuick 2.4
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.1
import QtQuick.VirtualKeyboard.Settings 2.1
import "qrc:/widgets"

TextField {
    id: root
    property bool bottomLineVisible: false
    property int bottomLineSpacing: 8
    property string bottomLineColor: borderColor
    property int bottomLineLeftRightMargins: 0
    property alias bottomLine: bottomLine

    property int borderWidth:0
    property int borderRadius:0

    property string selectColor: currTheme.inputActive
    property string selectTextColor: currTheme.mainBackground
    property string borderColor: currTheme.input
    property string backgroundColor: currTheme.secondaryBackground
    property string placeholderColor: currTheme.gray
    property string textColor: currTheme.white

    property bool indicatorVisible: false
    property string indicatorSourceEnabled: ""
    property string indicatorSourceDisabled: ""
    property string indicatorSourceEnabledHover: ""
    property string indicatorSourceDisabledHover: ""
    property alias indicator: indicator
    property bool isActiveCopy: true

    signal updateFeild()

    Keys.onReturnPressed: focus = false

    color: textColor
    placeholderTextColor: placeholderColor
    selectionColor: selectColor
    selectedTextColor: selectTextColor
    background:
        Rectangle
        {
            radius: borderRadius
            border.width: borderWidth
            border.color: borderColor
            color: backgroundColor
        }

    DapImageRender{
        id: indicator

        property bool isActive: false

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        visible: indicatorVisible
        source: indicatorSourceDisabled

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                if(indicator.isActive)
                    indicator.source = indicatorSourceEnabledHover
                else
                    indicator.source = indicatorSourceDisabledHover
            }

            onExited: {
                if(indicator.isActive)
                    indicator.source = indicatorSourceEnabled
                else
                    indicator.source = indicatorSourceDisabled
            }
            onClicked: {
                indicator.isActive = !indicator.isActive

                if(containsMouse){
                    if(indicator.isActive)
                        indicator.source = indicatorSourceEnabledHover
                    else
                        indicator.source = indicatorSourceDisabledHover
                }
                else
                {
                    if(indicator.isActive)
                        indicator.source = indicatorSourceEnabled
                    else
                        indicator.source = indicatorSourceDisabled
                }
            }
        }
    }

    //bottom line
    Rectangle {
        id: bottomLine
        visible: bottomLineVisible

        anchors.top: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: bottomLineLeftRightMargins
        anchors.rightMargin: bottomLineLeftRightMargins
        anchors.topMargin: bottomLineSpacing

        height: 1

        color: bottomLineColor

        Behavior on width {
            NumberAnimation {
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    }

    // UNHIDE LATER
    // At now work only for Wallet
    /*
    Connections
    {
        target: app

        function onWindowMouseClicked(point)
        {
            if(root.activeFocus)
            {
                if(!isContains(root, point) && !isContains(keyboard, point))
                {
                    root.focus = false
                    keyboard.visible = false
                }

            }
        }
    }
    */

    DapContextMenu
    {
        id: contextMenu
        isActiveCopy: isActiveCopy
    }

    onPressAndHold:
    {
        contextMenu.openMenu(event)
    }

    function isContains(object, point)
    {
        var point1 = object.mapToItem(null, 0, 0)
        var x0 = point1.x
        var y0 = point1.y
        var x1 = x0 + object.width
        var y1 = y0 + object.height
        if(point.x < x0 || point.x > x1)
        {
            return false
        }
        if(point.y < y0 || point.y > y1)
        {
            return false
        }
        return true
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            keyboard.width = mainWindow.width
            keyboard.x = 0
            keyboard.y = mainWindow.height - keyboard.height
            keyboard.visible = true
        }
        updateFeild()
    }

    Connections{
        target: Qt.inputMethod
        function onVisibleChanged(){
            if(!Qt.inputMethod.visible)
            {
                keyboard.visible = false
                root.focus = false
            }
        }
    }

    function getDelta()
    {
        var point = root.mapToItem(null, 0, 0)
        var objectBottom = point.y + root.height
        var keybpioardY = keyboard.mapToItem(null, 0, 0).y
        if(objectBottom > keybpioardY)
        {
            return objectBottom - keybpioardY
        }
        return 0
    }
}

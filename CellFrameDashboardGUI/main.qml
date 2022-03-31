import QtQuick 2.0
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import windowframerect 1.0
import "screen"
import "resources/theme" as Theme

import "qrc:/screen/desktop/NetworksPanel"

ApplicationWindow
{
    id: window
    visible: true

//    flags: Qt.FramelessWindowHint

    Settings {
        id: settings
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
        property real window_scale: 1.0
    }

    WindowFrameRect{
        id: framerect
    }

    readonly property bool isMobile: ["android", "ios"].includes(Qt.platform.os)

    readonly property real minWindowScale: 0.25
    readonly property real maxWindowScale: 4.0

    readonly property real maxCorrectScale: 1.25

    readonly property int defaultMinWidth: 1280
    readonly property int defaultMinHeight: 600

    readonly property int defaultWidth: 1280
    readonly property int defaultHeight: 800

    property real mainWindowScale: settings.window_scale

    width: defaultWidth
    height: defaultHeight
    minimumWidth: settings.window_scale < 1.0 ?
                      defaultMinWidth * settings.window_scale :
                      defaultMinWidth
    minimumHeight: settings.window_scale < 1.0 ?
                       defaultMinHeight * settings.window_scale :
                       defaultMinHeight

    property int lastX: 0
    property int lastY: 0
    property int lastWidth: 0
    property int lastHeight: 0

    property int leftBorder: 0
    property int rightBorder: 0
    property int topBorder: 0
    property int bottomBorder: 0

    Theme.Dark {id: darkTheme}
    Theme.Light {id: lightTheme}

    color: darkTheme.backgroundPanel

    //Main window
    DapMainApplicationWindow
    {
        id: mainWindow
        property alias device: dapDevice.device
        property alias footer: networksPanel

        anchors.centerIn: parent
        width: parent.width / scale
        height: parent.height / scale

        Device
        {
            id: dapDevice
        }

        DapControlNetworksPanel
        {
            id: networksPanel
            z: 2
            property alias pathTheme: mainWindow.pathTheme
            property alias currTheme: mainWindow.currTheme
            property alias dapQuicksandFonts: mainWindow.dapQuicksandFonts
            property alias dapMainWindow: mainWindow
            height: 40 * pt
        }

        Rectangle {
            anchors.left: networksPanel.left
            anchors.right: networksPanel.right
            anchors.bottom: networksPanel.top
            height: 3

            gradient: Gradient {
                GradientStop { position: 0.0; color: mainWindow.currTheme.backgroundPanel }
                GradientStop { position: 1.0; color: mainWindow.currTheme.reflectionLight }
            }
        }

        scale: 1.0
    }

    ///The image with the effect fast blur
    Image
    {
        id: screenShotMainWindow
        anchors.fill: parent
        smooth: true
        visible: false
    }
    // Fast bluer application
    FastBlur
    {
        id: fastBlurMainWindow
        anchors.fill: screenShotMainWindow
        source: screenShotMainWindow
        radius: 50
        visible: false
    }

    Connections
    {
        target: dapServiceController

        onClientActivated:
        {
            if(window.visibility === Window.Hidden)
            {
                restoreWindow()
            }
            else
            {
                hideWindow()
            }
        }
    }

/*    Connections {
        target: systemTray
        onSignalShow: {
            restoreWindow()

        }

        onSignalQuit: {
            systemTray.hideIconTray()
            Qt.quit()
        }

        onSignalIconActivated: {
             if(window.visibility === Window.Hidden)
             {
                 restoreWindow()

             }
             else
             {
                 hideWindow()
             }
        }
    }*/

    onClosing: {
        close.accepted = false
        Qt.quit()
    }

    Component.onCompleted: {
        if(isMobile) {
            window.minimumWidth = 0
            window.minimumHeight = 0
        }

        var rect = framerect.getFrameRect(window);
        print("window", window.x, window.y, window.width, window.height)
        print("rect", rect.x, rect.y, rect.width, rect.height)

        leftBorder = window.x - rect.x
        rightBorder = rect.width - window.width - leftBorder

        topBorder = window.y - rect.y
        bottomBorder = rect.height - window.height - topBorder

        print("left", leftBorder, "right", rightBorder,
              "top", topBorder, "bottom", bottomBorder)

        if (settings.window_scale < 1.0)
        {
            mainWindow.scale = checkNewScale(settings.window_scale)

            window.minimumWidth = defaultMinWidth * settings.window_scale
            window.minimumHeight = defaultMinHeight * settings.window_scale
        }
        else
        {
            window.minimumWidth = defaultMinWidth
            window.minimumHeight = defaultMinHeight
        }

        if (window.minimumWidth > window.width)
            window.width = window.minimumWidth
        if (window.minimumHeight > window.height)
            window.height = window.minimumHeight

        checkSizeAndPosition()

        print("desktopAvailableWidth", Screen.desktopAvailableWidth,
              "desktopAvailableHeight", Screen.desktopAvailableHeight)
        print("window size", window.width, window.height)
        print("window position", window.x, window.y)
        print("mainWindow size", mainWindow.width, mainWindow.height)
    }

    function restoreWindow()
    {
        window.show()

        window.width = lastWidth
        window.height = lastHeight
        window.x = lastX
        window.y = lastY

        checkSizeAndPosition()

        window.raise()

        window.requestActivate()
    }

    function hideWindow()
    {
        lastWidth = window.width
        lastHeight = window.height
        lastX = window.x
        lastY = window.y
        window.hide()
    }

    function checkSizeAndPosition()
    {
        if (window.height > Screen.desktopAvailableHeight)
            window.height = Screen.desktopAvailableHeight
        if (window.width > Screen.desktopAvailableWidth)
            window.width = Screen.desktopAvailableWidth

        if (window.y > Screen.desktopAvailableHeight)
            window.y = Screen.desktopAvailableHeight - height
        if (window.x > Screen.desktopAvailableWidth)
            window.x = Screen.desktopAvailableWidth - width

        if (window.y < -height)
            window.y = 0
        if (window.x < -width)
            window.x = 0
    }

    function setNewScale(newScale)
    {
        print("setNewScale", newScale)

        var oldWidth = window.width
        var oldHeight = window.height

        window.minimumWidth = 0
        window.minimumHeight = 0

        if (newScale < 1.0)
        {
            if (settings.window_scale < 1.0)
            {
                window.width *= newScale / settings.window_scale
                window.height *= newScale / settings.window_scale
            }
            else
            {
                window.width *= newScale
                window.height *= newScale
            }
        }
        else
        {
            if (settings.window_scale < 1.0)
            {
                window.width *= 1 / settings.window_scale
                window.height *= 1 / settings.window_scale
            }
        }

        settings.window_scale = newScale
        settings.setValue("window_scale", newScale)

        getNewPosition(oldWidth, oldHeight, window.width, window.height)

//        systemTray.hideIconTray()
        Qt.exit(RESTART_CODE)
    }

    function resetSize()
    {
        print("resetSize")

        var oldWidth = window.width
        var oldHeight = window.height

        if (settings.window_scale < 1.0)
        {
            window.width = defaultWidth * settings.window_scale
            window.height = defaultHeight * settings.window_scale
        }
        else
        {
            window.width = defaultWidth
            window.height = defaultHeight
        }

        getNewPosition(oldWidth, oldHeight, window.width, window.height)
    }

    function checkNewScale(newScale)
    {
        if (defaultMinWidth * newScale > Screen.desktopAvailableWidth*maxCorrectScale)
        {
            print("Big scale", newScale,
                  "CORRECT SCALE", Screen.desktopAvailableWidth*maxCorrectScale / defaultMinWidth)
            return Screen.desktopAvailableWidth*maxCorrectScale / defaultMinWidth
        }
        else
            return newScale
    }

    function getNewPosition(oldWidth, oldHeight, newWidth, newHeight)
    {
        window.x += (oldWidth - newWidth)*0.5
        window.y += (oldHeight - newHeight)*0.5

        if (window.x + newWidth > Screen.desktopAvailableWidth - rightBorder)
            window.x = Screen.desktopAvailableWidth - rightBorder - newWidth
        if (window.y + newHeight > Screen.desktopAvailableHeight - bottomBorder)
            window.y = Screen.desktopAvailableHeight - bottomBorder - newHeight

        if (window.x < leftBorder)
            window.x = leftBorder
        if (window.y < topBorder)
            window.y = topBorder

        print("getNewPosition", "x", x, "y", y)
    }

}

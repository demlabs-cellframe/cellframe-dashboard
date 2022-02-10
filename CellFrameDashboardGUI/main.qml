import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import "screen"

import "qrc:/screen/desktop/NetworksPanel"

ApplicationWindow
{
    id: window
    visible: true

    readonly property bool isMobile: ["android", "ios"].includes(Qt.platform.os)

    property real mainWindowScale: mainWindow.scale
    readonly property real minWindowScale: 0.5
    readonly property real maxWindowScale: 4.0

    width: 1280
    height: 800
    minimumWidth: 1280 * mainWindow.scale
    minimumHeight: 600 * mainWindow.scale

    property int lastX: 0
    property int lastY: 0
    property int lastWidth: 0
    property int lastHeight: 0

    Settings {
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
    }

    //Main window
    DapMainApplicationWindow
    {
        id: mainWindow
        property alias device: dapDevice.device
        property alias footer: networksPanel

//        anchors.fill: parent
        width: parent.width / scale
        height: parent.height / scale
        x: (parent.width - width)*0.5
        y: (parent.height - height)*0.5

        Device
        {
            id: dapDevice
        }

        DapControlNetworksPanel
        {
            id: networksPanel
            property alias pathTheme: mainWindow.pathTheme
            property alias currTheme: mainWindow.currTheme
            property alias dapQuicksandFonts: mainWindow.dapQuicksandFonts
            property alias dapMainWindow: mainWindow
            height: 40 * pt
        }

        scale: 1
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

    Connections {
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
    }

    Component.onCompleted: {
        if(isMobile) {
            window.minimumWidth = 0
            window.minimumHeight = 0
        }

        checkSizeAndPosition()

        print("window size", window.width, window.height)
        print("window position", window.x, window.y)
    }

    onClosing: {
        close.accepted = false

        hideWindow()
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

        print("restoreWindow size", window.width, window.height, "position", window.x, window.y)
    }

    function hideWindow()
    {
        print("hideWindow size", window.width, window.height, "position", window.x, window.y)

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

        window.minimumWidth = 1280 * newScale
        window.minimumHeight = 600 * newScale

        mainWindow.scale = newScale

        if (window.minimumWidth > window.width)
            window.width = window.minimumWidth
        if (window.minimumHeight > window.height)
            window.height = window.minimumHeight
    }
}

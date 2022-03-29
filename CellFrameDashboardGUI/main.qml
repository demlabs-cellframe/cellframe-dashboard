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

    Settings {
        property alias x: window.x
        property alias y: window.y
//        property alias width: window.width
//        property alias height: window.height
    }

    //Main window
    DapMainApplicationWindow
    {
        id: mainWindow
        property alias device: dapDevice.device
        property alias footer: networksPanel

        anchors.fill: parent

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
                window.show()
                window.raise()
                window.requestActivate()
            }
            else
            {
                window.hide()
            }
        }
    }

    Connections {
        target: systemTray
        onSignalShow: {
            window.show()
            window.raise()
            window.requestActivate()
        }

        onSignalQuit: {
            systemTray.hideIconTray()
            Qt.quit()
        }

        onSignalIconActivated: {
             if(window.visibility === Window.Hidden)
             {
                 window.show()
                 window.raise()
                 window.requestActivate()
             }
             else
             {
                 window.hide()
             }
        }
    }

    onClosing: {
        close.accepted = false
        Qt.quit()
//        window.hide()
    }

    Component.onCompleted: {
        if(isMobile) {
            window.minimumWidth = 0
            window.minimumHeight = 0
        }
        else
            sizeUpdate()

    }

    function sizeUpdate()
    {
        if(Screen.width > 1280 && Screen.height > 800)
        {
            width = 1280
            height = 800
        }
        else if(Screen.width < 1280 && Screen.height > 800)
        {
            width = Screen.width
            height = 800
        }
        else if(Screen.height < 800 && Screen.width > 1280)
        {
            width = 1280
            height = Screen.height - 60
        }
        else
        {
            width = Screen.width
            height = Screen.height - 60
        }
        minimumWidth = width
        minimumHeight = height
    }
}

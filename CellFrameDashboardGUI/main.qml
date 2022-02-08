import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import "screen"

ApplicationWindow
{
    id: window
    visible: true

    //    property variant networkListPopups : []

    readonly property bool isMobile: ["android", "ios"].includes(Qt.platform.os)

    width: 1280
    height: 800
    minimumWidth: 1280
    minimumHeight: 600

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

        anchors.fill: parent

        Device
        {
            id: dapDevice
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
}

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
    minimumHeight: 800

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

    Component.onCompleted: {
        if(isMobile) {
            window.minimumWidth = 0
            window.minimumHeight = 0
        }
    }

    onClosing: {
        close.accepted = false
        window.hide()
    }
}

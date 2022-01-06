import QtQuick 2.0
import QtQml 2.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import "screen"

ApplicationWindow
{
    id: window
    visible: true    

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

    //DapMainApplicationWindow
    DapMainWindow
    {
        id: mainWindow
        property string device: isMobile ? "mobile" : "desktop"

        anchors.fill: parent
// DmitriyT Let`s try to define OS by it`s name using Qt tools
//        Device {
//            id: dapDevice
//        }
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

    footer: Rectangle {
        id: networkPanel
        height: 40
        color: "#2D3037"
    }

    DropShadow {
        anchors.fill: networkPanel
        horizontalOffset: -5
        verticalOffset: 0
        radius: 2.0
        samples: 17
        color: "white"
        source: networkPanel
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

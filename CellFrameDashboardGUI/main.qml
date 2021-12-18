import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import "resources/theme" as Theme
import "screen"

ApplicationWindow
{
    id: window
    visible: true

    Theme.Dark {id: darkTheme}
    Theme.Light {id: lightTheme}

    property bool currThemeVal: true
    property var currTheme: currThemeVal ? darkTheme : lightTheme

    //for test
//    property string pathTheme: currThemeVal ? "BlackTheme":"WhiteTheme"
    property string pathTheme: "BlackTheme"

    readonly property bool isMobile: ["android", "ios"].includes(Qt.platform.os)

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
        if(!isMobile) {
            window.width = 1280
            window.height = 800
            window.minimumWidth = 1280
            window.minimumHeight = 800
        }
    }

    onClosing: {
        close.accepted = false
        window.hide()
    }

}

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
    width: 1280
    height: 800
    minimumHeight: 650
    minimumWidth: 880

    Theme.Dark {id: darkTheme}
    Theme.Light {id: lightTheme}

    property bool currThemeVal: true
    property var currTheme: currThemeVal ? darkTheme : lightTheme
    property var pathTheme: currThemeVal ? "BlackTheme":"WhiteTheme"

    //Main window
    DapMainApplicationWindow
    {
        id:mainWindow
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

    onClosing: {
        close.accepted = false
        window.hide()
    }

}

import QtQuick 2.0
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import windowframerect 1.0

import "Resources/theme"
import "qrc:/resources/QML"
import "screen/mobile"
import "screen"
import "logic"

ApplicationWindow
{
    property string path: params.isMobile ? "qrc:/screen/mobile" : "qrc:/screen/desktop"
    property string pathTheme: currThemeVal ? "BlackTheme" : "LightTheme"
    property bool currThemeVal: true
    property var currTheme: currThemeVal ? darkTheme : lightTheme
    property alias mainFont: quicksandFonts
    property alias mainWindow : params.mainWindow


    id: window
//    flags: Qt.FramelessWindowHint

    WindowFrameRect{ id: framerect }
    MainParams{ id: params}
    Dark {id: darkTheme}
    Light {id: lightTheme}
    DapFontQuicksand { id: quicksandFonts }

    Settings {
        id: settings
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
        property real window_scale: 1.0
    }

//    DapMainApplicationWindow
//    {

//    }

    visible: true
    width: params.defaultWidth
    height: params.defaultHeight
    minimumWidth: params.minimumWidth
    minimumHeight: params.minimumHeight

    color: darkTheme.backgroundPanel

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

    onClosing: {
        close.accepted = false
        Qt.quit()
    }

    Component.onCompleted: {
        params.initScreen()
        params.initSize()
    }

    Connections
    {
        target: dapServiceController

        onClientActivated:
        {
            if(window.visibility === Window.Hidden)
                params.restoreWindow()
            else
                params.hideWindow()

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


}

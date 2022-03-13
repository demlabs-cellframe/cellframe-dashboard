import QtQuick 2.0
import QtQml 2.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.0

import "logic"
import "resources/theme"
import "qrc:/resources/QML"
import "screen"
import "qrc:/screen/desktop/NetworksPanel"

ApplicationWindow
{
    id: window
    visible: true

    readonly property bool isMobile: ["android", "ios"].includes(Qt.platform.os)
    readonly property string device: isMobile? "mobile" : "desktop"

    Logic {
        id: globalLogic
    }

    Settings {
        property alias x: window.x
        property alias y: window.y
    }

    Component {
        id: mainWindowComponent
        DapMainWindow
        //DapMainApplicationWindow
        {
            id: mainWindow
        }
    }

    Component {
        id: mainWindowMobileComponent
        DapMainWindowMobile {
            id: mainWindowMobile
        }
    }

    //Themes and fonts
    Dark { id: darkTheme }
    Light { id: lightTheme }
    property string pathTheme: "BlackTheme"
    property bool currThemeVal: true
    property var currTheme: currThemeVal ? darkTheme : lightTheme
    DapFontQuicksand { id: quicksandFonts }
    property alias _dapQuicksandFonts: quicksandFonts
    //


    footer: DapControlNetworksPanel
    {
        id: networkPanel
        height: 40 * pt
    }

    //Main window
    StackView {
        id: mainWindowStack
        anchors.fill: parent
        initialItem: isMobile ? mainWindowMobileComponent : mainWindowComponent
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

    DropShadow {
        anchors.fill: networkPanel
        horizontalOffset: -5
        verticalOffset: 0
        radius: 2.0
        samples: 17
        color: "white"
        source: networkPanel
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

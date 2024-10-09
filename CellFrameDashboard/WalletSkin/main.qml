import QtQuick 2.0
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import QtQuick.VirtualKeyboard 2.1
import QtQuick.VirtualKeyboard.Settings 2.1

import "Resources/theme"
import "qrc:/resources/QML"
import "forms"

ApplicationWindow
{
    id: window

    property string pathForms: "qrc:/walletSkin/forms/"
    property string pathTheme: currThemeVal ? "BlackTheme" : "LightTheme"
    property bool currThemeVal: true
    property var currTheme: currThemeVal ? darkTheme : lightTheme
    property alias mainFont: quicksandFonts
    property alias mainWindow : mainWindow
    property real mainWindowScale: systemFrameContent.scale
    property var framerect: app
    property alias frameMainWindow: systemFrameContent

    property alias keyboard: inputPanel

    property int defaultMaxValue: undefined

    property bool newScaleRestart: false
//    property var windowFlags: Qt.Windowe
//    flags: Qt.Window
//        | Qt.CustomizeWindowHint
//        | Qt.WindowTitleHint
//        | Qt.WindowSystemMenuHint
//        | Qt.WindowMinimizeButtonHint
//        | Qt.WindowCloseButtonHint

    flags: OS_WIN_FLAG ? Qt.FramelessWindowHint | Qt.Window
                       : Qt.Window
                       | Qt.CustomizeWindowHint
                       | Qt.WindowTitleHint
                       | Qt.WindowSystemMenuHint
                       | Qt.WindowMinimizeButtonHint
                       | Qt.WindowCloseButtonHint

    MainLogic{ id: params}
    Black {id: darkTheme}
    Light {id: lightTheme}
    DapFontQuicksand { id: quicksandFonts }

    readonly property int testNewCoordinate: -1000

    Settings {
        id: settings
        property alias x: window.x
        property alias y: window.y
        property int newX: testNewCoordinate
        property int newY: testNewCoordinate
//        property alias width: window.width
//        property alias height: window.height
        property real window_scale: 1.0
    }


    visible: true

    color: darkTheme.mainBackground

    width: DEFAULT_WIDTH
    height: DEFAULT_HEIGHT

    SystemFrameComponent
    {
        id: systemFrameContent
        anchors.fill: parent
//        x: 0
//        y: 0

        width: DEFAULT_WIDTH
        height: DEFAULT_HEIGHT

        header.enabled: OS_WIN_FLAG && !fullScreen.FULLSCREEN

        dataItem: DapMainApplicationWindow
        {
            id: mainWindow
            anchors.fill: parent
        }
    }

    onClosing: {
        console.log("onClosing")

        close.accepted = false
        Qt.quit()
    }

    Component.onCompleted: {
        defaultMaxValue = window.maximumHeight
        if (OS_WIN_FLAG && !fullScreen.FULLSCREEN)
        {
            params.defaultWidth  += systemFrameContent.border.width*2
//            params.defaultHeight += systemFrameContent.header.height
//            params.minimumWidth  += systemFrameContent.border.width*2
//            params.minimumHeight += systemFrameContent.header.height
        }

        params.initSize()

//        window.showMaximized()
    }

    Component.onDestruction: {
        console.log("Component.onDestruction", newScaleRestart)

        if (!newScaleRestart)
        {
            settings.newX = window.x
            settings.newY = window.y
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

    // UNHIDE LATER
    // At now work only for Wallet
    /*
    Connections
    {
        target: fullScreen

        function onCloseWindow()
        {
            window.close()
        }

        function onFullScreenChanged(isFull)
        {
            if (isFull) {
                window.minimumWidth = 0
                window.maximumWidth = defaultMaxValue
                window.minimumHeight = 0
                window.maximumHeight = defaultMaxValue
                window.flags = Qt.FramelessWindowHint | Qt.Window
                window.showFullScreen()
            }
            else
            {
                console.log("[FULL SCREEN] onFullScreenChanged", isFull)
                window.width = DEFAULT_WIDTH
                window.height = DEFAULT_HEIGHT
                params.initSize()
                window.x = 50
                window.y = 50
                if (OS_WIN_FLAG && !fullScreen.FULLSCREEN)
                {
                    params.defaultWidth  += systemFrameContent.border.width*2
                }
                window.flags = OS_WIN_FLAG ? Qt.FramelessWindowHint | Qt.Window
                                           : Qt.Window
                                           | Qt.CustomizeWindowHint
                                           | Qt.WindowTitleHint
                                           | Qt.WindowSystemMenuHint
                                           | Qt.WindowMinimizeButtonHint
                                           | Qt.WindowCloseButtonHint
            }
        }
    }
    */

    InputPanel
    {
        id: inputPanel
        z: 99
        visible: false
        externalLanguageSwitchEnabled: false

        Component.onCompleted: {
            VirtualKeyboardSettings.locale = "en_GB"
        }
    }
}

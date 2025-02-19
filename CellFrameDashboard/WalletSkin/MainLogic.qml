import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.2

QtObject {

    readonly property bool isMobile: ["android", "ios"].includes(Qt.platform.os)
//    readonly property bool isMobile: true

    property real settingsScale: settings.window_scale
    readonly property real minScale: 0.6
    readonly property real maxScale: 4.0
    readonly property real maxCorrectScale: 1

//    property var mainWindow
    property var component

//    readonly property real maxCorrectScale: 1.25

    property int defaultMinWidth: isMobile? 0 : MIN_WIDTH
    property int defaultMinHeight: isMobile? 0 : MIN_HEIGHT

    property int defaultWidth: DEFAULT_WIDTH
    property int defaultHeight: DEFAULT_HEIGHT

    property int lastX: 0
    property int lastY: 0
    property int lastWidth: 0
    property int lastHeight: 0

    property int leftBorder: 0
    property int rightBorder: 0
    property int topBorder: 0
    property int bottomBorder: 0


    function initSize()
    {
        console.log("initSize")

        if (settings.newX !== testNewCoordinate &&
            settings.x !== settings.newX)
        {
            settings.x = settings.newX
        }
        if (settings.newY !== testNewCoordinate &&
            settings.y !== settings.newY)
        {
            settings.y = settings.newY
        }

        window.minimumWidth = defaultWidth
        window.maximumWidth = defaultWidth
        window.minimumHeight = defaultHeight
        window.maximumHeight = defaultHeight

        window.width = window.maximumWidth
        window.height = window.maximumHeight

        if (window.minimumWidth > window.width)
            window.width = window.minimumWidth
        if (window.minimumHeight > window.height)
            window.height = window.minimumHeight

        checkSizeAndPosition()

        console.log("desktopAvailableWidth", Screen.desktopAvailableWidth,
              "desktopAvailableHeight", Screen.desktopAvailableHeight)
        console.log("window size", window.width, window.height)
        console.log("window position", window.x, window.y)
        console.log("mainWindow size", mainWindow.width, mainWindow.height)
    }

    function checkSizeAndPosition()
    {
        if (window.width > Screen.desktopAvailableWidth)
            window.width = Screen.desktopAvailableWidth
        if (window.height > Screen.desktopAvailableHeight)
            window.height = Screen.desktopAvailableHeight

        if (window.x > Screen.desktopAvailableWidth - width)
            window.x = Screen.desktopAvailableWidth - width
        if (window.y > Screen.desktopAvailableHeight - height)
            window.y = Screen.desktopAvailableHeight - height

        if (window.x < 0)
            window.x = 0
        if (window.y < 0)
            window.y = 0
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
    }

    function hideWindow()
    {
        lastWidth = window.width
        lastHeight = window.height
        lastX = window.x
        lastY = window.y
        window.hide()
    }

    function setNewScale(newScale)
    {
        var oldScale = settings.window_scale

        console.log("setNewScale", newScale)

        console.log(newScale, settings.window_scale)

        window.minimumWidth = 0
        window.minimumHeight = 0

        settings.window_scale = newScale
        settings.setValue("window_scale", newScale)

        getNewPosition(oldScale, newScale, defaultWidth, defaultHeight)

//        systemTray.hideIconTray()
        console.log("Qt.exit(RESTART_CODE)")

        newScaleRestart = true

        Qt.exit(RESTART_CODE)
    }

    function resetSize()
    {
//        console.log("resetSize")

/*        var oldScale = settings.window_scale

        var oldWidth = window.width
        var oldHeight = window.height

        window.width = defaultWidth
        window.height = defaultHeight

        getNewPosition(oldWidth, oldHeight, window.width, window.height)*/
    }

    function checkNewScale(newScale)
    {
        if (defaultMinWidth * newScale > Screen.desktopAvailableWidth*maxCorrectScale)
        {
            console.log("Big scale", newScale,
                  "CORRECT SCALE", Screen.desktopAvailableWidth*maxCorrectScale / defaultMinWidth)
            return Screen.desktopAvailableWidth*maxCorrectScale / defaultMinWidth
        }
        else
        if (defaultMinHeight * newScale > Screen.desktopAvailableHeight*maxCorrectScale)
        {
            console.log("Big scale", newScale,
                  "CORRECT SCALE", Screen.desktopAvailableHeight*maxCorrectScale / defaultMinHeight)
            return Screen.desktopAvailableHeight*maxCorrectScale / defaultMinHeight
        }
        else
            return newScale
    }


    function getNewPosition(oldScale, newScale, width, height)
    {
        console.log("Old position", "x", window.x, "y", window.y)

/*        console.log("Position1", "x", window.x/oldScale, "y", window.y/oldScale)
        console.log("Position2", "x", window.x/newScale, "y", window.y/newScale)

        console.log("width", window.width,
                    "height", window.height)
        console.log("widtholdScale", width/oldScale,
                    "widthnewScale", width/newScale)
        console.log("heightoldScale", height/oldScale,
                    "heightnewScale", height/newScale)*/

/*        window.x *= oldScale
        window.y *= oldScale

        window.x += (width/newScale - width/oldScale)*0.5
        window.y += (height/newScale - height/oldScale)*0.5

        window.x /= newScale
        window.y /= newScale*/

        settings.newX = x*oldScale/newScale
        settings.newY = y*oldScale/newScale

//        window.x *= oldScale/newScale
//        window.y *= oldScale/newScale

        console.log("New position", "x", settings.newX, "y", settings.newY)
    }

/*    function initScreen()
    {
        if(isMobile)
            component = Qt.createComponent("qrc:/walletSkin/screen/mobile/MainMobileWindow.qml");
        else
            component = Qt.createComponent("qrc:/walletSkin/screen/DapMainApplicationWindow.qml");
        mainWindow = component.createObject(window);
    }*/
}

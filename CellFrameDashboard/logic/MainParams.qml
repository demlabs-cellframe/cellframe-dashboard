import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.2

QtObject {

    readonly property bool isMobile: ["android", "ios"].includes(Qt.platform.os)
//    readonly property bool isMobile: true

    property real mainWindowScale: settings.window_scale

    property var mainWindow
    property var component

    readonly property real minWindowScale: 0.6
    readonly property real maxWindowScale: 4.0

    readonly property real maxCorrectScale: 1.25

    readonly property int defaultMinWidth: isMobile? 0 : MIN_WIDTH
    readonly property int defaultMinHeight: isMobile? 0 : MIN_HEIGHT

    readonly property int defaultWidth: isMobile? 600 : DEFAULT_WIDTH
    readonly property int defaultHeight: isMobile? 700 : DEFAULT_HEIGHT

    property var minimumHeight: settings.window_scale < 1.0 ?
                                    defaultMinHeight * settings.window_scale :
                                    defaultMinHeight

    property var minimumWidth: settings.window_scale < 1.0 ?
                                   defaultMinWidth * settings.window_scale :
                                   defaultMinWidth

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
        var rect = framerect.getFrameRect(window);
        print("window", window.x, window.y, window.width, window.height)
        print("rect", rect.x, rect.y, rect.width, rect.height)

        leftBorder = window.x - rect.x
        rightBorder = rect.width - window.width - leftBorder

        params.topBorder = window.y - rect.y
        bottomBorder = rect.height - window.height - topBorder

        print("left", leftBorder, "right", rightBorder,
              "top", topBorder, "bottom", bottomBorder)

        print("defaultMinWidth", defaultMinWidth,
              "defaultMinHeight", defaultMinHeight)

        if (settings.window_scale < 1.0)
        {
            mainWindow.scale = checkNewScale(settings.window_scale)

            window.minimumWidth = defaultMinWidth * settings.window_scale
            window.minimumHeight = defaultMinHeight * settings.window_scale
        }
        else
        {
            window.minimumWidth = defaultMinWidth
            window.minimumHeight = defaultMinHeight
        }

        if (window.minimumWidth > window.width)
            window.width = window.minimumWidth
        if (window.minimumHeight > window.height)
            window.height = window.minimumHeight

        if(isMobile) {
            window.minimumWidth = 0
            window.minimumHeight = 0
        }
        checkSizeAndPosition()

        print("desktopAvailableWidth", Screen.desktopAvailableWidth,
              "desktopAvailableHeight", Screen.desktopAvailableHeight)
        print("window size", window.width, window.height)
        print("window position", window.x, window.y)
//        print("mainWindow size", mainWindow.width, mainWindow.height)

    }

    function checkSizeAndPosition()
    {
        if (window.height > Screen.desktopAvailableHeight)
            window.height = Screen.desktopAvailableHeight
        if (window.width > Screen.desktopAvailableWidth)
            window.width = Screen.desktopAvailableWidth

        if (window.y > Screen.desktopAvailableHeight)
            window.y = Screen.desktopAvailableHeight - height
        if (window.x > Screen.desktopAvailableWidth)
            window.x = Screen.desktopAvailableWidth - width

        if (window.y < -height)
            window.y = 0
        if (window.x < -width)
            window.x = 0
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
        print("setNewScale", newScale)

        console.log(newScale, settings.window_scale)

        var oldWidth = window.width
        var oldHeight = window.height

        window.minimumWidth = 0
        window.minimumHeight = 0

        if (newScale < 1.0)
        {
            if (settings.window_scale < 1.0)
            {
                window.width *= newScale / settings.window_scale
                window.height *= newScale / settings.window_scale
            }
            else
            {
                window.width *= newScale
                window.height *= newScale
            }
        }
        else
        {
            if (settings.window_scale < 1.0)
            {
                window.width *= 1 / settings.window_scale
                window.height *= 1 / settings.window_scale
            }
        }

        settings.window_scale = newScale
        settings.setValue("window_scale", newScale)

        getNewPosition(oldWidth, oldHeight, window.width, window.height)

//        systemTray.hideIconTray()
        Qt.exit(RESTART_CODE)
    }

    function resetSize()
    {
        print("resetSize")

        var oldWidth = window.width
        var oldHeight = window.height

        if (settings.window_scale < 1.0)
        {
            window.width = defaultWidth * settings.window_scale
            window.height = defaultHeight * settings.window_scale
        }
        else
        {
            window.width = defaultWidth
            window.height = defaultHeight
        }

        getNewPosition(oldWidth, oldHeight, window.width, window.height)
    }

    function checkNewScale(newScale)
    {
        if (defaultMinWidth * newScale > Screen.desktopAvailableWidth*maxCorrectScale)
        {
            print("Big scale", newScale,
                  "CORRECT SCALE", Screen.desktopAvailableWidth*maxCorrectScale / defaultMinWidth)
            return Screen.desktopAvailableWidth*maxCorrectScale / defaultMinWidth
        }
        else
            return newScale
    }


    function getNewPosition(oldWidth, oldHeight, newWidth, newHeight)
    {
        window.x += (oldWidth - newWidth)*0.5
        window.y += (oldHeight - newHeight)*0.5

        if (window.x + newWidth > Screen.desktopAvailableWidth - rightBorder)
            window.x = Screen.desktopAvailableWidth - rightBorder - newWidth
        if (window.y + newHeight > Screen.desktopAvailableHeight - bottomBorder)
            window.y = Screen.desktopAvailableHeight - bottomBorder - newHeight

        if (window.x < leftBorder)
            window.x = leftBorder
        if (window.y < topBorder)
            window.y = topBorder

        print("getNewPosition", "x", x, "y", y)
    }

    function initScreen()
    {
        if(isMobile)
            component = Qt.createComponent("qrc:/screen/mobile/MainMobileWindow.qml");
        else
            component = Qt.createComponent("qrc:/screen/DapMainApplicationWindow.qml");
        mainWindow = component.createObject(window);
    }
}

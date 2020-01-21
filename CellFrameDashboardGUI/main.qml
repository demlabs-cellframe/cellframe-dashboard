import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import "screen"

ApplicationWindow
{
    id: window
    visible: true
    width: 1280
    height: 800
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

    onClosing:
    {
        window.hide()
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
}

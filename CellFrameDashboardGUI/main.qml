import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import "screen"
import "qrc:/widgets"


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

    DapMessageBox
    {
        id: messageBox
        anchors.centerIn: parent
        width: 400 * pt
        height: 216 * pt
        dapTitleText.text: "Saving status"
        dapContentText.text: "The log \"*** KLV ***\" was saved successfully fdgfdg fdghgf fdhdjhgfj"
        visible: false;
    }

    ///Creating a screenshot of a window
    function grub()
    {
        var x = mainWindow.grabToImage(function(result){screenShotMainWindow.source = result.url;},
                                       Qt.size(mainWindow.width, mainWindow.height));
        fastBlurMainWindow.source = screenShotMainWindow
        fastBlurMainWindow.visible = true
    }

//    Connections
//    {
//        target: dapServiceController
//        onNetworksListReceived:
//        {
//            grub();
//            messageBox.visible = true
//        }
//    }
}

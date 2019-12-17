import QtQuick 2.0
import QtQuick.Controls 2.0

ApplicationWindow {
    id: window
    visible: true
    width: 1280
    height: 800

    onClosing: {
        console.log("Close")
        window.hide()
    }

    Connections {
        target: dapServiceController

        onActivateWindow: {
            if(window.visibility === Window.Hidden) {
                window.show()
                window.raise()
                window.requestActivate()
            } else {
                window.hide()
            }
        }
    }
    
    DapMainApplicationWindowForm
    {
        anchors.fill: parent
    }

}

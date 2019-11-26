import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.3
import QtQuick.Controls.Styles 1.4
import Qt.labs.platform 1.0
import CellFrameDashboard 1.0

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



//        onErrorConnect: {
//            imageNetwork.visible = false
//            if(imageErrorNetwork.visible)
//                imageErrorNetwork.visible = false
//            else
//                imageErrorNetwork.visible = true
//        }

//        onConnectedToService: {
//            imageNetwork.visible = true
//            imageErrorNetwork.visible = false
//            console.log("Connected")
//        }
    }

    DapUiQmlScreenMainWindow {
        anchors.fill: parent
    }
}

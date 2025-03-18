import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../controls"

import qmlclipboard 1.0

Popup {
    property alias imgStatus: content.nameStatus
    property bool isOpen: false
    property real startY: 0
    property real stopY: 0

    QMLClipboard{
        id: clipboard
    }

    id: popupItem

    closePolicy: Popup.NoAutoClose
    padding: 0

    background: Item{}

    onOpenedChanged:
    {
        if(opened){
            content.buttonSync.enabled = true
            content.buttonNetwork.enabled = true
        }else{
            content.buttonSync.enabled = false
            content.buttonNetwork.enabled = false
        }
    }

    enter: Transition {
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
                NumberAnimation { property: "y"; from: startY; to: stopY; duration: 200 }
            }
    exit: Transition {
                NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200 }
                NumberAnimation { property: "y"; from: stopY; to: startY; duration: 200 }
            }

    contentItem: DapInfoContent{id: content}
}

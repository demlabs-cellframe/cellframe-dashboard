import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

Page {
    id: dapUiQmlWidgetConsole
    property alias command: command
    property alias execute: execute
    property alias result: result


    Rectangle {
        id: rectangle
        y: 0
        width: 640
        height: 480
        color: "#ffffff"
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        border.width: 0

        Button {
            id: execute
            x: 250
            y: 243
            text: qsTr("Execute")
            anchors.horizontalCenterOffset: 4
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 197
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextEdit {
            id: command
            x: 290
            y: 50
            width: 594
            height: 177
            cursorVisible: true
            clip: false
            anchors.horizontalCenterOffset: 4
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 12
        }

        Label {
            id: commandText
            x: 21
            y: 24
            width: 82
            height: 14
            text: qsTr("Command:")
            anchors.left: parent.left
            anchors.leftMargin: 21
        }

        Label {
            id: resultText
            x: 21
            y: 294
            text: qsTr("Result:")
        }

        TextEdit {
            id: result
            x: 21
            y: 315
            width: 600
            height: 157
            text: qsTr("")
            readOnly: true
            font.pixelSize: 12
        }
    }
}




/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

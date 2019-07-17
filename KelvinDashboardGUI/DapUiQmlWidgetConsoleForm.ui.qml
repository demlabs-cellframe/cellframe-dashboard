import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

Page {
    id: dapUiQmlWidgetConsole
    property alias result: result
    property alias command: command
    property alias execute: execute


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
            y: 366
            text: qsTr("Execute")
            anchors.horizontalCenterOffset: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 74
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextEdit {
            id: command
            x: 290
            y: 50
            width: 606
            height: 208
            anchors.horizontalCenterOffset: 4
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 12
        }

        Label {
            id: result
            y: 422
            width: 606
            height: 50
            text: qsTr("")
            anchors.left: parent.left
            anchors.leftMargin: 21
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
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
            y: 409
            text: qsTr("Result:")
        }
    }
}




/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

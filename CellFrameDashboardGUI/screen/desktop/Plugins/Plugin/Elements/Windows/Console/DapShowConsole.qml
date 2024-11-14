import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Item {
    anchors.fill: parent
    id:controlConsole

    property string sendedCommand
    property string sendCommand
    property string receivedAnswer

    signal runCommand(string command)

    ListModel
    {
        id: modelConsoleCommand
    }

    Rectangle
    {
        id: viewConsole
        anchors.fill: parent
        color: "#363A42"
        radius: 16 
        Rectangle
        {
            anchors.fill: parent
            color: viewConsole.color
            radius: viewConsole.radius
            layer.enabled: true
            layer.effect: OpacityMask
            {
                maskSource: Rectangle
                {
                    width: viewConsole.width
                    height: viewConsole.height
                    radius: viewConsole.radius
                }
            }

            // Header
            Item
            {
                id:consoleHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 38 

                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 18 
                    anchors.topMargin: 10 
                    anchors.bottomMargin: 10 
                    verticalAlignment: Qt.AlignVCenter
                    text: qsTr("Console")
                    font.family: "Quicksand"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#ffffff"
                }
            }

            ListView
            {
                id: listViewConsole
                anchors.top: consoleHeader.bottom

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 50 
                anchors.leftMargin: 20 *pt

                height: (contentHeight < viewConsole.height - inputCommand.height) ?
                            contentHeight :
                            (viewConsole.height - inputCommand.height)
                clip: true
                model: modelConsoleCommand
                delegate: DapConsoleComponent{}

                currentIndex: count - 1
                highlightFollowsCurrentItem: true
                highlightRangeMode: ListView.ApplyRange

                ScrollBar.vertical: ScrollBar {
                    active: true
                }
            }

            Flickable
            {
                clip: true
                id: inputCommand
                width: parent.width
                anchors.bottom: parent.bottom
                height: contentHeight < 100  ? contentHeight : 100 
                contentHeight: consoleCmd.height
                ScrollBar.vertical: ScrollBar {}

                Rectangle
                {
                    color: "#363A42"
                    anchors.fill: parent

                    Text
                    {
                        Layout.fillHeight: true
                        id: promt
                        x: 20 
                        y: 5 

                        text: ">"
                        font.family: "Quicksand"
                        font.pixelSize: 18
                        color: "#ffffff"
                    }

                    TextField
                    {
                        id: consoleCmd
                        width: parent.width - x
                        anchors.bottom: parent.bottom
                        x: promt.x + promt.width + 5 
                        wrapMode: TextArea.Wrap
                        validator: RegExpValidator { regExp: /[0-9A-Za-z\-\_\:\.\(\)\?\s*]+/ }
                        placeholderText: qsTr("Type here...")
                        selectByMouse: true
                        background: Rectangle{color: "#363A42"}
                        selectionColor: "#AABCDE"
                        selectedTextColor: "#2E3138"


                        font.family: "Quicksand"
                        font.pixelSize: 18
                        color: "#ffffff"
//                        focus: true

                        Keys.onReturnPressed: text.length > 0 ?
                                                  sendedCommand = text :
                                                  sendedCommand = ""
                        Keys.onEnterPressed: text.length > 0 ?
                                                 sendedCommand = text :
                                                 sendedCommand = ""
                        onTextChanged: inputCommand.contentY = inputCommand.contentHeight - inputCommand.height
//                        onLineCountChanged: inputCommand.contentY = inputCommand.contentHeight - inputCommand.height
                    }
                }
            }
        }
    }

    onSendedCommandChanged:
    {
        if(sendedCommand != "")
        {
            sendCommand = sendedCommand;
            runCommand(sendCommand);
            sendedCommand = "";
            consoleCmd.text = sendedCommand;
        }

    }



    onRunCommand:
    {
        logicMainApp.requestToService("DapRunCmdCommand", command);
    }

    Component.onCompleted: {
        consoleCmd.forceActiveFocus()
    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: viewConsole
        horizontalOffset: 2
        verticalOffset: 2
        radius: 10
        samples: 10
        cached: true
        color: "#2A2C33"
        source: viewConsole
        visible: viewConsole.visible
    }
    InnerShadow {
        anchors.fill: viewConsole
        horizontalOffset: -1
        verticalOffset: -1
        radius: 0
        samples: 10
        cached: true
        color: "#4C4B5A"
        source: topLeftSadow
        visible: viewConsole.visible
    }

    Connections
    {
        target: dapServiceController
        onCmdRunned:
        {
            modelConsoleCommand.append({query: asAnswer[0], response: asAnswer[1]});
        }
    }
}

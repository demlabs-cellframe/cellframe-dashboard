import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

DapConsoleScreenForm
{
    ///@detalis sendCommand Text of command from the inputCommand
    property string sendCommand
    ///@detalis historyCommand Text of command from the command history
    property string historyCommand
    ///@detalis receivedAnswer Answer for the sended command
    property string receivedAnswer

    signal runCommand(string command)

    Component.onCompleted:
    {
        //The start point for using history
        consoleHistoryIndex = -1
        //Set previous input
        currentCommand = consoleModule.currentInputCommand
        //Set focus to console input
        consoleInput.forceActiveFocus()
    }

    Component.onDestruction:
    {
        //Save previous input
        consoleModule.currentInputCommand = currentCommand
        consoleModule.clearModel()
    }

    Component
    {
        id: delegateConsoleCommand

        ColumnLayout
        {
            width: parent.width

            Rectangle
            {
                Layout.fillWidth: true
                implicitHeight: textQuery.height
                radius: 2
                color: currTheme.secondaryBackground

                TextEdit
                {
                    width: parent.width
                    verticalAlignment: Qt.AlignTop
                    leftPadding: 4
                    topPadding: 3
                    bottomPadding: 3
                    readOnly: true
                    selectByMouse: true
                    id: textQueryArrow
                    text: "➜"
                    wrapMode: TextEdit.NoWrap
                    font.family: "Quicksand"
                    font.pixelSize: 13
                    color: "#9580FF"
                    selectionColor: "#87DCE7"
                    selectedTextColor: "#2E3138"
                }

                TextEdit
                {
                    width: parent.width
                    leftPadding: 21
                    topPadding: 2
                    bottomPadding: 3
                    readOnly: true
                    selectByMouse: true
                    id: textQuery
                    text: modelData.query
                    wrapMode: TextEdit.Wrap
                    font.family: "Quicksand"
                    font.pixelSize: 13
                    color: "#87DCE7"
                    selectionColor: "#87DCE7"
                    selectedTextColor: "#2E3138"
                }

                LinearGradient
                {
                    anchors.fill: parent
                    source: parent
                    start: Qt.point(0,parent.height/2)
                    end: Qt.point(parent.width,parent.height/2)
                    gradient:
                        Gradient {
                            GradientStop
                            {
                                position: 0;
                                color: "#1F87DCE7"
                            }
                            GradientStop
                            {
                                position: 1;
                                color: "#0087DCE7"
                            }
                        }
                }
            }

            Rectangle
            {
                Layout.fillWidth: true
                Layout.topMargin: 0
                Layout.alignment: Qt.AlignTop
                implicitHeight: textResponse.height
                radius: 2
                color: currTheme.secondaryBackground

                LinearGradient
                {
                    anchors.fill: parent
                    source: parent
                    start: Qt.point(0,parent.height/2)
                    end: Qt.point(parent.width,parent.height/2)
                    gradient:
                        Gradient {
                            GradientStop
                            {
                                position: 0;
                                color: "#1FAABCDE"
                            }
                            GradientStop
                            {
                                position: 1;
                                color: "#00AABCDE"
                            }
                        }
                }

                TextEdit
                {
                    width: parent.width
                    leftPadding: 4
                    bottomPadding: 3
                    topPadding: 1
                    readOnly: true
                    selectByMouse: true
                    id: textResponse
                    text: modelData.response
                    wrapMode: TextEdit.Wrap
                    font.family: "Quicksand"
                    font.pixelSize: 13
                    color: "#AABCDE"
                    selectionColor: "#AABCDE"
                    selectedTextColor: "#2E3138"
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    //Send command from inputCommand TextArea
    onSendedCommandChanged:
    {
        if(sendedCommand != "")
        {
            sendCommand = "[" + dapConsoleRigthPanel.currentTime() + "] " + sendedCommand;
            consoleHistoryIndex = -1;
            runCommand(sendedCommand);
            sendedCommand = "";
            currentCommand = sendedCommand;
        }

    }

    //Send command fron right history panel
    onHistoryCommandChanged:
    {
        if(historyCommand != "")
        {
            sendCommand = historyCommand;
            runCommand(dapConsoleRigthPanel.parsingTime(sendCommand, 1));
            consoleHistoryIndex = -1;
        }
    }

    //Using KeyUp and KeyDown to serf on console history
    onConsoleHistoryIndexChanged:
    {
        if(consoleHistoryIndex < 0)
        {
            currentCommand = "";
            consoleHistoryIndex = -1;
            return;
        }
        else if(consoleHistoryIndex >= dapConsoleRigthPanel.dapModelHistoryConsole.count)
            consoleHistoryIndex = dapConsoleRigthPanel.dapModelHistoryConsole.count;
        currentCommand = dapConsoleRigthPanel.dapModelHistoryConsole.get(consoleHistoryIndex).query;
        return;
    }
}

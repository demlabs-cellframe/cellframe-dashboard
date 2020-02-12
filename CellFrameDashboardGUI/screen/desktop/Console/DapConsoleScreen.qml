import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

DapConsoleScreenForm
{
    property alias dapModelConsoleCommand: modelConsoleCommand
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
        //Set focus to console input
        consoleInput.forceActiveFocus()
    }

    QtObject
    {
        id: themeConsole
        property font inputCommandFont:
            Qt.font({
                        pixelSize: 18 * pt,
                        family: "Roboto",
                        styleName: "Normal",
                        weight: Font.Normal
                    })

        property font consoleCommandFont:
            Qt.font({
                        pixelSize: 18 * pt,
                        family: "Roboto",
                        styleName: "Normal",
                        weight: Font.Normal
                    })
    }

    ListModel
    {
        id: modelConsoleCommand
    }

    Component
    {
        id: delegateConsoleCommand
        Column
        {
            width: parent.width
            Text
            {
                id: textQuery
                text: "> " + query
                font: themeConsole.consoleCommandFont
            }
            Text
            {
                id: textResponse
                text: response
                width: parent.width
                wrapMode: Text.Wrap
                font: themeConsole.consoleCommandFont
            }
        }
    }

    //Send command from inputCommand TextArea
    onSendedCommandChanged:
    {
        if(sendedCommand != "")
        {
            sendCommand = sendedCommand;
            consoleHistoryIndex = -1;
            runCommand(sendCommand);
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
            runCommand(sendCommand);
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

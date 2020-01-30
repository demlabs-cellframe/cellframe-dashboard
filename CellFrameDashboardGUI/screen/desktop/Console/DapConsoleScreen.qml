import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

DapConsoleScreenForm
{
    ///@detalis sendCommand Text of command from the inputCommand
    property string sendCommand
    ///@detalis historyCommand Text of command from the command history
    property string historyCommand
    ///@detalis receivedAnswer Answer for the sended command
    property string receivedAnswer


    Component.onCompleted:
    {
        //The start point for using history
        consoleHistoryIndex = modelConsoleCommand.count
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
        ListElement
        {
            query: "Command"
            response: "This answer"
        }
        ListElement
        {
            query: "Command"
            response: "This answer may be very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long"
        }
        ListElement
        {
            query: "One little query"
            response: "One little response"
        }


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
            modelConsoleCommand.append({query: sendedCommand, response: receivedAnswer});
            consoleHistoryIndex = modelConsoleCommand.count;
            sendedCommand = "";
        }
    }

    //Send command fron right history panel
    onHistoryCommandChanged:
    {
        sendCommand = historyCommand;
        modelConsoleCommand.append({query: sendCommand, response: receivedAnswer});
        consoleHistoryIndex = modelConsoleCommand.count;
    }

    //Using KeyUp and KeyDown to serf on console history
    onConsoleHistoryIndexChanged:
    {
        if(consoleHistoryIndex >= 0)
        {
            if(consoleHistoryIndex >= modelConsoleCommand.count)
            {
                consoleHistoryIndex = modelConsoleCommand.count;
                currentCommand = "";
                return;
            }
        }
        else
            consoleHistoryIndex = 0;
        currentCommand = modelConsoleCommand.get(consoleHistoryIndex).query;
        return;
    }
}

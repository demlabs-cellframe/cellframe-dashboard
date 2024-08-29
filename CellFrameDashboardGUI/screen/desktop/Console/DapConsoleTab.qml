import QtQuick 2.4
import QtQuick.Controls 2.5
import "qrc:/"
import "../../"
import "../controls"

DapPage
{
    property bool isConsoleRequest: false


    id: consoleTab

    property alias dapConsoleRigthPanel: consoleRigthPanel
    ///@detalis rAnswer Answer for the sended command
    property string rAnswer

    dapHeader.initialItem: DapConsoleTopPanel { }

    dapScreen.initialItem:
        DapConsoleScreen
        {
            id: consoleScreen
            //Set receivedAnswer of dapScreen to the external variable rAnswer for the displaying it in console
            receivedAnswer: rAnswer
            //Assign historyCommand of dapScreen with dapRightPanel.historyQuery for ability to use right history panel to send command to the console
            historyCommand: consoleRigthPanel.historyQuery

            onRunCommand:
            {
                isConsoleRequest = true

                consoleModule.runCommand(command)
            }
        }


    dapRightPanel.initialItem:
        DapConsoleRightPanel
        {
            id: consoleRigthPanel
            commandQuery: consoleScreen.sendCommand
        }


    Connections
    {
        target: dapServiceController
        function onHistoryExecutedCmdReceived(rcvData)
        {
            var jsonDocument = JSON.parse(rcvData)
            var aHistory = jsonDocument.result
            for(var x=0; x < aHistory.length; ++x)
            {
                consoleScreen.sendCommand = aHistory[x]
            }
        }
    }
}

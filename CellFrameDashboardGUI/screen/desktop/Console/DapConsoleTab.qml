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

    dapHeader.initialItem: DapTopPanel { }

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
                dapServiceController.requestToService("DapRunCmdCommand", command, "isConsole");
                dapServiceController.notifyService("DapSaveHistoryExecutedCmdCommand", command);
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
        function onCmdRunned(asAnswer)
        {
            if (isConsoleRequest)
            {
                consoleScreen.dapModelConsoleCommand.append({query: asAnswer[0], response: asAnswer[1]});
                isConsoleRequest = false
                consoleScreen.listView.positionViewAtEnd()
            }
        }
        function onHistoryExecutedCmdReceived(aHistory)
        {
            for(var x=0; x < aHistory.length; ++x)
            {
                consoleScreen.sendCommand = aHistory[x]
            }
        }
    }
}

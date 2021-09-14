import QtQuick 2.4
import "qrc:/"
import "../../"

DapAbstractTab
{
    id: consoleTab

    property alias dapConsoleScreen: consoleScreen
    property alias dapConsoleRigthPanel: consoleRigthPanel
    ///@detalis rAnswer Answer for the sended command
    property string rAnswer

    dapTopPanel: DapConsoleTopPanel { }

    dapScreen:
        DapConsoleScreen
        {
            id: consoleScreen
            //Set receivedAnswer of dapScreen to the external variable rAnswer for the displaying it in console
            receivedAnswer: rAnswer
            //Assign historyCommand of dapScreen with dapRightPanel.historyQuery for ability to use right history panel to send command to the console
            historyCommand: dapRightPanel.historyQuery
        }

    dapRightPanel:
        DapConsoleRightPanel
        {
            id: consoleRigthPanel
            anchors.fill: parent
            //Assign commandQuery of dapRightPanel with dapScreen.sendCommand for set it to right history panelfrome console
            commandQuery: dapScreen.sendCommand
        }
}

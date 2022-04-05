import QtQuick 2.4
import "qrc:/"
import "../../"
import QtQuick.Controls 1.4
import "qrc:/screen/controls"

DapPage
{
    id: consoleTab
    property string rAnswer
    property var _dapServiceController: dapServiceController
    readonly property var currentIndex: 8
    property bool isConsoleRequest: false

    dapHeader.initialItem: DapConsoleTopPanel {}

    dapScreen.initialItem: DapConsoleScreen
    {
        id: consoleScreen
    }

    dapRightPanel.initialItem: DapConsoleRightPanel {}

    Connections
    {
        target: dapServiceController
        onCmdRunned:
        {
            if (isConsoleRequest)
            {
                consoleScreen.dapModelConsoleCommand.append({query: asAnswer[0], response: asAnswer[1]});
                isConsoleRequest = false
                consoleScreen.listView.positionViewAtEnd()
            }
        }
        onHistoryExecutedCmdReceived:
        {
            for(var x=0; x < aHistory.length; ++x)
            {
                dapScreen.sendCommand = aHistory[x]
            }
        }
    }
}

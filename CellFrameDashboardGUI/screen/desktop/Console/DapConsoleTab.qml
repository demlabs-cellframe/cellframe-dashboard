import QtQuick 2.4
import "qrc:/"

DapConsoleTabForm
{
    color: currTheme.backgroundMainScreen
    _dapServiceController: dapServiceController
    property bool isConsoleRequest: false

    dapConsoleScreen.onRunCommand:
    {
        isConsoleRequest = true
        dapServiceController.requestToService("DapRunCmdCommand", command, "isConsole");
        dapServiceController.notifyService("DapSaveHistoryExecutedCmdCommand", command);
    }

    Connections
    {
        target: dapServiceController
        onCmdRunned:
        {
            if (isConsoleRequest)
            {
                dapConsoleScreen.dapModelConsoleCommand.append({query: asAnswer[0], response: asAnswer[1]});
                isConsoleRequest = false
                dapConsoleScreen.listView.positionViewAtEnd()
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

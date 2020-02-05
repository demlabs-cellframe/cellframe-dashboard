import QtQuick 2.4
import "qrc:/"

DapConsoleTabForm
{
    dapConsoleScreen.onRunCommand:
    {
        dapServiceController.requestToService("DapRunCmdCommand", command);
        dapServiceController.notifyService("DapSaveHistoryExecutedCmdCommand", command);
    }

    Connections
    {
        target: dapServiceController
        onCmdRunned:
        {
            dapConsoleScreen.dapModelConsoleCommand.append({query: asAnswer[0], response: asAnswer[1]});
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

import QtQuick 2.4
import "qrc:/"
import "../../"
import "../controls"

DapPage
{
    id: logsTab

    ///Log window model.
    ListModel
    {
        id:dapLogsModel
    }

    dapHeader.initialItem: DapLogsTopPanel {}

    dapScreen.initialItem: DapLogsScreen {}

    dapRightPanel.initialItem: DapLogsRightPanel {}

    Timer
    {
           id: updLogTimer
           interval: 5000
           repeat: true
           onTriggered:
           {
               console.log("LOG TIMER TICK")
               logicMainApp.requestToService("DapUpdateLogsCommand", "100");
           }
    }

    Component.onCompleted:
    {
        console.log("Log tab open")
        logicMainApp.requestToService("DapUpdateLogsCommand", "100");
        updLogTimer.start()
    }

    Component.onDestruction:
    {
        console.log("Log tab close")
        updLogTimer.stop()
    }
}

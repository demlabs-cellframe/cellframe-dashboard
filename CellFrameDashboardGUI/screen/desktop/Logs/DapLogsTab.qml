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
               dapServiceController.notifyService("DapUpdateLogsCommand", 100);
           }
    }

    Component.onCompleted:
    {
        console.log("Log tab open")
        dapServiceController.notifyService("DapUpdateLogsCommand", 100);
        updLogTimer.start()
    }

    Component.onDestruction:
    {
        console.log("Log tab close")
        dapServiceController.notifyService("DapUpdateLogsCommand","stop");
        updLogTimer.stop()
    }
}

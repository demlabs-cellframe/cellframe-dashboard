import QtQuick 2.4
import "qrc:/"
import "../../"

DapAbstractTab
{
    id: logsTab
    color: currTheme.backgroundMainScreen
    ///Log window model.
    ListModel
    {
        id:dapLogsModel
    }

    dapTopPanel: DapLogsTopPanel { }

    dapScreen: DapLogsScreen { }

    dapRightPanel: DapLogsRightPanel { }

    Component.onCompleted:
    {
        console.log("Log tab open")
        dapServiceController.notifyService("DapUpdateLogsCommand","start", 100);
    }

    Component.onDestruction:
    {
        console.log("Log tab close")
        dapServiceController.notifyService("DapUpdateLogsCommand","stop");
    }
}

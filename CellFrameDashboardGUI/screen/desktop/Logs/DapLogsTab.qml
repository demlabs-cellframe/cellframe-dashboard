import QtQuick 2.4

DapLogsTabForm
{
    ///Log window model.
    ListModel
    {
        id:dapLogsModel
    }

    Component.onCompleted:
    {
        console.log("Log tab open")
        dapServiceController.notifyService("DapUpdateLogsCommand","start", 200);
    }

    Component.onDestruction:
    {
        console.log("Log tab close")
        dapServiceController.notifyService("DapUpdateLogsCommand","stop");
    }
}

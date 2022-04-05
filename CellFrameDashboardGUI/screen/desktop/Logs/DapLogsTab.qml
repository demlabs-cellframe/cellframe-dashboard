import QtQuick 2.4
import "qrc:/"
import "../../"
import "qrc:/screen/controls"

DapPage
{
    readonly property var currentIndex: 9

    id: logsTab
    //color: currTheme.backgroundMainScreen
    ///Log window model.
    ListModel
    {
        id:dapLogsModel
    }

    dapHeader.initialItem: DapLogsTopPanel {}

    dapScreen.initialItem: DapLogsScreen {}

    dapRightPanel.initialItem: DapLogsRightPanel {}

    Connections
    {
        target: dapMainPage
        onUpdatePage:
        {
            if(index === currentIndex)
            {
                update()
                updateComboBox()
            }
        }
    }
    Connections
    {
        target: dapMainPage
        onUpdatePage:
        {
            if(index === currentIndex)
            {
                console.log("Log tab open")
                dapServiceController.notifyService("DapUpdateLogsCommand","start", 100);
            }
            else
            {
                console.log("Log tab close")
                dapServiceController.notifyService("DapUpdateLogsCommand","stop");
            }
        }
    }
}

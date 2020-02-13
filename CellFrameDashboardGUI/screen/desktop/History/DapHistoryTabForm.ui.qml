import QtQuick 2.4
import "qrc:/"
import "../../"

DapAbstractTab 
{
    id: historyTab

    property alias dapHistoryTopPanel: historyTopPanel
    property alias dapHistoryScreen: historyScreen

    dapTopPanel:
        DapHistoryTopPanel
        {
            id: historyTopPanel
        }

    dapScreen:
        DapHistoryScreen
        {
            id: historyScreen
        }

    dapRightPanel:
        DapHistoryRightPanel
        {
            visible: false
        }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

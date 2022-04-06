import QtQuick 2.4
import "qrc:/"
import "../../"

DapAbstractTab 
{
    id: historyTab

    property alias dapHistoryTopPanel: historyTopPanel
    property alias dapHistoryScreen: historyScreen
    color: currTheme.backgroundPanel

    dapTopPanel:
        DapHistoryTopPanel
        {
            id: historyTopPanel
            color: currTheme.backgroundPanel
        }

    dapScreen:
        DapHistoryScreen
        {
            id: historyScreen
        }

    dapRightPanel:
        Item { visible: false }

//        DapHistoryRightPanel
//        {
//            visible: false
//        }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

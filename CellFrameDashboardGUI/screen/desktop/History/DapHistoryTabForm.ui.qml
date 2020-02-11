import QtQuick 2.4
import "qrc:/"
import "../../"

DapAbstractTab 
{
    id: historyTab

    dapTopPanel: DapHistoryTopPanel { }

    dapScreen: DapHistoryScreen { }

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

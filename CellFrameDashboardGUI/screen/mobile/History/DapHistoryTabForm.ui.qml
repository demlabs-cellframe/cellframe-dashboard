import QtQuick 2.4
import "qrc:/"
import "../../"

DapTab {
    id: dapHistoryTab

    anchors.fill: parent

    topPanelForm: DapHistoryTopPanelForm { }

    screenForm: DapHistoryScreenForm { }

    rightPanelForm: DapHistoryRightPanelForm { }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

import QtQuick 2.4
import "qrc:/"

DapTabForm {
    id: dapHistoryTab

    anchors.fill: parent

    dapTopPanel: DapHistoryTopPanel { }

    dapScreen: DapHistoryScreen { }

    dapRightPanel: DapHistoryRightPanel { }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

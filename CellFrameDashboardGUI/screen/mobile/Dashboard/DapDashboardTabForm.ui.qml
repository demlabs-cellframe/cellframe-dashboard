import QtQuick 2.4
import "qrc:/"

DapTabForm {
    id: dapDashboardTab

    anchors.fill: parent

    topPanelForm: DapDashboardTopPanel { }

    rightPanelForm: DapDashboardRightPanel { }

    screenForm: DapDashboardScreen { }
}









/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

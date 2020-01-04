import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/"
import "../../"

DapAbstractTab
{
    id: dashboardTab

    property alias dapDashboardRightPanel: rightPanelLoader
    property alias dapDashboardTopPanel: dashboardTopPanel

    dapTopPanel: 
        DapDashboardTopPanel 
        { 
            id: dashboardTopPanel
        }

    dapScreen: DapDashboardScreen { }

    dapRightPanel:
        Loader
        {
            id: rightPanelLoader
            anchors.fill: parent
            width: 400
        }
}









/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

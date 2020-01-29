import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"

DapAbstractTab
{
    id: dashboardTab

    property alias dapDashboardRightPanel: rightPanelLoader
    property alias dapDashboardTopPanel: dashboardTopPanel
    property alias dapDashboardScreen: dashboardScreen

    dapTopPanel: 
        DapDashboardTopPanel 
        { 
            id: dashboardTopPanel
        }

    dapScreen:
        DapDashboardScreen
        {
            id: dashboardScreen
        }

    dapRightPanel:
        StackView
        {
            id: rightPanelLoader
            anchors.fill: parent
            width: 400
            delegate:
                StackViewDelegate
                {
                    pushTransition: StackViewTransition { }
                }
        }
}









/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

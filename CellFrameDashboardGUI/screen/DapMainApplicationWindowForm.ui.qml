import QtQuick 2.4
import "qrc:/"

DapMainWindowForm 
{
    anchors.fill: parent
    iconLogotype.source: "qrc:/res/icons/cellframe-logo-dashboard.png"
    menuTabWidget.viewMenuTab.model: modelMenuTab
       
    ListModel 
    {
        id: modelMenuTab

        ListElement 
        {
            name: qsTr("Dashboard")
            page: "qrc:/screen/Dashboard/DapDashboardTab.qml"
            normalIcon: "qrc:/res/icons/icon_dashboard.png"
            hoverIcon: "qrc:/res/icons/icon_dashboard_hover.png"
        }

        ListElement 
        {
            name: qsTr("Exchange")
            page: "qrc:/screen/Exchange/DapExchangeTab.qml"
            normalIcon: "qrc:/res/icons/icon_exchange.png"
            hoverIcon: "qrc:/res/icons/icon_exchange_hover.png"
        }

        ListElement 
        {
            name: qsTr("History")
            page: "qrc:/screen/History/DapHistoryTab.qml"
            normalIcon: "qrc:/res/icons/icon_history.png"
            hoverIcon: "qrc:/res/icons/icon_history_hover.png"
        }
    }
    
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

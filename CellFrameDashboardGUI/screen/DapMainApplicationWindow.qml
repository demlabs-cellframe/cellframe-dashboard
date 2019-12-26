import QtQuick 2.4

DapMainApplicationWindowForm 
{
    ///@detalis Path to the dashboard tab.
    readonly property string dashboardScreen: "qrc:/screen/" + device + "/Dashboard/DapDashboardTab.qml"
    ///@detalis Path to the exchange tab.
    readonly property string exchangeScreen: "qrc:/screen/" + device + "/Exchange/DapExchangeTab.qml"
    ///@detalis Path to the history tab.
    readonly property string historyScreen: "qrc:/screen/" + device + "/History/DapHistoryTab.qml"

    // Menu bar tab model
    ListModel 
    {
        id: modelMenuTab
        
        Component.onCompleted: {

            append({
                name: qsTr("Dashboard"),
                page: dashboardScreen,
                normalIcon: "qrc:/res/icons/icon_dashboard.png",
                hoverIcon: "qrc:/res/icons/icon_dashboard_hover.png"
            })
    
            append ({
                name: qsTr("Exchange"),
                page: exchangeScreen,
                normalIcon: "qrc:/res/icons/icon_exchange.png",
                hoverIcon: "qrc:/res/icons/icon_exchange_hover.png"
            })
    
            append ({
                name: qsTr("History"),
                page: historyScreen,
                normalIcon: "qrc:/res/icons/icon_history.png",
                hoverIcon: "qrc:/res/icons/icon_history_hover.png"
            })
        }
    }

    dapScreenLoader.source: dashboardScreen
    
    dapMenuTabWidget.onPathScreenChanged:
    {
        dapScreenLoader.setSource(Qt.resolvedUrl(dapMenuTabWidget.pathScreen))
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

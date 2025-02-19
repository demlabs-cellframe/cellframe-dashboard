import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
//import "../../desktop/VPNService/"
import "../controls"
import "Parts"
import "RightPanel"

DapPage {

    ///@detalis Path to the right panel of input name wallet.
    readonly property string createOrder: "qrc:/screen/desktop/VPNService/RightPanel/CreateOrder.qml"
    readonly property string earnedFundsOrder: "qrc:/screen/desktop/VPNService/RightPanel/DapEarnedFunds.qml"
    readonly property string doneOrder: "qrc:/screen/desktop/Dashboard/RightPanel/DapDoneWalletRightPanel.qml"
    readonly property string orderDetails: "qrc:/screen/desktop/VPNService/RightPanel/DapOrderDetails.qml"

    id: vpnServiceTab

    QtObject {
        id: navigator

        function createOrderFunc() {
            if(state !== "ORDERSHOW")
                state = "ORDERCREATE"
            dapRightPanel.push(createOrder)
        }

        function doneCreateOrderFunc(){
            dapRightPanel.push(doneOrder)
        }

        function orderDetailsFunc() {
            dapRightPanel.push(orderDetails)
        }

        function earnedFundsFunc(){
            dapRightPanel.push(earnedFundsOrder)
        }

        function popPage() {
            dapRightPanel.pop()
        }
    }


    dapScreen.initialItem:
        DapVPNServiceScreen
        {
            id: vpnServiceScreen
            dapAddOrderButton.onClicked: {
                navigator.createOrderFunc()
            }
            dapGridViewFrame.onOrderDetailsShow:
            {
                //TODO: no backend
                navigator.popPage()
                navigator.orderDetailsFunc()
            }
        }

    dapHeader.initialItem:
        DapVPNServiceTopPanel
        {
//            color: currTheme.backgroundPanel
            id: vpnServicetTopPanel
            dapAddOrderButton.onClicked: {
                navigator.createOrderFunc()
            }

        }

    dapRightPanel.initialItem: DapEarnedFunds{}

    state: "ORDERDEFAULT"

    states:
        [
            State
            {
                name: "ORDERDEFAULT"
                PropertyChanges
                {
                    target: vpnServiceScreen.dapOrderCreateFrame;
                    visible: true
                }
                PropertyChanges
                {
                    target: vpnServiceScreen.dapFrameTitleCreateOrder;
                    visible: false
                }
                PropertyChanges
                {
                    target: vpnServiceScreen.dapGridViewOrder;
                    visible: false
                }
                PropertyChanges
                {
                    target: dapHeaderFrame;
                    visible: false
                }
                PropertyChanges
                {
                    target: dapRightPanelFrame;
                    visible: false
                }
            },
            State
            {
                name: "ORDERSHOW"
                PropertyChanges
                {
                    target: vpnServiceScreen.dapOrderCreateFrame;
                    visible: false
                }
                PropertyChanges
                {
                    target: vpnServiceScreen.dapFrameTitleCreateOrder;
                    visible: false
                }
                PropertyChanges
                {
                    target: vpnServiceScreen.dapGridViewOrder;
                    visible: true
                }
                PropertyChanges
                {
                    target: dapHeaderFrame;
                    visible: true
                }
                PropertyChanges
                {
                    target: dapRightPanelFrame;
                    visible: true
                }
            },
            State
            {
                name: "ORDERCREATE"
                PropertyChanges
                {
                    target: vpnServiceScreen.dapOrderCreateFrame;
                    visible: false
                }
                PropertyChanges
                {
                    target: vpnServiceScreen.dapFrameTitleCreateOrder;
                    visible: true
                }
                PropertyChanges
                {
                    target: vpnServiceScreen.dapGridViewOrder;
                    visible: false
                }
                PropertyChanges
                {
                    target: dapHeaderFrame;
                    visible: false
                }
                PropertyChanges
                {
                    target: dapRightPanelFrame;
                    visible: true
                }
            }
        ]
    // Signal-slot connection realizing panel switching depending on predefined rules

    Connections
    {
        target: dapMainWindow
        function onModelOrdersUpdated()
        {
            if(dapModelOrders.count > 0)
                state = "ORDERSHOW"
            else
                state = "ORDERDEFAULT"
        }
    }

    Timer {
        id: updateOrderTimer
        interval: logicMainApp.autoUpdateInterval; running: false; repeat: true
        onTriggered:
        {
            console.log("ORDER TIMER TICK")
            logicMainApp.requestToService("DapGetListOrdersCommand");
        }
    }

    Component.onCompleted:
    {
        if(dapModelOrders.count > 0)
            state = "ORDERSHOW"
        else
            state = "ORDERDEFAULT"

        if (!updateOrderTimer.running)
            updateOrderTimer.start()
    }
    Component.onDestruction:
    {
        updateOrderTimer.stop()
    }
}

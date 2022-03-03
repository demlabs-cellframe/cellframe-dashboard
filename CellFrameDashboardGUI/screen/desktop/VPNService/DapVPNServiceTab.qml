import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
//import "../../desktop/VPNService/"
import "qrc:/screen/controls"
import "Parts"
import "RightPanel"

DapPage {

    ///@detalis Path to the right panel of input name wallet.
    readonly property string createOrder: "qrc:/screen/desktop/VPNService/RightPanel/CreateOrder.qml"
    readonly property string earnedFundsOrder: "qrc:/screen/desktop/VPNService/RightPanel/EarnedFunds.qml"
    readonly property string doneOrder: "qrc:/screen/desktop/Dashboard/RightPanel/DapDoneWalletRightPanel.qml"

    readonly property string orderDetails: "qrc:/screen/desktop/VPNService/RightPanel/OrderDetails.qml"

    readonly property var currentIndex: 7
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

    dapRightPanel.initialItem: EarnedFunds{}

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
                    target: dapRightPanel;
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
                    target: dapRightPanel;
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
                    target: dapRightPanel;
                    visible: true
                }
            }
        ]
    // Signal-slot connection realizing panel switching depending on predefined rules
//    Connections
//    {
//        target: dapRightPanel
//        onNextActivated:
//        {
//            if(parametrsRightPanel !== createOrder)
//                vpnServiceScreen.dapFrameTitleCreateOrder.visible = false;
//            currentRightPanel = dapVPNServiceRightPanel.push(currentRightPanel.dapNextRightPanel);
//            if(parametrsRightPanel === earnedFundsOrder)
//            {
//                if(_dapModelOrders.count === 0)
//                    state = "ORDERDEFAULT"
//                vpnServiceScreen.dapGridViewFrame.currentIndex = -1
////                console.log("DapGetListOrdersCommand")
////                dapServiceController.requestToService("DapGetListOrdersCommand");
//            }
//        }
//        onPreviousActivated:
//        {
//            dapRightPanel.pop(null)

//            if(parametrsRightPanel !== createOrder)
//                vpnServiceScreen.dapFrameTitleCreateOrder.visible = false;
//            currentRightPanel = dapVPNServiceRightPanel.push(currentRightPanel.dapPreviousRightPanel);
//            if(parametrsRightPanel === earnedFundsOrder)
//            {
//                if(_dapModelOrders.count === 0)
//                    state = "ORDERDEFAULT"
//                vpnServiceScreen.dapGridViewFrame.currentIndex = -1
////                console.log("DapGetListOrdersCommand")
////                dapServiceController.requestToService("DapGetListOrdersCommand");
//            }
//        }
//    }

    Connections
    {
        target: dapMainPage
        onModelOrdersUpdated:
        {
            if(_dapModelOrders.count > 0)
                state = "ORDERSHOW"
            else
                state = "ORDERDEFAULT"
        }
    }

    Connections
    {
        target: dapServiceController
        onMempoolProcessed:
        {
            update()
        }
        onWalletCreated:
        {
            update()
        }
    }

    function update()
    {
        dapIndexCurrentWallet = dashboardTopPanel.dapComboboxWallet.currentIndex
        dapOrders.length = 0
        _dapModelOrders.clear()
        dapServiceController.requestToService("DapGetListOrdersCommand");

    }

    Component.onCompleted:
    {
        if(_dapModelOrders && _dapModelOrders.count > 0)
            state = "ORDERSHOW"
        else
            state = "ORDERDEFAULT"
    }
}

import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../../desktop/VPNService_New/"

DapAbstractTab {

    ///@detalis Path to the right panel of input name wallet.
    readonly property string createOrder: "qrc:/screen/" + device + "/VPNService_New/DapCreateOrder.qml"
    readonly property string orderDetails: "qrc:/screen/" + device + "/VPNService_New/DapOrderDetails.qml"
    readonly property string earnedFundsOrder: "qrc:/screen/" + device + "/VPNService_New/DapEarnedFunds.qml"
    readonly property string doneOrder: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapDoneWalletsssRightPanel.qml"
    id: vpnServiceTab

    property alias dapVPNServiceRightPanel: stackViewRightPanel
    color: currTheme.backgroundMainScreen


    dapScreen:
        DapVPNServiceScreen
        {
            id: vpnServiceScreen
            dapAddOrderButton.onClicked: {
                createOrderFunc()
                vpnServiceScreen.dapOrderCreateFrame.visible = false
//                vpnServiceScreen.dapFrameTitleCreateOrder.visible = false;
            }
        }

    dapTopPanel:
        DapVPNServiceTopPanel
        {
            color: currTheme.backgroundPanel
            id: vpnServicetTopPanel
            dapAddOrderButton.onClicked: {
                createOrderFunc()
                vpnServiceScreen.dapOrderCreateFrame.visible = false
//                vpnServiceScreen.dapFrameTitleCreateOrder.visible = false;
            }

        }

    dapRightPanel:
        StackView
        {
            id: stackViewRightPanel
            initialItem: Qt.resolvedUrl(earnedFundsOrder);
            anchors.fill: parent
            width: 400
            delegate:
                StackViewDelegate
                {
                    pushTransition: StackViewTransition { }
                }
        }
    state: "ORDERDEFAULT"
//    state: "ORDERSHOW"
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
    Connections
    {
        target: currentRightPanel
        onNextActivated:
        {
            if(parametrsRightPanel !== createOrder)
                vpnServiceScreen.dapFrameTitleCreateOrder.visible = false;
            currentRightPanel = dapVPNServiceRightPanel.push(currentRightPanel.dapNextRightPanel);
            if(parametrsRightPanel === earnedFundsOrder)
            {
                if(dapModelOrders.count === 0)
                    state = "ORDERDEFAULT"
                vpnServiceScreen.dapGridViewFrame.currentIndex = -1
//                console.log("DapGetListOrdersCommand")
//                dapServiceController.requestToService("DapGetListOrdersCommand");
            }
        }
        onPreviousActivated:
        {
            if(parametrsRightPanel !== createOrder)
                vpnServiceScreen.dapFrameTitleCreateOrder.visible = false;
            currentRightPanel = dapVPNServiceRightPanel.push(currentRightPanel.dapPreviousRightPanel);
            if(parametrsRightPanel === earnedFundsOrder)
            {
                if(dapModelOrders.count === 0)
                    state = "ORDERDEFAULT"
                vpnServiceScreen.dapGridViewFrame.currentIndex = -1
//                console.log("DapGetListOrdersCommand")
//                dapServiceController.requestToService("DapGetListOrdersCommand");
            }
        }
    }

    Connections
    {
        target: dapMainWindow
        onModelOrdersUpdated:
        {
            console.log(dapModelOrders.count)

            if(dapModelOrders.count > 0)
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
    Connections
    {
        target: vpnServiceScreen.dapGridViewFrame
        onOrderDetailsShow:
        {
            detailsShow(index);
        }
    }

    function update()
    {
        dapIndexCurrentWallet = dashboardTopPanel.dapComboboxWallet.currentIndex
        dapOrders.length = 0
        dapModelOrders.clear()
        dapServiceController.requestToService("DapGetListOrdersCommand");
    }


    function createOrderFunc()
    {
        if(state !== "ORDERSHOW")
            state = "ORDERCREATE"
        currentRightPanel = stackViewRightPanel.push({item:Qt.resolvedUrl(createOrder)});
    }

    //TODO: no backend
    function detailsShow(index_order)
    {
        console.log("Index " + index_order)
        currentRightPanel = stackViewRightPanel.push({item:Qt.resolvedUrl(orderDetails)});
    }

    Component.onCompleted:
    {
        if(dapModelOrders.count > 0)
            state = "ORDERSHOW"
        else
            state = "ORDERDEFAULT"
    }
}

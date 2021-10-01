import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../../desktop/VPNService_New/"

DapAbstractTab {

    ///@detalis Path to the right panel of input name wallet.
    readonly property string createOrder: "qrc:/screen/" + device + "/VPNService_New/DapCreateOrder.qml"

    id: vpnServiceTab

    property alias dapVPNServiceRightPanel: stackViewRightPanel
    property alias dapVPNTest: vpnTest

    Item {
        id: vpnTest

        property alias ordersModel: ordersModel

        ListModel {
            id: ordersModel

            onCountChanged: console.log("VPN TEST ORDERS COUNT CHANGED: " + count);
        }
        Component.onCompleted: {
            for (var i = 0; i < 10; ++ i) {
                ordersModel.append({
                                       name: "order " + i,
                                       dateCreated: "April 22, 2020",
                                       units: 3600,
                                       unitsType: "seconds",
                                       value: 0.1,
                                       token: "KELT"
                                   });
            }
        }
    }


    dapScreen:
        DapVPNServiceScreen
        {
            id: vpnServiceScreen
            dapAddOrderButton.onClicked: {
                createOrderFunc()
                vpnServiceScreen.dapOrderCreateFrame.visible = false
            }
        }

    dapTopPanel:
        DapVPNServiceTopPanel
        {
            id: vpnServicetTopPanel
            dapAddOrderButton.onClicked: {
                createOrderFunc()
                vpnServiceScreen.dapOrderCreateFrame.visible = false
            }

        }

    dapRightPanel:
        StackView
        {
            id: stackViewRightPanel
            initialItem: Qt.resolvedUrl(lastActionsWallet);
            anchors.fill: parent
            width: 400
            delegate:
                StackViewDelegate
                {
                    pushTransition: StackViewTransition { }
                }
        }
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
//                PropertyChanges
//                {
//                    target: dashboardScreen.dapTitleBlock;
//                    visible: false
//                }
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
//                PropertyChanges
//                {
//                    target: dashboardScreen.dapTitleBlock;
//                    visible: true
//                }
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
                    visible: true
                }
//                PropertyChanges
//                {
//                    target: dashboardScreen.dapTitleBlock;
//                    visible: false
//                }
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
            currentRightPanel = dapVPNServiceRightPanel.push(currentRightPanel.dapNextRightPanel);
//            if(parametrsRightPanel === lastActionsWallet)
//            {
//                console.log("DapGetWalletHistoryCommand")
//                console.log("   network: " + dapServiceController.CurrentNetwork)
//                console.log("   chain: " + dapServiceController.CurrentChain)
//                console.log("   wallet address: " + dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork))
//                dapServiceController.requestToService("DapGetWalletHistoryCommand", dapServiceController.CurrentNetwork, dapServiceController.CurrentChain, dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork));
//            }
        }
        onPreviousActivated:
        {
            currentRightPanel = dapVPNServiceRightPanel.push(currentRightPanel.dapPreviousRightPanel);
//            if(parametrsRightPanel === lastActionsWallet)
//            {
//                console.log("DapGetWalletHistoryCommand")
//                console.log("   network: " + dapServiceController.CurrentNetwork)
//                console.log("   chain: " + dapServiceController.CurrentChain)
//                console.log("   wallet address: " + dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork))
//                dapServiceController.requestToService("DapGetWalletHistoryCommand", dapServiceController.CurrentNetwork, dapServiceController.CurrentChain, dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork));
//            }
        }
    }

    function createOrderFunc()
    {
        if(state !== "ORDERSHOW")
            state = "ORDERCREATE"
        currentRightPanel = stackViewRightPanel.push({item:Qt.resolvedUrl(createOrder)});
    }
}

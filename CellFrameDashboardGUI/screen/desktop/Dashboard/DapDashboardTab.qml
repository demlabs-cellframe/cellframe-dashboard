import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../controls"
import "RightPanel"
import "logic"

DapPage
{
    ///@detalis Path to the right panel of transaction history.
    readonly property string transactionHistoryWallet: path + "/Dashboard/RightPanel/DapTransactionHistoryRightPanel.qml"
    ///@detalis Path to the right panel of input name wallet.
    readonly property string createNewWallet:          path + "/Dashboard/RightPanel/DapCreateWallet.qml"
    ///@detalis Path to the right panel of recovery.
    readonly property string recoveryWallet:           path + "/Dashboard/RightPanel/DapRecoveryWalletRightPanel.qml"
    ///@detalis Path to the right panel of done.
    readonly property string doneWallet:               path + "/Dashboard/RightPanel/DapDoneCreateWallet.qml"
    ///@detalis Path to the right panel of last actions.
    readonly property string lastActionsWallet:        path + "/Dashboard/RightPanel/DapLastActionsRightPanel.qml"
    ///@detalis Path to the right panel of new payment.
    readonly property string newPaymentMain:           path + "/Dashboard/RightPanel/DapNewPaymentMainRightPanel.qml"
    ///@detalis Path to the right panel of new payment done.
    readonly property string newPaymentDone:           path + "/Dashboard/RightPanel/DapNewPaymentDoneRightPanel.qml"

    id: dashboardTab

    property alias dapDashboardScreen: dashboardScreen

    property var walletInfo:
    {
        "name": "",
        "network": "",
        "address": "",
        "chain": "",
        "signature_type": "",
        "recovery_hash": ""
    }
    property var commandResult:
    {
        "success": "",
        "message": ""
    }

    signal walletsUpdated()

    ListModel {id: networksModel}
    LogicWallet{id: logicWallet}

    QtObject {
        id: navigator

        function createWallet()
        {
            modulesController.feeUpdate = false
            txExplorerModule.statusProcessing = false

            state = "WALLETCREATE"

            logicWallet.restoreWalletMode = false
            dapRightPanel.push(createNewWallet)
        }

        function doneWalletFunc()
        {
            modulesController.feeUpdate = false
            txExplorerModule.statusProcessing = true

            dapRightPanel.push(doneWallet)
        }

        function restoreWalletFunc()
        {
            modulesController.feeUpdate = false
            txExplorerModule.statusProcessing = false

            state = "WALLETCREATE"

            logicWallet.restoreWalletMode = true
            dapRightPanel.push(createNewWallet)
        }

        function recoveryWalletFunc()
        {
            modulesController.feeUpdate = false
            txExplorerModule.statusProcessing = false

            dapRightPanel.push(recoveryWallet)
        }

        function newPayment()
        {
            modulesController.feeUpdate = true
            txExplorerModule.statusProcessing = false

            dapRightPanel.push(newPaymentMain)
        }

        function doneNewPayment()
        {
            txExplorerModule.statusProcessing = true
            modulesController.feeUpdate = false

           dapRightPanel.push(newPaymentDone)
        }

        function popPage() {
            txExplorerModule.statusProcessing = true
            modulesController.feeUpdate = false

            dapRightPanel.clear()
            dapRightPanel.push(lastActionsWallet)

            if(!dapModelWallets.count)
                state = "WALLETDEFAULT"
            else
                state = "WALLETSHOW"

        }
    }

    dapHeader.initialItem:
        DapDashboardTopPanel
        {
            id: dashboardTopPanel
            onChangeWalletIndex:{
                dashboardScreen.listViewWallet.model = ""
                dashboardScreen.listViewWallet.model = dapModelWallets.get(modulesController.currentWalletIndex).networks
                txExplorerModule.setWalletName(modulesController.currentWalletName)
                txExplorerModule.updateHistory(true)
                navigator.popPage()
                logicWallet.walletStatus = walletListModel.get(modulesController.currentWalletIndex).statusProtect
            }
        }

    dapScreen.initialItem:
        DapDashboardScreen
        {
            id: dashboardScreen
        }

    dapRightPanel.initialItem:
        DapLastActionsRightPanel
        {
            id: lastActions
        }

    state: "WALLETDEFAULT"

    states:
    [
        State
        {
            name: "WALLETDEFAULT"
            PropertyChanges
            {
                target: dashboardScreen.walletDefaultFrame
                visible: true
            }
            PropertyChanges
            {
                target: dashboardScreen.walletShowFrame
                visible: false
            }
            PropertyChanges
            {
                target: dashboardTopPanel.layout
                visible: false
            }

            //...
            PropertyChanges
            {
                target: dashboardScreen.walletCreateFrame;
                visible: false
            }
        },
        State
        {
            name: "WALLETSHOW"
            PropertyChanges
            {
                target: dashboardScreen.walletDefaultFrame
                visible: false
            }
            PropertyChanges
            {
                target: dashboardScreen.walletShowFrame
                visible: true
            }

            PropertyChanges
            {
                target: dashboardTopPanel.layout
                visible: true
            }

            //...
            PropertyChanges
            {
                target: dashboardScreen.walletCreateFrame;
                visible: false
            }
        },
        State
        {
            name: "WALLETCREATE"
            PropertyChanges
            {
                target: dashboardScreen.walletDefaultFrame;
                visible: false
            }
            PropertyChanges
            {
                target: dashboardScreen.walletShowFrame
                visible: false
            }
            PropertyChanges
            {
                target: dashboardTopPanel.layout
                visible: false
            }

            //...
            PropertyChanges
            {
                target: dashboardScreen.walletCreateFrame;
                visible: true
            }
        }
    ]


    Connections
    {
        target: walletModule
        function onSigWalletsInfo(model)
        {
            logicWallet.updateWalletsModel(model)

            if(!dapModelWallets.count)
            {
                if(state !== "WALLETCREATE")
                {
                    state = "WALLETDEFAULT"
                    navigator.popPage()
                    txExplorerModule.clearHistory()
                }
            }
            walletsUpdated()

            var item = dapModelWallets.get(modulesController.currentWalletIndex);
            if(modulesController.currentWalletIndex >= 0 && item.status)
                logicWallet.walletStatus = item.status || ""
        }
        function onSigWalletInfo(model)
        {

            var item = dapModelWallets.get(modulesController.currentWalletIndex);

//            console.log(model)

            logicWallet.updateWallet(model)

            if(modulesController.currentWalletIndex >= 0 && item.status)
                logicWallet.walletStatus = item.status || ""

        }
    }

    Component.onCompleted:
    {
//        console.log(dashboardScreen.listViewWallet.model)
//        console.log(dapModelWallets.get(modulesController.currentWalletIndex).networks)
//        dashboardScreen.listViewWallet.model = dapModelWallets.get(modulesController.currentWalletIndex).networks
//

        if(dapModelWallets.count)
        {
            dashboardScreen.listViewWallet.model = dapModelWallets.get(modulesController.currentWalletIndex).networks
            if(dashboardTab.state != "WALLETCREATE")
                dashboardTab.state = "WALLETSHOW"
        }
        else
        {
            walletModule.getWalletsInfo("true")
        }

        walletModule.statusProcessing = true
        txExplorerModule.statusProcessing = true
    }

    Component.onDestruction:
    {
        walletModule.statusProcessing = false
        txExplorerModule.statusProcessing = false
    }
}

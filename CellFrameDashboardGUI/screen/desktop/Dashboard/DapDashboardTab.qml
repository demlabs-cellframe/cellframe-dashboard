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
    ///@detalis Path to the right panel of new payment done.
    readonly property string newPaymentAddToQueue:     path + "/Dashboard/RightPanel/DapNewPaymentAddedQueueRightPanel.qml"

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
            txExplorerModule.statusProcessing = false

            state = "WALLETCREATE"

            logicWallet.restoreWalletMode = false
            dapRightPanel.push(createNewWallet)
        }

        function doneWalletFunc()
        {
            txExplorerModule.statusProcessing = true

            state = "WALLETSHOW"

            dapRightPanel.push(doneWallet)
        }

        function restoreWalletFunc()
        {
            txExplorerModule.statusProcessing = false

            state = "WALLETCREATE"

            logicWallet.restoreWalletMode = true
            dapRightPanel.push(createNewWallet)
        }

        function recoveryWalletFunc()
        {
            txExplorerModule.statusProcessing = false

            dapRightPanel.push(recoveryWallet)
        }

        function newPayment()
        {
            txExplorerModule.statusProcessing = false

            dapRightPanel.push(newPaymentMain)
        }

        function doneNewPayment()
        {
            txExplorerModule.statusProcessing = true

           dapRightPanel.push(newPaymentDone)
        }

        function toQueueNewPayment()
        {
            txExplorerModule.statusProcessing = true
            modulesController.feeUpdate = false

           dapRightPanel.push(newPaymentAddToQueue)
        }

        function popPage() {
            txExplorerModule.statusProcessing = true

            dapRightPanel.clear()
            dapRightPanel.push(lastActionsWallet)

            if(!walletModelList.count)
                state = "WALLETDEFAULT"
            else
                state = "WALLETSHOW"

        }
    }

    dapHeader.initialItem:
        DapDashboardTopPanel
        {
            id: dashboardTopPanel
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



    Connections
    {
        target: walletModule
        function onSigWalletInfo(model)
        {

            var item = walletModelList.get(walletModule.currentWalletIndex);

            if(walletModule.currentWalletIndex >= 0 && item.statusProtected)
                walletModelList.get(walletModule.currentWalletIndex).statusProtected = item.statusProtected || ""

        }
    }

    function updateScreen()
    {
        // top panel
        // If there are no wallets, then remove the top panel
        dashboardTopPanel.layout.visible = walletModelList.count 

        // If there are no wallets or the data has not loaded.
        dashboardScreen.walletDefaultFrame.visible = (walletModelList.count || !walletModelList.get(walletModule.currentWalletIndex).isLoad)

        dashboardScreen.walletShowFrame.visible = (walletModelList.count && walletModelList.get(walletModule.currentWalletIndex).isLoad)

        dashboardScreen.walletCreateFrame.visible = (state === "WALLETCREATE" &&  !walletModelList.count)
    }

    Connections
    {
        target: walletModule

        function onCurrentWalletChanged()
        {
            console.log("onCurrentWalletChanged")
            if(walletModelList.count !== 1)
            {
                navigator.popPage()
            }
            updateScreen()
            txExplorerModule.setWalletName(walletModule.getCurrentWalletName())
            txExplorerModule.clearHistory()
            txExplorerModule.updateHistory(true)
        }

        function onListWalletChanged()
        {
            console.log("onListWalletChanged")
            updateScreen()                    
        }

        function onWalletsModelChanged()
        {
            console.log("onWalletsModelChanged")
            updateScreen()
        }
    }

    Connections
    {
        target: modulesController

        function onNodeWorkingChanged()
        {
            if(modulesController.isNodeWorking)
            {
                txExplorerModule.clearHistory()
            }
        }
    }

    Component.onCompleted:
    {
        updateScreen()

        walletModule.statusProcessing = true
        txExplorerModule.statusProcessing = true
    }

    Component.onDestruction:
    {
        walletModule.statusProcessing = false
        txExplorerModule.statusProcessing = false
    }
}

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
    readonly property string createNewWallet: path + "/Settings/RightPanel/DapCreateWallet.qml"
    ///@detalis Path to the right panel of recovery.
    readonly property string recoveryWallet: path + "/Settings/RightPanel/DapRecoveryWalletRightPanel.qml"
    ///@detalis Path to the right panel of done.
    readonly property string doneWallet: path + "/Settings/RightPanel/DapDoneCreateWallet.qml"
    ///@detalis Path to the right panel of last actions.
    readonly property string lastActionsWallet: path + "/Dashboard/RightPanel/DapLastActionsRightPanel.qml"
    ///@detalis Path to the right panel of new payment.
    readonly property string newPaymentMain: path + "/Dashboard/RightPanel/DapNewPaymentMainRightPanel.qml"
    ///@detalis Path to the right panel of new payment done.
    readonly property string newPaymentDone: path + "/Dashboard/RightPanel/DapNewPaymentDoneRightPanel.qml"

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

    ListModel {id: networksModel}
    LogicWallet{id: logicWallet}

    QtObject {
        id: navigator

        function createWallet() {
            if(state !== "WALLETSHOW")
                state = "WALLETCREATE"
            dapRightPanel.push(createNewWallet)
        }

        function doneWalletFunc(){
            dapRightPanel.push(doneWallet)
            dashboardTopPanel.dapNewPayment.enabled = true
        }

        function recoveryWalletFunc()
        {
            dapRightPanel.push(recoveryWallet)
        }

        function newPayment()
        {
            dapRightPanel.push(newPaymentMain)
        }

        function doneNewPayment()
        {
           dapRightPanel.push(newPaymentDone)
        }

        function popPage() {
            dapRightPanel.clear()
            dapRightPanel.push(lastActionsWallet)

            if(!dapModelWallets.count)
                state = "WALLETDEFAULT"
        }
    }

    dapHeader.initialItem: DapDashboardTopPanel
        {
            id: dashboardTopPanel
            dapNewPayment.onClicked:
            {
                walletInfo.name = dapModelWallets.get(logicMainApp.currentWalletIndex).name
                dapRightPanel.pop()
                navigator.newPayment()
            }
        }

    dapScreen.initialItem:
        DapDashboardScreen
        {
            id: dashboardScreen
            dapAddWalletButton.onClicked:
            {
                logicMainApp.restoreWalletMode = false
                navigator.createWallet()
                dashboardScreen.dapWalletCreateFrame.visible = false
                dashboardTopPanel.dapNewPayment.enabled = false
            }
        }

    dapRightPanel.initialItem: DapLastActionsRightPanel{id: lastActions}

    state: "WALLETDEFAULT"

    states:
    [
        State
        {
            name: "WALLETDEFAULT"
            PropertyChanges
            {
                target: dashboardScreen.dapWalletCreateFrame;
                visible: true
            }
            PropertyChanges
            {
                target: dashboardScreen.dapMainFrameDashboard;
                visible: false
            }
            PropertyChanges
            {
                target: dapRightPanelFrame;
                visible: false
            }
            PropertyChanges
            {
                target: dapHeaderFrame
                visible: false
            }
            PropertyChanges
            {
                target: dashboardScreen.dapFrameTitleCreateWallet;
                visible: false
            }
        },
        State
        {
            name: "WALLETSHOW"
            PropertyChanges
            {
                target: dashboardScreen.dapWalletCreateFrame;
                visible: false
            }
            PropertyChanges
            {
                target: dashboardScreen.dapMainFrameDashboard;
                visible: true
            }
            PropertyChanges
            {
                target: dapRightPanelFrame;
                visible: true
            }
            PropertyChanges
            {
                target: dapHeaderFrame
                visible: true
            }
//            PropertyChanges
//            {
//                target: dashboardTopPanel.dapNewPayment
//                visible: true
//            }
//            PropertyChanges
//            {
//                target: dashboardTopPanel.dapFrameTitle
//                visible: true
//            }
            PropertyChanges
            {
                target: dashboardScreen.dapFrameTitleCreateWallet;
                visible: false
            }
        },
        State
        {
            name: "WALLETCREATE"
            PropertyChanges
            {
                target: dashboardScreen.dapWalletCreateFrame;
                visible: true
            }
            PropertyChanges
            {
                target: dashboardScreen.dapMainFrameDashboard;
                visible: false
            }
            PropertyChanges
            {
                target: dapRightPanelFrame;
                visible: true
            }
            PropertyChanges
            {
                target: dapHeaderFrame
                visible: true
            }
//            PropertyChanges
//            {
//                target: dashboardTopPanel.dapNewPayment
//                visible: false
//            }
//            PropertyChanges
//            {
//                target: dashboardTopPanel.dapFrameTitle
//                visible: false
//            }
            PropertyChanges
            {
                target: dashboardScreen.dapFrameTitleCreateWallet;
                visible: true
            }
        }
    ]

    Timer {
        id: updateWalletTimer
        interval: logicMainApp.autoUpdateInterval; running: false; repeat: true
        onTriggered:
        {
            console.log("WALLETS TIMER TICK")

            if(!dapModelWallets.count)
            {
                if(state !== "WALLETCREATE")
                {
                    state = "WALLETDEFAULT"
                    navigator.popPage()
                }

                logicWallet.updateAllWallets()
            }
            else
            {
                logicWallet.updateCurrentWallet()
//                console.log(!walletActivatePopup.isOpen, dapModelWallets.get(logicMainApp.currentWalletIndex).status)

                if(dapModelWallets.get(logicMainApp.currentWalletIndex).status === "non-Active" && !walletActivatePopup.isOpen)
                {
                    walletActivatePopup.show(dapModelWallets.get(logicMainApp.currentWalletIndex).name, true)
                }
                else if(dapModelWallets.get(logicMainApp.currentWalletIndex).status === "Active" && walletActivatePopup.isOpen)
                    walletActivatePopup.hide()
            }
        }
    }

    Connections
    {
        target: dapMainWindow
        function onModelWalletsUpdated()
        {
            logicWallet.updateWalletModel()

            // FOR DEBUG
//            logicWallet.updateCurrentWallet()
        }
    }

    Connections
    {
        target: dapServiceController
        function onWalletCreated()
        {
            logicWallet.updateAllWallets()
        }
    }

    Component.onCompleted:
    {

        logicWallet.updateWalletModel() 

//        console.log(logicMainApp.currentWalletIndex, dapModelWallets.count, dapModelWallets.get(logicMainApp.currentWalletIndex).name, "AAAAAAAAAAAAAAAAAAAAAAAAAA")

        if (!updateWalletTimer.running)
            updateWalletTimer.start()

        if(dapModelWallets.count)
            if(dapModelWallets.get(logicMainApp.currentWalletIndex).status === "non-Active" && !walletActivatePopup.isOpen)
                walletActivatePopup.show(dapModelWallets.get(logicMainApp.currentWalletIndex).name, true)

    }

    Component.onDestruction:
    {
        updateWalletTimer.stop()
    }
}

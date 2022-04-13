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

    ListModel {id: networkModel}
    LogicWallet{id: logigWallet}

    QtObject {
        id: navigator

        function createWallet() {
            if(state !== "WALLETSHOW")
                state = "WALLETCREATE"
            dapRightPanel.push(createNewWallet)
        }

        function doneWalletFunc(){
            dapRightPanel.push(doneWallet)
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
                walletInfo.name = dapModelWallets.get(logicMainApp.currentIndex).name
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
                target: dashboardTopPanel
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
                target: dashboardTopPanel
                visible: true
            }
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
                target: dashboardTopPanel
                visible: true
            }
            PropertyChanges
            {
                target: dashboardScreen.dapFrameTitleCreateWallet;
                visible: true
            }
        }
    ]

    DapMessagePopup
    {
        id: walletMessagePopup
        dapButtonCancel.visible: true
    }

    Timer {
        id: updateTimer
        interval: logicMainApp.autoUpdateInterval; running: false; repeat: true
        onTriggered:
        {
            print("DapDashboardTab updateTimer", updateTimer.running)

            if(!dapModelWallets.count)
            {
                if(state !== "WALLETCREATE")
                {
                    state = "WALLETDEFAULT"
                    navigator.popPage()
                }

                logigWallet.updateAllWallets()
            }
            else
                logigWallet.updateCurrentWallet()
        }
    }

//    // Signal-slot connection realizing panel switching depending on predefined rules
//    Connections
//    {
//        target: currentRightPanel
//        onNextActivated:
//        {
//            dapRightPanel.clear()
//            currentRightPanel = dapRightPanel.push(currentRightPanel.dapNextRightPanel);
//            if(parametrsRightPanel === lastActionsWallet)
//            {
//                if(dapModelWallets.count === 0)
//                    state = "WALLETDEFAULT"
//            }
//            else if(parametrsRightPanel === createNewWallet)
//            {
//                dashboardScreen.dapFrameTitleCreateWallet.text = qsTr("Creating wallet in process...")
//            }
//        }
//        onPreviousActivated:
//        {
//            dapRightPanel.clear()
//            currentRightPanel = dapRightPanel.push(currentRightPanel.dapPreviousRightPanel);
//            if(parametrsRightPanel === lastActionsWallet)
//            {
//                if(dapModelWallets.count === 0)
//                    state = "WALLETDEFAULT"
//            }
//        }
//    }


    Connections
    {
        target: dapMainWindow
        onModelWalletsUpdated:
        {
            logigWallet.updateComboBox()

            // FOR DEBUG
//            logigWallet.updateCurrentWallet()
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
            logigWallet.updateAllWallets()
        }
    }

    Component.onCompleted:
    {
        print("DapDashboardTab onCompleted")
        logigWallet.updateComboBox()

        if (!updateTimer.running)
            updateTimer.start()
    }

    Component.onDestruction:
    {
        print("DapDashboardTab onDestruction")
    }
}

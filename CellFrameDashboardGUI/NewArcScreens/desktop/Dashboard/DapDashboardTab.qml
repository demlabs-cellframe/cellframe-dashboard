import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../../controls"
import "RightPanel"

DapPage
{
    property string path: "qrc:/NewArcScreens/"+device

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
    readonly property var currentIndex: 1
    property string currentRightPanel: lastActionsWallet

    signal componentOnCompleted(var ok)

    property var walletInfo:
    {
        "name": "",
        "network": "",
        "address": "",
        "chain": "",
        "signature_type": "",
        "recovery_hash": ""
    }

    QtObject {
        id: navigator

        function createWallet() {
            if(state !== "WALLETSHOW")
                state = "WALLETCREATE"
            dapRightPanel.push(createNewWallet)
            currentRightPanel = createNewWallet
        }

        function doneWalletFunc(){
            dapRightPanel.push(doneWallet)
            currentRightPanel = doneWallet
        }

        function recoveryWalletFunc()
        {
            dapRightPanel.push(recoveryWallet)
            currentRightPanel = recoveryWallet
        }

        function newPayment()
        {
            dapRightPanel.push(newPaymentMain)
            currentRightPanel = newPaymentMain
        }

        function doneNewPayment()
        {
           dapRightPanel.push(newPaymentDone)
           currentRightPanel = newPaymentDone
        }

        function popPage() {
            dapRightPanel.clear()
            dapRightPanel.push(lastActionsWallet)
            currentRightPanel = lastActionsWallet
        }
    }

    dapHeader.initialItem: DapDashboardTopPanel
        {
            id: dashboardTopPanel
            dapNewPayment.onClicked:
            {
                walletInfo.name = _dapModelWallets.get(globalLogic.currentIndex).name
                navigator.newPayment()
            }
        }



    dapScreen.initialItem:
        DapDashboardScreen
        {
            id: dashboardScreen
            dapAddWalletButton.onClicked:
            {
                globalLogic.restoreWalletMode = false
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
                target: dapRightPanelFrame
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
                target: dapRightPanelFrame
                visible: true
            }
            PropertyChanges
            {
                target: dapHeaderFrame
                visible: true
            }
            PropertyChanges
            {
                target: dashboardScreen.dapFrameTitleCreateWallet;
                visible: true
            }
        }
    ]

    Timer {
        id: updateTimer
        interval: 1000; running: true; repeat: true
        onTriggered:
        {
            updateCurrentWallet()
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
            updateAllWallets()
        }
    }

    Connections
    {
        target: dapMainPage
        onModelWalletsUpdated:
        {
            updateComboBox()
        }
        onUpdatePage:
        {
            if(index === currentIndex)
            {
                updateComboBox()
                componentOnCompleted(true)
                if (!updateTimer.running)
                    updateTimer.start()
            }
            else
            {
                componentOnCompleted(false)
                updateTimer.stop()
            }
        }
    }

    function updateAllWallets()
    {
        _dapWallets.length = 0
        if(_dapModelWallets)
            _dapModelWallets.clear()
        dapServiceController.requestToService("DapGetWalletsInfoCommand");
    }

    function updateComboBox()
    {
        if(globalLogic.currentIndex !== -1)
        {
            dashboardScreen.dapListViewWallet.model = _dapModelWallets.get(globalLogic.currentIndex).networks
            dashboardTopPanel.dapFrameTitle.text = _dapModelWallets.get(globalLogic.currentIndex).name

            dashboardTab.state = "WALLETSHOW"
        }
    }

    function updateCurrentWallet()
    {
        console.log(networkArray)
        if(networkArray)
        {
            if (globalLogic.currentIndex !== -1 && networkArray !== "")
                dapServiceController.requestToService("DapGetWalletInfoCommand",
                    _dapModelWallets.get(globalLogic.currentIndex).name,
                    networkArray);
        }
    }
}

import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "qrc:/screen/controls"
import "RightPanel"

DapPage
{
    ///@detalis Path to the right panel of transaction history.
    readonly property string transactionHistoryWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapTransactionHistoryRightPanel.qml"
    ///@detalis Path to the right panel of input name wallet.
    readonly property string createNewWallet: "qrc:/screen/" + device + "/Settings/RightPanel/DapCreateWallet.qml"
    ///@detalis Path to the right panel of recovery.
    readonly property string recoveryWallet: "qrc:/screen/" + device + "/Settings/RightPanel/DapRecoveryWalletRightPanel.qml"
    ///@detalis Path to the right panel of done.
    readonly property string doneWallet: "qrc:/screen/" + device + "/Settings/RightPanel/DapDoneCreateWallet.qml"
    ///@detalis Path to the right panel of last actions.
    readonly property string lastActionsWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapLastActionsRightPanel.qml"
    ///@detalis Path to the right panel of new payment.
    readonly property string newPaymentMain: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapNewPaymentMainRightPanel.qml"
    ///@detalis Path to the right panel of new payment done.
    readonly property string newPaymentDone: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapNewPaymentDoneRightPanel.qml"

    id: dashboardTab
//    color: currTheme.backgroundMainScreen

//    property alias dapDashboardRightPanel: stackViewRightPanel
    property alias dapDashboardScreen: dashboardScreen
    readonly property var currentIndex: 1

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
        }
    }

    dapHeader.initialItem: DapDashboardTopPanel
        {
            //color: currTheme.backgroundPanel
            id: dashboardTopPanel
            dapNewPayment.onClicked:
            {
                navigator.newPayment()
//                walletInfo.name = _dapModelWallets.get(globalLogic.currentIndex).name

//                console.log("New payment")
//                console.log("wallet from: " + walletInfo.name)
//                currentRightPanel = dapRightPanel.push({item:Qt.resolvedUrl(newPaymentMain),
//                        properties: {
//                            dapCmboBoxNetworkModel: _dapModelWallets.get(globalLogic.currentIndex).networks,
//                            dapCmboBoxTokenModel: _dapModelWallets.get(globalLogic.currentIndex).networks.get(0).tokens
//                        }
//                       });
            }
        }



    dapScreen.initialItem:
        DapDashboardScreen
        {
//            color: currTheme.backgroundMainScreen

            id: dashboardScreen
            dapAddWalletButton.onClicked:
            {
                globalLogic.restoreWalletMode = false
                navigator.createWallet()
                dashboardScreen.dapWalletCreateFrame.visible = false
            }
        }

    dapRightPanel.initialItem: DapLastActionsRightPanel{id: lastActions}
//            StackView
//            {
//                id: stackViewRightPanel
//                initialItem: Qt.resolvedUrl(lastActionsWallet);
//                width: 350
//                anchors.fill: parent
//                delegate:
//                    StackViewDelegate
//                    {
//                        pushTransition: StackViewTransition { }
//                    }
//            }

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

    // Signal-slot connection realizing panel switching depending on predefined rules
//    Connections
//    {
//        target: currentRightPanel
//        onNextActivated:
//        {
//            currentRightPanel = dapDashboardRightPanel.push(currentRightPanel.dapNextRightPanel);
//            if(parametrsRightPanel === lastActionsWallet)
//            {
//                if(_dapModelWallets.count === 0)
//                    state = "WALLETDEFAULT"
//            }
//            else if(parametrsRightPanel === createNewWallet)
//            {
//                dashboardScreen.dapFrameTitleCreateWallet.text = qsTr("Creating wallet in process...")
//            }
//        }
//        onPreviousActivated:
//        {
//            currentRightPanel = dapDashboardRightPanel.push(currentRightPanel.dapPreviousRightPanel);
//            if(parametrsRightPanel === lastActionsWallet)
//            {
//                if(_dapModelWallets.count === 0)
//                    state = "WALLETDEFAULT"
//            }
//            else if(parametrsRightPanel === createNewWallet)
//            {
//                dashboardScreen.dapFrameTitleCreateWallet.text = qsTr("Creating wallet in process...")
//            }
//        }
//    }


    Connections
    {
        target: dapMainPage
        onModelWalletsUpdated:
        {
            updateComboBox()
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
            update()
        }
    }

    Connections
    {
        target: dapMainPage
        onUpdatePage:
        {
            if(index === currentIndex)
            {
                update()
                updateComboBox()
                lastActions.updateComponent()
            }
        }
    }

    function update()
    {
        _dapWallets.length = 0
        if(_dapModelWallets)
            _dapModelWallets.clear()
        dapServiceController.requestToService("DapGetWalletsInfoCommand");
    }

//    function createWallet()
//    {
//        if(state !== "WALLETSHOW")
//            state = "WALLETCREATE"
////        currentRightPanel = stackViewRightPanel.push({item:Qt.resolvedUrl(createNewWallet)});
//    }

    function updateComboBox()
    {
        if(globalLogic.currentIndex !== -1)
        {
            dashboardScreen.dapListViewWallet.model = _dapModelWallets.get(globalLogic.currentIndex).networks
            dashboardTopPanel.dapFrameTitle.text = _dapModelWallets.get(globalLogic.currentIndex).name

            console.log("dapComboboxWallet.onCurrentIndexChanged")

            dashboardTab.state = "WALLETSHOW"
        }
    }
}

import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../SettingsWallet.js" as SettingsWallet

DapAbstractTab
{
    ///@detalis Path to the right panel of transaction history.
    readonly property string transactionHistoryWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapTransactionHistoryRightPanel.qml"
    ///@detalis Path to the right panel of input name wallet.
    readonly property string inputNameWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapInputNewWalletNameRightPanel.qml"
    ///@detalis Path to the right panel of recovery.
    readonly property string recoveryWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapRecoveryWalletRightPanel.qml"
    ///@detalis Path to the right panel of done.
    readonly property string doneWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapDoneWalletRightPanel.qml"
    ///@detalis Path to the right panel of last actions.
    readonly property string lastActionsWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapLastActionsRightPanel.qml"
    ///@detalis Path to the right panel of new payment.
    readonly property string newPaymentMain: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapNewPaymentMainRightPanel.qml"
    ///@detalis Path to the right panel of new payment done.
    readonly property string newPaymentDone: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapNewPaymentDoneRightPanel.qml"

    property int dapIndexCurrentWallet: -1

    id: dashboardTab
    color: currTheme.backgroundMainScreen

    property alias dapDashboardRightPanel: stackViewRightPanel
    //property alias dashboardTopPanel: dashboardTopPanel
    //property alias dashboardTopPanel: dashboardScreen

    property var walletInfo:
    {
        "name": "",
        "network": "",
        "chain": "",
        "signature_type": "",
        "recovery_hash": ""
    }

    ListModel
    {
        id: operationModel
        ListElement { name: qsTr("Create wallet")
            operation: "create" }
        ListElement { name: qsTr("Restore wallet")
            operation: "restore" }
    }

    property var walletOperation: operationModel.get(0).operation
    dapTopPanel:
        DapDashboardTopPanel
        {
            id: dashboardTopPanel
            dapNewPayment.onClicked:
            {
//<<<<<<< HEAD
//                if(dapComboboxWallet.currentIndex != -1)
//                {
//                    dashboardScreen.dapListViewWallet.model = networksModel//dapModelWallets.get(dapComboboxWallet.currentIndex).networks
//                    dashboardScreen.dapNameWalletTitle.text = walletsNames[dapComboboxWallet.currentIndex]//dapModelWallets.get(dapComboboxWallet.currentIndex).name

//                    dapServiceController.CurrentWallet = walletsNames[dapComboboxWallet.currentIndex]//dapModelWallets.get(dapComboboxWallet.currentIndex).name
//                    dapServiceController.CurrentWalletNetwork = walletsModel[dapComboboxWallet.currentIndex].networks[0].name//dapModelWallets.get(dapComboboxWallet.currentIndex).networks.get(0).name
//                    dapServiceController.CurrentChain = "zero"

//                    dapServiceController.requestToService("DapGetWalletHistoryCommand",
//                        dapServiceController.CurrentWalletNetwork, dapServiceController.CurrentChain,
//                        dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex]
//                            .findAddress(dapServiceController.CurrentWalletNetwork));
//                    dashboardTab.state = "WALLETSHOW"
//                }
//            }
//            dapAddWalletButton.onClicked:
//            {
//                createWallet()
//                dashboardScreen.dapWalletCreateFrame.visible = false
//=======
                currentRightPanel = dapRightPanel.push({item:Qt.resolvedUrl(newPaymentMain),
                        properties: {
                            dapCurrentWallet: dapServiceController.CurrentWallet,
                            dapCurrentNetwork: dapServiceController.CurrentWalletNetwork,
//                            dapCmboBoxNetworkModel: dapNetworkModel,
                            dapCmboBoxNetworkModel: dapModelWallets.get(SettingsWallet.currentIndex).networks,
                            dapCmboBoxTokenModel: dapModelWallets.get(SettingsWallet.currentIndex).networks.get(0).tokens
                        }
                       });
//                createWallet()
//                dashboardScreen.dapWalletCreateFrame.visible = false
//>>>>>>> features-4880
            }
        }



    dapScreen:
        DapDashboardScreen
        {
//            color: currTheme.backgroundMainScreen

            id: dashboardScreen
            dapAddWalletButton.onClicked:
            {
                createWallet()
                dashboardScreen.dapWalletCreateFrame.visible = false
            }
//<<<<<<< HEAD
//            dapButtonNewPayment.onClicked:
//            {
//                currentRightPanel = dapRightPanel.push({item:Qt.resolvedUrl(newPaymentMain),
//                        properties: {
//                            dapCurrentWallet: dapServiceController.CurrentWallet,
//                            dapCurrentNetwork: dapServiceController.CurrentWalletNetwork,
//                            dapCmboBoxNetworkModel: walletsModel[dashboardTopPanel.dapComboboxWallet.currentIndex].networks

//                            //dapCmboBoxNetworkModel: dapModelWallets.get(dashboardTopPanel.dapComboboxWallet.currentIndex).networks,
//                            //dapCmboBoxTokenModel: dapModelWallets.get(dashboardTopPanel.dapComboboxWallet.currentIndex).networks.get(0).tokens

//                        }
//                       });
//            }
//=======
//            dapButtonNewPayment.onClicked:
//            {
//                currentRightPanel = dapRightPanel.push({item:Qt.resolvedUrl(newPaymentMain),
//                        properties: {
//                            dapCurrentWallet: dapServiceController.CurrentWallet,
//                            dapCurrentNetwork: dapServiceController.CurrentWalletNetwork,
////                            dapCmboBoxNetworkModel: dapNetworkModel,
//                            dapCmboBoxNetworkModel: dapModelWallets.get(SettingsWallet.currentIndex).networks,
//                            dapCmboBoxTokenModel: dapModelWallets.get(SettingsWallet.currentIndex).networks.get(0).tokens
//                        }
//                       });
//            }
//>>>>>>> features-4880
        }

    dapRightPanel:
            StackView
            {
                id: stackViewRightPanel
                initialItem: Qt.resolvedUrl(lastActionsWallet);
                width: 350
                anchors.fill: parent
                delegate:
                    StackViewDelegate
                    {
                        pushTransition: StackViewTransition { }
                    }
            }

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
//            PropertyChanges
//            {
//                target: dashboardScreen.dapListViewWallet;
//                visible: false
//            }
            PropertyChanges
            {
                target: dapRightPanel;
                visible: false
            }
            PropertyChanges
            {
                target: dapTopPanel
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
//            PropertyChanges
//            {
//                target: dashboardScreen.dapListViewWallet;
//                visible: true
//            }
            PropertyChanges
            {
                target: dapRightPanel;
                visible: true
            }
            PropertyChanges
            {
                target: dapTopPanel
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
//            PropertyChanges
//            {
//                target: dashboardScreen.dapListViewWallet;
//                visible: false
//            }
            PropertyChanges
            {
                target: dapRightPanel;
                visible: true
            }
            PropertyChanges
            {
                target: dapTopPanel
                visible: true
            }
            PropertyChanges
            {
                target: dashboardScreen.dapFrameTitleCreateWallet;
                visible: true
            }
        }
    ]

//    // Signal-slot connection realizing panel switching depending on predefined rules
//    Connections
//    {
//        target: currentRightPanel
//        onNextActivated:
//        {
//            currentRightPanel = dapDashboardRightPanel.push(currentRightPanel.dapNextRightPanel);
//            if(parametrsRightPanel === lastActionsWallet)
//            {
//                if(dapModelWallets.count === 0)
//                    state = "WALLETDEFAULT"
//                dapServiceController.requestToService("DapGetWalletHistoryCommand",
//                    walletInfo.network, walletInfo.chain,
//                    dapWallets[SettingsWallet.currentIndex].findAddress(walletInfo.network));
//            }
//        }
//        onPreviousActivated:
//        {
//            currentRightPanel = dapDashboardRightPanel.push(currentRightPanel.dapPreviousRightPanel);
//            if(parametrsRightPanel === lastActionsWallet)
//            {
//                dapServiceController.requestToService("DapGetWalletHistoryCommand",
//                    walletInfo.network, walletInfo.chain,
//                    dapWallets[SettingsWallet.currentIndex].findAddress(walletInfo.network));
//            }
//        }
//    }

//    Connections
//    {
//        target: dapMainWindow
//        onModelWalletsUpdated:
//        {
//            SettingsWallet.currentIndex = dapIndexCurrentWallet == -1 ? (dapModelWallets.count > 0 ? 0 : -1) : dapIndexCurrentWallet
//            updateComboBox()
//        }
//    }

    Connections
    {
        target: dapServiceController
        onWalletHistoryReceived:
        {
            for (var q = 0; q < walletHistory.length; ++q)
            {
//                modelHistory.append({ "wallet" : walletHistory[q].Wallet,
//                                      "name" : walletHistory[q].Name,
//                                      "status" : walletHistory[q].Status,
//                                      "amount" : walletHistory[q].Amount,
//                                      "date" : walletHistory[q].Date})
            }
        }
        onMempoolProcessed:
        {
            update()
        }
        onWalletCreated:
        {
            update()
        }
    }

    Component.onCompleted:
    {
        for(var i=0; i < dapWallets.count; ++i)
        {
            modelHistory.clear()
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                                                  dapServiceController.CurrentNetwork,
                                                  dapServiceController.CurrentChain,
                                                  dapWallets[i].findAddress(dapServiceController.CurrentNetwork),
                                                  dapWallets[i].Name)
        }

        updateComboBox()

        if(dapModelWallets.count > 0)
        {
            if(dapModelWallets.get(0).name === "all wallets")
            {
                SettingsWallet.currentIndex = -1
                dapModelWallets.remove(0, 1);
                SettingsWallet.currentIndex = 0;
            }
        }
    }

    function update()
    {
        dapIndexCurrentWallet = SettingsWallet.currentIndex
        dapWallets.length = 0
        dapModelWallets.clear()
        dapServiceController.requestToService("DapGetWalletsInfoCommand");
    }

    function createWallet()
    {
        if(state !== "WALLETSHOW")
            state = "WALLETCREATE"
        currentRightPanel = stackViewRightPanel.push({item:Qt.resolvedUrl(inputNameWallet)});
    }

    function updateComboBox()
    {
        if(SettingsWallet.currentIndex != -1)
        {
            dashboardScreen.dapListViewWallet.model = dapModelWallets.get(SettingsWallet.currentIndex).networks
            dashboardTopPanel.dapFrameTitle.text = dapModelWallets.get(SettingsWallet.currentIndex).name

            dapServiceController.CurrentWallet = dapModelWallets.get(SettingsWallet.currentIndex).name
            dapServiceController.CurrentWalletNetwork = dapModelWallets.get(SettingsWallet.currentIndex).networks.get(0).name
            dapServiceController.CurrentChain = "zero"
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                dapServiceController.CurrentWalletNetwork, dapServiceController.CurrentChain,
                dapWallets[SettingsWallet.currentIndex].findAddress(dapServiceController.CurrentWalletNetwork));
            dashboardTab.state = "WALLETSHOW"
        }
    }
}

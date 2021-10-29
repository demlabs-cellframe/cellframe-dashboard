import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"

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

    dapTopPanel:
        DapDashboardTopPanel
        {
            color: currTheme.backgroundPanel
            id: dashboardTopPanel
            dapComboboxWallet.onCurrentIndexChanged:
            {
                if(dapComboboxWallet.currentIndex != -1)
                {
                    dashboardScreen.dapListViewWallet.model = dapModelWallets.get(dapComboboxWallet.currentIndex).networks
                    dashboardScreen.dapNameWalletTitle.text = dapModelWallets.get(dapComboboxWallet.currentIndex).name

                    console.log("dapComboboxWallet.onCurrentIndexChanged")
                    console.log("wallet: "+dapModelWallets.get(dapComboboxWallet.currentIndex).name)
                    console.log("network: "+dapModelWallets.get(dapComboboxWallet.currentIndex).networks.get(0).name)
                    dapServiceController.CurrentWallet = dapModelWallets.get(dapComboboxWallet.currentIndex).name
                    dapServiceController.CurrentWalletNetwork = dapModelWallets.get(dapComboboxWallet.currentIndex).networks.get(0).name
                    dapServiceController.CurrentChain = "zero"

                    console.log(dapComboboxWallet.currentIndex)
                    console.log(dapModelWallets.get(dapComboboxWallet.currentIndex))
                    console.log("DapGetWalletHistoryCommand")
                    console.log("   network: " + dapServiceController.CurrentWalletNetwork)
                    console.log("   chain: " + dapServiceController.CurrentChain)
                    console.log("   wallet address: " + dapWallets[dashboardTopPanel
                        .dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentWalletNetwork))
                    dapServiceController.requestToService("DapGetWalletHistoryCommand",
                        dapServiceController.CurrentWalletNetwork, dapServiceController.CurrentChain,
                        dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex]
                            .findAddress(dapServiceController.CurrentWalletNetwork));
                    dashboardTab.state = "WALLETSHOW"
                }
            }
            dapAddWalletButton.onClicked:
            {
                createWallet()
                dashboardScreen.dapWalletCreateFrame.visible = false
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
//                dashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#D51F5D"
            }
            dapButtonNewPayment.onClicked:
            {
                console.log("New payment")
                console.log("wallet from: " + dapServiceController.CurrentWallet)
                console.log("wallet network: " + dapServiceController.CurrentWalletNetwork)
                //console.log("address wallet from: " + dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentWalletNetwork))
                currentRightPanel = dapRightPanel.push({item:Qt.resolvedUrl(newPaymentMain),
                        properties: {
                            dapCurrentWallet: dapServiceController.CurrentWallet,
                            dapCurrentNetwork: dapServiceController.CurrentWalletNetwork,
//                            dapCmboBoxNetworkModel: dapNetworkModel,

                            //dapCmboBoxNetworkModel: dapModelWallets.get(dashboardTopPanel.dapComboboxWallet.currentIndex).networks,
                            //dapCmboBoxTokenModel: dapModelWallets.get(dashboardTopPanel.dapComboboxWallet.currentIndex).networks.get(0).tokens

                        }
                       });
                //dashboardTopPanel.dapButtonNewPayment.colorBackgroundNormal = "#D51F5D"
            }
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
                target: dashboardScreen.dapTitleBlock;
                visible: false
            }
            PropertyChanges
            {
                target: dashboardScreen.dapListViewWallet;
                visible: false
            }
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
                target: dashboardScreen.dapTitleBlock;
                visible: true
            }
            PropertyChanges
            {
                target: dashboardScreen.dapListViewWallet;
                visible: true
            }
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
                target: dashboardScreen.dapTitleBlock;
                visible: false
            }
            PropertyChanges
            {
                target: dashboardScreen.dapListViewWallet;
                visible: false
            }
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

    // Signal-slot connection realizing panel switching depending on predefined rules
    Connections
    {
        target: currentRightPanel
        onNextActivated:
        {
            currentRightPanel = dapDashboardRightPanel.push(currentRightPanel.dapNextRightPanel);
            if(parametrsRightPanel === lastActionsWallet)
            {
                if(dapModelWallets.count === 0)
                    state = "WALLETDEFAULT"

                console.log("DapGetWalletHistoryCommand")
                console.log("   network: " + dapServiceController.CurrentWalletNetwork)
                console.log("   chain: " + dapServiceController.CurrentChain)
                //console.log("   wallet address: " + dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentWalletNetwork))
                dapServiceController.requestToService("DapGetWalletHistoryCommand",
                    dapServiceController.CurrentWalletNetwork, dapServiceController.CurrentChain,
                    //dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentWalletNetwork)
                                                      );
            }
        }
        onPreviousActivated:
        {
            currentRightPanel = dapDashboardRightPanel.push(currentRightPanel.dapPreviousRightPanel);
            if(parametrsRightPanel === lastActionsWallet)
            {
                if(dapModelWallets.count === 0)
                    state = "WALLETDEFAULT"

                console.log("DapGetWalletHistoryCommand")
                console.log("   network: " + dapServiceController.CurrentWalletNetwork)
                console.log("   chain: " + dapServiceController.CurrentChain)
                //console.log("   wallet address: " + dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentWalletNetwork))
                dapServiceController.requestToService("DapGetWalletHistoryCommand",
                    dapServiceController.CurrentWalletNetwork, dapServiceController.CurrentChain,
                    //dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentWalletNetwork)
                                                      );
            }
        }
    }

    Connections
    {
        target: dapMainWindow
        onModelWalletsUpdated:
        {
            //dashboardTopPanel.dapComboboxWallet.currentIndex = 1 /*dapIndexCurrentWallet == -1 ? (wallets.length > 0 ? 0 : -1) : dapIndexCurrentWallet*/
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletHistoryReceived:
        {
            for (var q = 0; q < walletHistory.length; ++q)
            {
                console.info("WALLET HISTORY Wallet =", walletHistory[q].Wallet)
                console.info("WALLET HISTORY Name =", walletHistory[q].Name)
                console.info("WALLET HISTORY Status =", walletHistory[q].Status)
                console.info("WALLET HISTORY Amount =", walletHistory[q].Amount)
                console.info("WALLET HISTORY Date =", walletHistory[q].Date)

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
    }

    function update()
    {
        dapIndexCurrentWallet = dashboardTopPanel.dapComboboxWallet.currentIndex
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
}

import QtQuick 2.4
import "qrc:/"
import "../../"

DapDashboardTabForm
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

    // Setting the right pane by default
    dapDashboardRightPanel.initialItem: Qt.resolvedUrl(lastActionsWallet);

    property int dapIndexCurrentWallet: -1

    dapDashboardTopPanel.dapComboboxWallet.onCurrentIndexChanged:
    {
        dapDashboardScreen.dapListViewWallet.model = dapModelWallets.get(dapDashboardTopPanel.dapComboboxWallet.currentIndex).networks
        dapDashboardScreen.dapNameWalletTitle.text = dapModelWallets.get(dapDashboardTopPanel.dapComboboxWallet.currentIndex).name
        console.log("DapGetWalletHistoryCommand")
        console.log("   network: " + dapServiceController.CurrentNetwork)
        console.log("   chain: " + dapServiceController.CurrentChain)
        console.log("   wallet address: " + dapWallets[dapDashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork))
        dapServiceController.requestToService("DapGetWalletHistoryCommand", dapServiceController.CurrentNetwork, dapServiceController.CurrentChain, dapWallets[dapDashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork));
        state = "WALLETSHOW"
    }

    // Signal-slot connection realizing panel switching depending on predefined rules
    Connections
    {
        target: currentRightPanel
        onNextActivated:
        {
            currentRightPanel = dapDashboardRightPanel.push(currentRightPanel.dapNextRightPanel);
            if(parametrsRightPanel === lastActionsWallet)
            {
                console.log("DapGetWalletHistoryCommand")
                console.log("   network: " + dapServiceController.CurrentNetwork)
                console.log("   chain: " + dapServiceController.CurrentChain)
                console.log("   wallet address: " + dapWallets[dapDashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork))
                dapServiceController.requestToService("DapGetWalletHistoryCommand", dapServiceController.CurrentNetwork, dapServiceController.CurrentChain, dapWallets[dapDashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork));
            }
        }
        onPreviousActivated:
        {
            currentRightPanel = dapDashboardRightPanel.push(currentRightPanel.dapPreviousRightPanel);
            if(parametrsRightPanel === lastActionsWallet)
            {
                console.log("DapGetWalletHistoryCommand")
                console.log("   network: " + dapServiceController.CurrentNetwork)
                console.log("   chain: " + dapServiceController.CurrentChain)
                console.log("   wallet address: " + dapWallets[dapDashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork))
                dapServiceController.requestToService("DapGetWalletHistoryCommand", dapServiceController.CurrentNetwork, dapServiceController.CurrentChain, dapWallets[dapDashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork));
            }
        }
    }

    Connections
    {
        target: dapMainWindow
        onModelWalletsUpdated:
        {
            dapDashboardTopPanel.dapComboboxWallet.currentIndex = dapIndexCurrentWallet == -1 ? (dapModelWallets.count > 0 ? 0 : -1) : dapIndexCurrentWallet
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
            if(wallet[0])
            {
                update()
            }
        }
    }

    dapDashboardScreen.dapAddWalletButton.onClicked:
    {
        createWallet()
    }

    dapDashboardTopPanel.dapAddWalletButton.onClicked:
    {
        createWallet()
    }

    // When you click on the button for creating a new payment, open the form to fill in the payment data
    dapDashboardScreen.dapButtonNewPayment.onClicked:
    {
        console.log("New payment")
        console.log("wallet from: " + dapDashboardTopPanel.dapComboboxWallet.mainLineText)
        console.log("address wallet from: " + dapWallets[dapDashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork))
        currentRightPanel = dapDashboardRightPanel.push({item:Qt.resolvedUrl(newPaymentMain),
        properties: {dapCmboBoxTokenModel: dapModelWallets.get(dapDashboardTopPanel.dapComboboxWallet.currentIndex).networks,
                                                            dapCurrentWallet:  dapDashboardTopPanel.dapComboboxWallet.mainLineText,
                                                            dapCmboBoxTokenModel: dapModelWallets.get(dapDashboardTopPanel.dapComboboxWallet.currentIndex).networks.get(dapServiceController.IndexCurrentNetwork).tokens,
                                                            dapTextSenderWalletAddress: dapWallets[dapDashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(dapServiceController.CurrentNetwork)}});
    }

    function update()
    {
        dapIndexCurrentWallet = dapDashboardTopPanel.dapComboboxWallet.currentIndex
        dapWallets.length = 0
        dapModelWallets.clear()
        dapServiceController.requestToService("DapGetListWalletsCommand");
    }

    function createWallet()
    {
        if(state !== "WALLETSHOW")
            state = "WALLETCREATE"
        currentRightPanel = dapDashboardRightPanel.push({item:Qt.resolvedUrl(inputNameWallet)});
    }
}

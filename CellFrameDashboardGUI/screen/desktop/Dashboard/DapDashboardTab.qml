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
    property string walletRecoveryType: "Nothing"

    dapTopPanel:
        DapDashboardTopPanel
        {
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
                    walletInfo.name = dapModelWallets.get(dapComboboxWallet.currentIndex).name
                    walletInfo.network = dapModelWallets.get(dapComboboxWallet.currentIndex).networks.get(0).name
                    walletInfo.chain = "zero"

//                    console.log(dapComboboxWallet.currentIndex)
//                    console.log(dapModelWallets.get(dapComboboxWallet.currentIndex))
                    console.log("DapGetWalletHistoryCommand")
                    console.log("   network: " + walletInfo.network)
                    console.log("   chain: " + walletInfo.chain)
                    console.log("   wallet address: " + dapWallets[dashboardTopPanel
                        .dapComboboxWallet.currentIndex].findAddress(walletInfo.network))
                    dapServiceController.requestToService("DapGetWalletHistoryCommand",
                        walletInfo.network, walletInfo.chain,
                        dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex]
                            .findAddress(walletInfo.network));
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
                console.log("wallet from: " + walletInfo.name)
                console.log("wallet network: " + walletInfo.network)
                console.log("address wallet from: " + dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(walletInfo.network))
                currentRightPanel = dapRightPanel.push({item:Qt.resolvedUrl(newPaymentMain),
                        properties: {
                            dapCmboBoxNetworkModel: dapModelWallets.get(dashboardTopPanel.dapComboboxWallet.currentIndex).networks,
                            dapCmboBoxTokenModel: dapModelWallets.get(dashboardTopPanel.dapComboboxWallet.currentIndex).networks.get(0).tokens
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
                anchors.fill: parent
                width: 400
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
                console.log("DapGetWalletHistoryCommand")
                console.log("   network: " + walletInfo.network)
                console.log("   chain: " + walletInfo.chain)
                console.log("   wallet address: " + dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(walletInfo.network))
                dapServiceController.requestToService("DapGetWalletHistoryCommand",
                    walletInfo.network, walletInfo.chain,
                    dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(walletInfo.network));
            }
        }
        onPreviousActivated:
        {
            currentRightPanel = dapDashboardRightPanel.push(currentRightPanel.dapPreviousRightPanel);
            if(parametrsRightPanel === lastActionsWallet)
            {
                console.log("DapGetWalletHistoryCommand")
                console.log("   network: " + walletInfo.network)
                console.log("   chain: " + walletInfo.chain)
                console.log("   wallet address: " + dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(walletInfo.network))
                dapServiceController.requestToService("DapGetWalletHistoryCommand",
                    walletInfo.network, walletInfo.chain,
                    dapWallets[dashboardTopPanel.dapComboboxWallet.currentIndex].findAddress(walletInfo.network));
            }
        }
    }

    Connections
    {
        target: dapMainWindow
        onModelWalletsUpdated:
        {
            dashboardTopPanel.dapComboboxWallet.currentIndex = dapIndexCurrentWallet == -1 ? (dapModelWallets.count > 0 ? 0 : -1) : dapIndexCurrentWallet
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
            update()
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
//        currentRightPanel = stackViewRightPanel.push({item:Qt.resolvedUrl(recoveryWallet)});
        currentRightPanel = stackViewRightPanel.push({item:Qt.resolvedUrl(inputNameWallet)});
    }
}

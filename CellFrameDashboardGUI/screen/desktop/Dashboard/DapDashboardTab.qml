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
    color: currTheme.backgroundMainScreen

    property alias dapDashboardRightPanel: stackViewRightPanel

    property var walletInfo:
    {
        "name": "",
        "network": "",
        "address": "",
        "chain": "",
        "signature_type": "",
        "recovery_hash": ""
    }

    dapTopPanel:
        DapDashboardTopPanel
        {
            color: currTheme.backgroundPanel
            id: dashboardTopPanel
            dapNewPayment.onClicked:
            {
                walletInfo.name = dapModelWallets.get(SettingsWallet.currentIndex).name

                console.log("New payment")
                console.log("wallet from: " + walletInfo.name)
                currentRightPanel = dapRightPanel.push({item:Qt.resolvedUrl(newPaymentMain),
                        properties: {
                            dapCmboBoxNetworkModel: dapModelWallets.get(SettingsWallet.currentIndex).networks,
                            dapCmboBoxTokenModel: dapModelWallets.get(SettingsWallet.currentIndex).networks.get(0).tokens
                        }
                       });
            }
        }



    dapScreen:
        DapDashboardScreen
        {
//            color: currTheme.backgroundMainScreen

            id: dashboardScreen
            dapAddWalletButton.onClicked:
            {
                restoreWalletMode = false
                createWallet()
                dashboardScreen.dapWalletCreateFrame.visible = false
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
                target: dashboardScreen.dapMainFrameDashboard;
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
                target: dashboardScreen.dapMainFrameDashboard;
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
                target: dashboardScreen.dapMainFrameDashboard;
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
            }
        }
        onPreviousActivated:
        {
            currentRightPanel = dapDashboardRightPanel.push(currentRightPanel.dapPreviousRightPanel);
            if(parametrsRightPanel === lastActionsWallet)
            {
                if(dapModelWallets.count === 0)
                    state = "WALLETDEFAULT"
            }
        }
    }


    Connections
    {
        target: dapMainWindow
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

    Component.onCompleted:
    {
        print("DapDashboardTab onCompleted")
        updateComboBox()
    }

    Component.onDestruction:
    {
        print("DapDashboardTab onDestruction")
    }

    function update()
    {
        dapWallets.length = 0
        dapModelWallets.clear()
        dapServiceController.requestToService("DapGetWalletsInfoCommand");
    }

    function createWallet()
    {
        if(state !== "WALLETSHOW")
            state = "WALLETCREATE"
        currentRightPanel = stackViewRightPanel.push({item:Qt.resolvedUrl(createNewWallet)});
    }

    function updateComboBox()
    {
        if(SettingsWallet.currentIndex !== -1)
        {
            dashboardScreen.dapListViewWallet.model = dapModelWallets.get(SettingsWallet.currentIndex).networks
            dashboardTopPanel.dapFrameTitle.text = dapModelWallets.get(SettingsWallet.currentIndex).name

            console.log("dapComboboxWallet.onCurrentIndexChanged")

            dashboardTab.state = "WALLETSHOW"
        }
    }

}

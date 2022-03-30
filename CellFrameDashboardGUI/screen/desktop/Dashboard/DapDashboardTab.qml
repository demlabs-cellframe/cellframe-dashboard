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

//    property alias dapDashboardRightPanel: stackViewRightPanel
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
                dapRightPanel.clear()
                currentRightPanel = dapRightPanel.push({item:Qt.resolvedUrl(newPaymentMain)});
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

    Timer {
        id: updateTimer
        interval: 1000; running: false; repeat: true
        onTriggered:
        {
            print("DapDashboardTab updateTimer", updateTimer.running)

            updateCurrentWallet()
        }
    }

    // Signal-slot connection realizing panel switching depending on predefined rules
    Connections
    {
        target: currentRightPanel
        onNextActivated:
        {
            dapRightPanel.clear()
            currentRightPanel = dapRightPanel.push(currentRightPanel.dapNextRightPanel);
            if(parametrsRightPanel === lastActionsWallet)
            {
                if(dapModelWallets.count === 0)
                    state = "WALLETDEFAULT"
            }
            else if(parametrsRightPanel === createNewWallet)
            {
                dashboardScreen.dapFrameTitleCreateWallet.text = qsTr("Creating wallet in process...")
            }
        }
        onPreviousActivated:
        {
            dapRightPanel.clear()
            currentRightPanel = dapRightPanel.push(currentRightPanel.dapPreviousRightPanel);
            if(parametrsRightPanel === lastActionsWallet)
            {
                if(dapModelWallets.count === 0)
                    state = "WALLETDEFAULT"
            }
//            else if(parametrsRightPanel === createNewWallet)
//            {
//                dashboardScreen.dapFrameTitleCreateWallet.textItem.text = qsTr("Creating wallet in process...")
//            }
        }
    }


    Connections
    {
        target: dapMainWindow
        onModelWalletsUpdated:
        {
            updateComboBox()

            // FOR DEBUG
//            updateCurrentWallet()
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

    Component.onCompleted:
    {
        print("DapDashboardTab onCompleted")
        updateComboBox()

        if (!updateTimer.running)
            updateTimer.start()
    }

    Component.onDestruction:
    {
        print("DapDashboardTab onDestruction")
    }

    function updateAllWallets()
    {
        dapWallets.length = 0
        dapModelWallets.clear()
        dapServiceController.requestToService("DapGetWalletsInfoCommand");
    }

    function updateCurrentWallet()
    {
        print("updateCurrentWallet", "networkArray", networkArray)

        if (SettingsWallet.currentIndex !== -1 && networkArray !== "")
            dapServiceController.requestToService("DapGetWalletInfoCommand",
                dapModelWallets.get(SettingsWallet.currentIndex).name,
                networkArray);
    }

    function createWallet()
    {
        if(state !== "WALLETSHOW")
            state = "WALLETCREATE"
        dapRightPanel.clear()
        currentRightPanel = dapRightPanel.push({item:Qt.resolvedUrl(createNewWallet)});
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

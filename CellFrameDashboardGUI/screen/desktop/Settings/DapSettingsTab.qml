import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 1.4

import "qrc:/"
import "../../"
import "../controls"
import "RightPanel"

DapPage
{
    ///@detalis Path to the right panel of input name wallet.
    readonly property string inputNameWallet: path + "/Settings/RightPanel/DapCreateWallet.qml"
    ///@detalis Path to the right panel of done.
    readonly property string doneWallet: path + "/Settings/RightPanel/DapDoneCreateWallet.qml"
    //empty panel
    readonly property string emptyRightPanel: path + "/Settings/RightPanel/DapEmptyRightPanel.qml"
    ///@detalis Path to the right panel of recovery.
    readonly property string recoveryWallet: path + "/Settings/RightPanel/DapRecoveryWalletRightPanel.qml"

    Component{id: emptyRightPanel; Item{}}

    id: settingsTab
    property int dapIndexCurrentWallet: -1
    property alias dapSettingsScreen: settingsScreen
    property bool sendRequest: false

    property var walletInfo:
    {
        "name": "",
        "network": "",
        "chain": "",
        "signature_type": "",
        "recovery_hash": ""
    }
    property var commandResult:
    {
        "success": "",
        "message": ""
    }

    QtObject {
        id: navigator

        function createWallet() {
            dapRightPanel.push(inputNameWallet)
        }

        function doneWalletFunc(){
            dapRightPanel.push(doneWallet)
        }

        function recoveryWalletFunc()
        {
            dapRightPanel.push(recoveryWallet)
        }

        function popPage() {
            dapRightPanel.clear()
            dapRightPanelFrame.visible = false
            dapRightPanel.push(emptyRightPanel)
            dapSettingsScreen.dapExtensionsBlock.visible = true
        }
    }

    dapHeader.initialItem: DapSettingsTopPanel { }

    dapScreen.initialItem: DapSettingsScreen {
        id: settingsScreen

        onCreateWalletSignal:
        {
            dapRightPanel.pop()
            logicMainApp.restoreWalletMode = restoreMode
            dapRightPanelFrame.visible = true
            settingsScreen.dapExtensionsBlock.visible = false
            navigator.createWallet()
        }

        onSwitchMenuTab:
        {
            for (var i = 0; i < modelMenuTab.count; ++i)
                if (modelMenuTab.get(i).tag === tag)
                {
                    modelMenuTab.setProperty(i, "showTab", state)
                    break
                }
            menuTabChanged()
        }

        onSwitchAppsTab:
        {
            for (var i = 0; i < modelMenuTab.count; ++i)
                if (modelMenuTab.get(i).tag === tag && modelMenuTab.get(i).name === name)
                {
                    modelMenuTab.setProperty(i, "showTab", state)
                    break
                }

            menuTabChanged()
        }
    }



    dapRightPanel.initialItem: emptyRightPanel
    dapRightPanelFrame.visible: false



    Timer {
        id: updateTimer
        interval: logicMainApp.autoUpdateInterval; running: false; repeat: true
        onTriggered:
        {
            dapServiceController.requestToService("DapGetListWalletsCommand")
            if(!dapNetworkModel.count)
            {
                dapServiceController.requestToService("DapGetListNetworksCommand")
//                dapNetworkComboBox.mainLineText = dapNetworkModel.get(logicMainApp.currentNetwork).name
            }
        }
    }

    Component.onCompleted:
        updateTimer.start()

    Component.onDestruction:
        updateTimer.stop()


    Connections
    {
        target: dapServiceController

        onWalletCreated:
        {
            dapIndexCurrentWallet = settingsScreen.dapGeneralBlock.dapContent.dapCurrentWallet
        }
        onWalletsListReceived:
        {
            if(dapModelWallets)
            {
                if(walletsList.length !== dapModelWallets.count)
                    dapServiceController.requestToService("DapGetWalletsInfoCommand")
            }
            else
                dapServiceController.requestToService("DapGetWalletsInfoCommand")
        }
        onVersionControllerResult:
        {
            if(sendRequest)
            {
                if(!versionResult.hasUpdate && versionResult.message === "Reply version")
                {
                    logicMainApp.rcvReplyVersion()
                    sendRequest = false
                }
            }
        }
    }
}

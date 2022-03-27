import QtQuick 2.4
import QtQuick.Controls 1.4

import "qrc:/"
import "../../"
import "qrc:/screen/controls"
import "RightPanel"

DapPage
{
    ///@detalis Path to the right panel of input name wallet.
    readonly property string inputNameWallet: "qrc:/screen/" + device + "/Settings/RightPanel/DapCreateWallet.qml"
    ///@detalis Path to the right panel of done.
    readonly property string doneWallet: "qrc:/screen/" + device + "/Settings/RightPanel/DapDoneCreateWallet.qml"
    //empty panel
    readonly property string emptyRightPanel: "qrc:/screen/" + device + "/Settings/RightPanel/DapEmptyRightPanel.qml"
    ///@detalis Path to the right panel of recovery.
    readonly property string recoveryWallet: "qrc:/screen/" + device + "/Settings/RightPanel/DapRecoveryWalletRightPanel.qml"

    id: settingsTab
    property int dapIndexCurrentWallet: -1
    readonly property var currentIndex: 11
//    color: currTheme.backgroundMainScreen

//    property alias dapSettingsRightPanel: stackViewRightPanel
    property alias dapSettingsScreen: settingsScreen

    property var walletInfo:
    {
        "name": "",
        "network": "",
        "chain": "",
        "signature_type": "",
        "recovery_hash": ""
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
            dapRightPanelFrame.width = 0
            dapSettingsScreen.dapExtensionsBlock.visible = true
            dapRightPanel.push(emptyRightPanel)
        }
    }

    dapHeader.initialItem: DapSettingsTopPanel { }

    dapScreen.initialItem: DapSettingsScreen {
        id: settingsScreen
    }

    dapRightPanel.initialItem: DapEmptyRightPanel{id: rightPanel; visible:false}
    dapRightPanelFrame.visible: false

//    Connections
//    {
//        target: currentRightPanel
//        onNextActivated:
//        {
//            currentRightPanel = dapSettingsRightPanel.push(currentRightPanel.dapNextRightPanel);
//        }
//        onPreviousActivated:
//        {
//            currentRightPanel = dapSettingsRightPanel.push(currentRightPanel.dapPreviousRightPanel);
//        }
//    }

    Connections
    {
        target: dapServiceController

        onWalletCreated:
        {
            dapIndexCurrentWallet = settingsScreen.dapGeneralBlock.dapContent.dapCurrentWallet
            if(_dapModelWallets)
                _dapModelWallets.clear()
            dapServiceController.requestToService("DapGetWalletsInfoCommand");

        }
    }

    Connections
    {
        target: settingsScreen

        onCreateWalletSignal:
        {
            globalLogic.restoreWalletMode = restoreMode
            dapRightPanelFrame.visible = true
            settingsScreen.dapExtensionsBlock.visible = false
            navigator.createWallet()
//            currentRightPanel = stackViewRightPanel.push({item:Qt.resolvedUrl(inputNameWallet)});
        }

        onSwitchMenuTab:
        {
            console.log("onSwitchMenuTab", tag, state)

            for (var i = 0; i < modelMenuTab.count; ++i)
                if (modelMenuTab.get(i).tag === tag)
                {
                    modelMenuTab.get(i).showTab = state
                    break
                }

            menuTabChanged()
//            tabUpdate(tag, state)
        }

        onSwitchAppsTab:
        {
            console.log("onSwitchMenuTab", tag, name, state)

            for (var i = 0; i < modelMenuTab.count; ++i)
                if (modelMenuTab.get(i).tag === tag && modelMenuTab.get(i).name === name)
                {
                    modelMenuTab.get(i).showTab = state
                    break
                }

            menuTabChanged()
        }
    }
}

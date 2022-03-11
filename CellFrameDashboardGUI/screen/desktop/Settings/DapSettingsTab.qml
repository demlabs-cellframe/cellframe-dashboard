import QtQuick 2.4
import QtQuick.Controls 1.4

import "qrc:/"
import "../../"

DapAbstractTab
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
    color: currTheme.backgroundMainScreen

    property alias dapSettingsRightPanel: stackViewRightPanel
    property alias dapSettingsScreen: settingsScreen

    property var walletInfo:
    {
        "name": "",
        "network": "",
        "chain": "",
        "signature_type": "",
        "recovery_hash": ""
    }

    dapTopPanel: DapSettingsTopPanel { }

    dapScreen: DapSettingsScreen {
        id: settingsScreen
    }

    dapRightPanel: StackView
    {
        id: stackViewRightPanel
        initialItem: Qt.resolvedUrl(emptyRightPanel);
        width: visible ? 350 * pt : 0
        anchors.fill: parent
        visible:false
        delegate:
            StackViewDelegate
            {
                pushTransition: StackViewTransition { }
            }
    }

    Connections
    {
        target: currentRightPanel
        onNextActivated:
        {
            currentRightPanel = dapSettingsRightPanel.push(currentRightPanel.dapNextRightPanel);
        }
        onPreviousActivated:
        {
            currentRightPanel = dapSettingsRightPanel.push(currentRightPanel.dapPreviousRightPanel);
        }
    }

    Connections
    {
        target: dapServiceController

        onWalletCreated:
        {
            dapIndexCurrentWallet = settingsScreen.dapGeneralBlock.dapContent.dapCurrentWallet
            dapWallets.length = 0
            dapModelWallets.clear()
            dapServiceController.requestToService("DapGetWalletsInfoCommand");

        }
    }

    Connections
    {
        target: settingsScreen

        onCreateWalletSignal:
        {
            restoreWalletMode = restoreMode
            dapSettingsRightPanel.visible = true
            settingsScreen.dapExtensionsBlock.visible = false
            currentRightPanel = stackViewRightPanel.push({item:Qt.resolvedUrl(inputNameWallet)});
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

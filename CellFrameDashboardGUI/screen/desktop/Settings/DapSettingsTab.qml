import QtQuick 2.4
import QtQuick.Controls 1.4

import "qrc:/"
import "../../"
import "../SettingsWallet.js" as SettingsWallet

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
                    modelMenuTab.setProperty(i, "showTab", state)
                    break
                }

            menuTabChanged()
        }

        onSwitchAppsTab:
        {
            console.log("onSwitchMenuTab", tag, name, state)

            for (var i = 0; i < modelMenuTab.count; ++i)
                if (modelMenuTab.get(i).tag === tag && modelMenuTab.get(i).name === name)
                {
                    modelMenuTab.setProperty(i, "showTab", state)
                    break
                }

            menuTabChanged()
        }
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

    Timer {
        id: updateTimer
        interval: autoUpdateInterval; running: false; repeat: true
        onTriggered:
        {
            dapServiceController.requestToService("DapGetListWalletsCommand")
            if(!dapNetworkModel.count)
                dapServiceController.requestToService("DapGetListNetworksCommand")
        }
    }

    Component.onCompleted:
    {
        updateTimer.running = true
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
    }
}

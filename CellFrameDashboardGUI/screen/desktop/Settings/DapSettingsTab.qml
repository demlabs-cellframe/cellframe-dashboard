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
        id:settingsScreen
    }

    dapRightPanel: StackView
    {
        id: stackViewRightPanel
        initialItem: Qt.resolvedUrl(emptyRightPanel);
        width: 350 * pt
        anchors.fill: parent
        delegate:
            StackViewDelegate
            {
                pushTransition: StackViewTransition { }
            }
    }

    Connections
    {
        target: settingsScreen
        onCreateWalletSignal:
        {
            dapSettingsRightPanel.visible = true
            currentRightPanel = stackViewRightPanel.push({item:Qt.resolvedUrl(inputNameWallet)});
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
            dapIndexCurrentWallet = settingsScreen.dapComboboxWallet.currentIndex
//            dapWallets.length = 0
//            dapModelWallets.clear()
            dapServiceController.requestToService("DapGetWalletsInfoCommand");

        }
    }
    Connections
    {
        target: dapMainWindow
        onModelWalletsUpdated:
        {
            settingsScreen.dapComboboxWallet.currentIndex = dapIndexCurrentWallet == -1 ? (dapModelWallets.count > 0 ? 0 : -1) : dapIndexCurrentWallet
        }
    }

}

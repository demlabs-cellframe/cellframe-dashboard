import QtQuick 2.4
import "../../../"
import "../"

DapDoneCreateWalletForm
{
    dapNextRightPanel: ""
    dapPreviousRightPanel: ""

    Component.onCompleted:
    {
        if (logicMainApp.currentTab === dashboardScreenPath)
        {
          dapNextRightPanel = lastActionsWallet
          dapPreviousRightPanel = lastActionsWallet
        }
        if (logicMainApp.currentTab === settingsScreenPath)
        {
          dapNextRightPanel = emptyRightPanel
          dapPreviousRightPanel = emptyRightPanel
        }
    }

    dapButtonDone.onClicked:
    {
        if (logicMainApp.currentTab === dashboardScreenPath)
            previousActivated(lastActionsWallet)
        if (logicMainApp.currentTab === settingsScreenPath)
        {
            previousActivated(emptyRightPanel)
            dapSettingsRightPanel.visible = false
            dapSettingsRightPanel.width = 0
            dapSettingsScreen.dapExtensionsBlock.visible = true
        }
    }

    dapButtonClose.onClicked:
    {
        if (logicMainApp.currentTab === dashboardScreenPath)
            previousActivated(lastActionsWallet)
        if (logicMainApp.currentTab === settingsScreenPath)
        {
            previousActivated(emptyRightPanel)
            dapSettingsRightPanel.visible = false
            dapSettingsRightPanel.width = 0
            dapSettingsScreen.dapExtensionsBlock.visible = true
        }
    }
}

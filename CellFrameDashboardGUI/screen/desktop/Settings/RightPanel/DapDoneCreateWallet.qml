import QtQuick 2.4
import "../../../"
import "../"

DapDoneCreateWalletForm
{
    dapNextRightPanel: ""
    dapPreviousRightPanel: ""

    Component.onCompleted:
    {
        if (currentTab === dashboardScreenPath)
        {
          dapNextRightPanel = lastActionsWallet
          dapPreviousRightPanel = lastActionsWallet
        }
        if (currentTab === settingsScreenPath)
        {
          dapNextRightPanel = emptyRightPanel
          dapPreviousRightPanel = emptyRightPanel
        }
    }

    dapButtonDone.onClicked:
    {
        if (currentTab === dashboardScreenPath)
            previousActivated(lastActionsWallet)
        if (currentTab === settingsScreenPath)
        {
            previousActivated(emptyRightPanel)
            dapSettingsRightPanel.visible = false
            dapSettingsRightPanel.width = 0
        }
    }

    dapButtonClose.onClicked:
    {
        if (currentTab === dashboardScreenPath)
            previousActivated(lastActionsWallet)
        if (currentTab === settingsScreenPath)
        {
            previousActivated(emptyRightPanel)
            dapSettingsRightPanel.visible = false
            dapSettingsRightPanel.width = 0
        }
    }
}

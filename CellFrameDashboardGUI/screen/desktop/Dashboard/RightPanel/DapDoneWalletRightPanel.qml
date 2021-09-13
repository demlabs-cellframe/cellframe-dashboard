import QtQuick 2.4
import "../../../"

DapDoneWalletRightPanelForm
{
    dapButtonDone.onClicked:
    {
        nextActivated(lastActionsWallet)
        dashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
        dashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"
    }
}

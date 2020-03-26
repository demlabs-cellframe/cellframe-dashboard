import QtQuick 2.4
import "../../../"

DapDoneWalletRightPanelForm
{
    dapButtonDone.onClicked:
    {
        nextActivated(lastActionsWallet)
        dapDashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
        dapDashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"
    }
}

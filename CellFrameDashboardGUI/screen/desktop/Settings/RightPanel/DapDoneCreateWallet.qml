import QtQuick 2.4
import "../../../"
import "../"

DapDoneCreateWalletForm
{
    dapButtonDone.onClicked:
    {
        nextActivated(emptyRightPanel)
//        dapSettingsRightPanel.visible = false
//        dashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"

    }

    dapButtonClose.onClicked:
    {
        previousActivated(emptyRightPanel)
//        dashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"
//        dapSettingsRightPanel.visible = false
    }
}

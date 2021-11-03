import QtQuick 2.4
import "../../../"

DapDoneCreateWalletForm
{
    dapButtonDone.onClicked:
    {
        nextActivated(emptyRightPanel)
//        dashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"
    }

    dapButtonClose.onClicked:
    {
        previousActivated(emptyRightPanel)
//        dashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"
    }
}

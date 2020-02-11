import QtQuick 2.4

DapDoneWalletRightPanelForm
{
    dapButtonDone.onClicked:
    {
        nextActivated(lastActionsWallet)
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
    }
}

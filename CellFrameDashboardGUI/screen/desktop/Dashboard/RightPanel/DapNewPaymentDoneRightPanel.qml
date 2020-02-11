import QtQuick 2.4

DapNewPaymentDoneRightPanelForm
{
    dapButtonSend.onClicked:
    {
        dapServiceController.requestToService("DapMempoolProcessCommand", dapServiceController.CurrentNetwork, dapServiceController.CurrentChain)

        nextActivated("transaction done")
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
    }
}

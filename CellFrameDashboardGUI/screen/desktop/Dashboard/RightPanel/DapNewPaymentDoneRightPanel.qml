import QtQuick 2.4

DapNewPaymentDoneRightPanelForm
{
    dapButtonSend.onClicked:
    {
        console.log("DapMempoolProcessCommand")
        console.log("   network: " + dapServiceController.CurrentNetwork)
        console.log("   chain: " + dapServiceController.CurrentChain)
        dapServiceController.requestToService("DapMempoolProcessCommand", dapServiceController.CurrentNetwork, dapServiceController.CurrentChain)

        nextActivated("transaction done")
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
    }
}

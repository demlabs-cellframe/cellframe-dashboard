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
        dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
        dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
    }
}

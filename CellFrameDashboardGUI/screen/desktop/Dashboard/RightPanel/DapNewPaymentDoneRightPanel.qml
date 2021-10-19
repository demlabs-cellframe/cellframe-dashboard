import QtQuick 2.4

DapNewPaymentDoneRightPanelForm
{
    dapButtonSend.onClicked:
    {
        console.log("DapMempoolProcessCommand")
        console.log("   network: " + dapServiceController.CurrentWalletNetwork)
        console.log("   chain: " + dapServiceController.CurrentChain)
        dapServiceController.requestToService("DapMempoolProcessCommand",
            dapServiceController.CurrentWalletNetwork, dapServiceController.CurrentChain)

        nextActivated("transaction done")
//        dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
//        dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
    }
}

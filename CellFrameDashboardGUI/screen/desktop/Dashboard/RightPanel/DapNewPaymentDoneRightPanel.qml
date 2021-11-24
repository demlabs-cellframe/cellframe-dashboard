import QtQuick 2.4

DapNewPaymentDoneRightPanelForm
{
    dapButtonSend.onClicked:
    {
//        console.log("DapMempoolProcessCommand")
//        console.log("   network: " + walletInfo.network)
//        console.log("   chain: " + walletInfo.chain)
//        dapServiceController.requestToService("DapMempoolProcessCommand",
//            walletInfo.network, walletInfo.chain)

        dapWallets.length = 0
        dapModelWallets.clear()
        dapServiceController.requestToService("DapGetWalletsInfoCommand");

        nextActivated("transaction done")
//        dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
//        dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
    }
}

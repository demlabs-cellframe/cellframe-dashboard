import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{
    // The form displayed after clicking on the "Send" button
    dapNextRightPanel: newPaymentDone
    dapPreviousRightPanel: lastActionsWallet

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
        dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
    }

    dapButtonSend.onClicked:
    {
        console.log("DapCreateTransactionCommand:")
        console.log("   network: " + dapCurrentNetwork)
//        console.log("   chain: " + dapServiceController.CurrentChain)
        console.log("   chain: " + "zero")
        console.log("   wallet from: " + dapCurrentWallet)
        console.log("   wallet to: " + dapTextInputRecipientWalletAddress.text)
        console.log("   token: " + dapCmboBoxToken.mainLineText)
        console.log("   amount: " + dapTextInputAmountPayment.text)
        dapServiceController.requestToService("DapCreateTransactionCommand",
            dapCurrentNetwork, "zero",
            dapCurrentWallet, dapTextInputRecipientWalletAddress.text,
            dapCmboBoxToken.mainLineText, dapTextInputAmountPayment.text)
//        dapServiceController.requestToService("DapCreateTransactionCommand",
//            dapCurrentNetwork, dapServiceController.CurrentChain,
//            dapCurrentWallet, dapTextInputRecipientWalletAddress.text,
//            dapCmboBoxToken.mainLineText, dapTextInputAmountPayment.text)

        nextActivated("transaction created")
    }


}

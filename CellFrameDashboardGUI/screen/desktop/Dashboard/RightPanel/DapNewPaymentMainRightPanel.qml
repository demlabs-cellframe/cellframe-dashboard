import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{
    // The form displayed after clicking on the "Send" button
    dapNextRightPanel: newPaymentDone
    dapPreviousRightPanel: lastActionsWallet

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
    }

    dapButtonSend.onClicked:
    {
        console.log("DapCreateTransactionCommand:")
        console.log("   network: " + dapServiceController.CurrentNetwork)
        console.log("   chain: " + dapServiceController.CurrentChain)
        console.log("   wallet from: " + dapCurrentWallet)
        console.log("   wallet to: " + dapTextInputRecipientWalletAddress.text)
        console.log("   token: " + dapCmboBoxToken.mainLineText)
        console.log("   amount: " + dapTextInputAmountPayment.text)
        dapServiceController.requestToService("DapCreateTransactionCommand", dapServiceController.CurrentNetwork, dapServiceController.CurrentChain, dapCurrentWallet, dapTextInputRecipientWalletAddress.text, dapCmboBoxToken.mainLineText, dapTextInputAmountPayment.text)

        nextActivated("transaction created")
    }
}

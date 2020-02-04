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
        var chain = dapServiceController.CurrentNetwork === "private" ? "gdb": "plasma"
        dapServiceController.requestToService("DapCreateTransactionCommand", dapServiceController.CurrentNetwork, chain, dapCurrentWallet, dapTextInputRecipientWalletAddress.text, dapCmboBoxToken.currentText, dapTextInputAmountPayment.text)

        nextActivated("transaction created")
    }
}

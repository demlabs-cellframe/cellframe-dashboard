import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{
    // The form displayed after clicking on the "Send" button
    dapNextRightPanel: newPaymentDone

    dapButtonSend.onClicked:
    {
        nextActivated()
        dapServiceController.requestToService("DapCreateTransactionCommand", "private", "gdb", "MyWallet", dapTextInputRecipientWalletAddress.text, dapCmboBoxToken.currentText, dapTextInputAmountPayment.text)
    }
}

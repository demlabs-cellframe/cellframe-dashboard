import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{
    // The form displayed after clicking on the "Send" button
    dapNextRightPanel: newPaymentDone
    dapPreviousRightPanel: lastActionsWallet

    Component.onCompleted:
    {
        dapCmboBoxTokenModel = dapModelWallets.get(dashboardTopPanel.dapComboboxWallet.currentIndex).networks.get(dapComboboxNetwork.currentIndex).tokens
        print("Init dapCmboBoxTokenModel", dapCmboBoxTokenModel.count)
        dapTextNotEnoughTokensWarning.visible = false
    }

    dapComboboxNetwork.onCurrentIndexChanged:
    {
        print("dapComboboxNetwork.onCurrentIndexChanged")
        print("networkName", dapModelWallets.get(dashboardTopPanel.dapComboboxWallet.currentIndex).networks.get(dapComboboxNetwork.currentIndex).name)

        dapCmboBoxTokenModel = dapModelWallets.get(dashboardTopPanel.dapComboboxWallet.currentIndex).networks.get(dapComboboxNetwork.currentIndex).tokens
        dapTextInputAmountPayment.text = "0"
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
        //DmitriyT Removed this code below. Will see reaction of app.
        //dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
    }

    dapButtonSend.onClicked:
    {
        print("balanse:", dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).emission)
        print("amount:", dapTextInputAmountPayment.text)
        print("wallet address: " + dapTextInputRecipientWalletAddress.text.length)

        if (dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).emission <
                dapTextInputAmountPayment.text)
        {
            print("Not enough tokens")
            dapTextNotEnoughTokensWarning.text = qsTr("Not enough available tokens. Maximum value = %1. Enter a lower value.").arg(dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).emission)
            dapTextNotEnoughTokensWarning.visible = true
        }
        else
        if (dapTextInputAmountPayment.text === "0")
        {
            print("Zero value")
            dapTextNotEnoughTokensWarning.text = qsTr("Zero value.")
            dapTextNotEnoughTokensWarning.visible = true
        }
        else
        if (dapTextInputRecipientWalletAddress.text.length != 104)
        {
            print("Wrong address length")
            dapTextNotEnoughTokensWarning.text = qsTr("Enter a valid wallet address.")
            dapTextNotEnoughTokensWarning.visible = true
        }
        else
        {
            print("Enough tokens. Correct address length.")
            dapTextNotEnoughTokensWarning.visible = false

            console.log("DapCreateTransactionCommand:")
            console.log("   network: " + dapComboboxNetwork.mainLineText)
            console.log("   chain: " + dapServiceController.CurrentChain)
            console.log("   wallet from: " + dapCurrentWallet)
            console.log("   wallet to: " + dapTextInputRecipientWalletAddress.text)
            console.log("   token: " + dapCmboBoxToken.mainLineText)
            print("balanse:", dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).emission)
            console.log("   amount: " + dapTextInputAmountPayment.text)
            dapServiceController.requestToService("DapCreateTransactionCommand",
                dapComboboxNetwork.mainLineText, dapServiceController.CurrentChain,
                dapCurrentWallet, dapTextInputRecipientWalletAddress.text,
                dapCmboBoxToken.mainLineText, dapTextInputAmountPayment.text)

            nextActivated("transaction created")
        }

    }


}

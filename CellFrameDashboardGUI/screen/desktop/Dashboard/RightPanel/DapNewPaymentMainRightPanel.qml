import QtQuick 2.4
import "../../SettingsWallet.js" as SettingsWallet

DapNewPaymentMainRightPanelForm
{
    // The form displayed after clicking on the "Send" button
    dapNextRightPanel: newPaymentDone
    dapPreviousRightPanel: lastActionsWallet

    Component.onCompleted:
    {
        dapCmboBoxTokenModel = dapModelWallets.get(SettingsWallet.currentIndex).networks.get(dapComboboxNetwork.currentIndex).tokens
        dapTextNotEnoughTokensWarning.text = ""
    }

    dapComboboxNetwork.onCurrentIndexChanged:
    {
        print("dapComboboxNetwork.onCurrentIndexChanged")
        print("networkName", dapModelWallets.get(SettingsWallet.currentIndex).networks.get(dapComboboxNetwork.currentIndex).name)

        dapCmboBoxTokenModel = dapModelWallets.get(SettingsWallet.currentIndex).networks.get(dapComboboxNetwork.currentIndex).tokens
        }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
        //DmitriyT Removed this code below. Will see reaction of app.
        //dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
    }

    dapButtonSend.onClicked:
    {
        if (dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).emission <
                dapTextInputAmountPayment.text)
        {
            print("Not enough tokens")
            dapTextNotEnoughTokensWarning.text = qsTr("Not enough available tokens. Maximum value = %1. Enter a lower value.").arg(dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).emission)
        }
        else
        if (dapTextInputAmountPayment.text === "0")
        {
            print("Zero value")
            dapTextNotEnoughTokensWarning.text = qsTr("Zero value.")
        }
        else
        if (dapTextInputRecipientWalletAddress.text.length != 104)
        {
            print("Wrong address length")
            dapTextNotEnoughTokensWarning.text = qsTr("Enter a valid wallet address.")
        }
        else
        {
            print("Enough tokens. Correct address length.")
            dapTextNotEnoughTokensWarning.text = ""

            console.log("DapCreateTransactionCommand:")
            console.log("   network: " + dapComboboxNetwork.mainLineText)
            console.log("   chain: " + walletInfo.chain)
            console.log("   wallet from: " + walletInfo.name)
            console.log("   wallet to: " + dapTextInputRecipientWalletAddress.text)
            console.log("   token: " + dapCmboBoxToken.mainLineText)
            print("balanse:", dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).emission)
            console.log("   amount: " + dapTextInputAmountPayment.text)
            dapServiceController.requestToService("DapCreateTransactionCommand",
                dapComboboxNetwork.mainLineText, walletInfo.chain,
                walletInfo.name, dapTextInputRecipientWalletAddress.text,
                dapCmboBoxToken.mainLineText, dapTextInputAmountPayment.text)

            nextActivated("transaction created")
        }

    }


}

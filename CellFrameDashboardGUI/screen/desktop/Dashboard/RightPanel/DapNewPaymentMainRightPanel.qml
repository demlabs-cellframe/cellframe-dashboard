import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{

    property var walletName: ""



    Component.onCompleted:
    {
//        currentWallet = dapModelWallets.get(SettingsWallet.currentIndex)

        walletName = dapModelWallets.get(logicMainApp.currentIndex).name

        logigWallet.initNetworks()

        updateTimer.stop()
        if (dapServiceController.ReadingChains)
            dapChainGroup.visible = true
        else
            dapChainGroup.visible = false

        dapCmboBoxNetworkModel = dapNetworkModel

        dapTextNotEnoughTokensWarning.text = ""

/*        dapCmboBoxTokenModel = currentWallet.networks.
            get(dapComboboxNetwork.currentIndex).tokens

        dapCmboBoxChainModel = currentWallet.networks.
            get(dapComboboxNetwork.currentIndex).chains*/

        dapCmboBoxTokenModel = networkModel.
            get(dapComboboxNetwork.currentIndex).tokens

        dapCmboBoxChainModel = networkModel.
            get(dapComboboxNetwork.currentIndex).chains

        dapTextInputAmountPayment.text = "0.0"

        if (dapCmboBoxNetworkModel.count)
            dapComboboxNetwork.mainLineText = dapCmboBoxNetworkModel.get(0).name
        else
            dapComboboxNetwork.mainLineText = "Networks"

        if (dapCmboBoxTokenModel.count)
            dapCmboBoxToken.mainLineText = dapCmboBoxTokenModel.get(0).name
    }
    dapComboboxNetwork.onCurrentIndexChanged:
    {
        print("dapComboboxNetwork.onCurrentIndexChanged")
        print("networkName", dapCmboBoxNetworkModel.get(dapComboboxNetwork.currentIndex).name)

/*        print("SettingsWallet.currentIndex", SettingsWallet.currentIndex)
        print("dapModelWallets.count", dapModelWallets.count)
        print("dapComboboxNetwork.currentIndex", dapComboboxNetwork.currentIndex)
        print("dapModelWallets.get(SettingsWallet.currentIndex).networks.count",
              dapModelWallets.get(SettingsWallet.currentIndex).networks.count)*/

/*        dapCmboBoxChainModel = currentWallet.networks.
            get(dapComboboxNetwork.currentIndex).chains

        dapCmboBoxTokenModel = currentWallet.networks.
            get(dapComboboxNetwork.currentIndex).tokens*/

        dapCmboBoxTokenModel = networkModel.
            get(dapComboboxNetwork.currentIndex).tokens

        dapCmboBoxChainModel = networkModel.
            get(dapComboboxNetwork.currentIndex).chains

        print("dapCmboBoxTokenModel length", dapCmboBoxTokenModel.count)

        if (dapCmboBoxTokenModel.count === 0)
        {
            dapFrameAmountPayment.visible = false
            dapFrameInputAmountPayment.visible = false
            dapFrameRecipientWallet.visible = false
            dapFrameRecipientWalletAddress.visible = false
            dapTextNotEnoughTokensWarning.visible = false
            dapButtonSend.visible = false
        }
        else
        {
            dapFrameAmountPayment.visible = true
            dapFrameInputAmountPayment.visible = true
            dapFrameRecipientWallet.visible = true
            dapFrameRecipientWalletAddress.visible = true
            dapTextNotEnoughTokensWarning.visible = true
            dapButtonSend.visible = true
        }

        dapTextInputAmountPayment.text = "0.0"

        if (dapCmboBoxTokenModel.count)
          dapCmboBoxToken.mainLineText = dapCmboBoxTokenModel.get(0).name
    }

    dapCmboBoxToken.onCurrentIndexChanged:
    {
        dapTextInputAmountPayment.text = "0.0"
    }

    dapButtonClose.onClicked:
    {
//        previousActivated(lastActionsWallet)
        updateTimer.start()
        pop()
        //DmitriyT Removed this code below. Will see reaction of app.
        //dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
    }

    dapButtonSend.onClicked:
    {
        print("balanse:", dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).datoshi)
        print("amount:", dapTextInputAmountPayment.text)
        print("wallet address:", dapTextInputRecipientWalletAddress.text.length)

        if (dapTextInputAmountPayment.text === "" ||
            logigWallet.testAmount("0.0", dapTextInputAmountPayment.text))
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
            walletMessagePopup.smartOpen("Confirming the transaction", "Attention, the transaction fee will be 0.1 " + dapCmboBoxToken.mainLineText )
        }
    }



    Connections
    {
        target: walletMessagePopup
        onSignalAccept:
        {
            if(accept)
            {
                var amountWithCommission = (parseFloat(logigWallet.clearZeros(dapTextInputAmountPayment.text)) + 0.1).toString()
                if (!logigWallet.testAmount(
                    dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).full_balance,
                    amountWithCommission))
                {
                    print("Not enough tokens")
                    dapTextNotEnoughTokensWarning.text =
                        qsTr("Not enough available tokens. Maximum value = %1. Enter a lower value. Current value with comission = %2").
                        arg(dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).balance_without_zeros).arg(amountWithCommission)
                }
                else
                {
                    print("Enough tokens. Correct address length.")
                    dapTextNotEnoughTokensWarning.text = ""

                    var amount = toDatoshi(logigWallet.dapTextInputAmountPayment.text)

                    console.log("DapCreateTransactionCommand:")
                    console.log("   network:", dapComboboxNetwork.mainLineText)
                    console.log("   chain:", dapCmboBoxChainModel.get(dapComboboxChain.currentIndex).name)
                    console.log("   wallet from:", walletName)
                    console.log("   wallet to:", dapTextInputRecipientWalletAddress.text)
                    console.log("   token:", dapCmboBoxToken.mainLineText)
                    console.log("   amount:", amount)

                    var commission = logigWallet.toDatoshi("0.1")


                    dapServiceController.requestToService("DapCreateTransactionCommand",
        //                dapComboboxNetwork.mainLineText, dapComboboxChain.mainLineText,
                        dapComboboxNetwork.mainLineText, dapCmboBoxChainModel.get(dapComboboxChain.currentIndex).name,
    //                    currentWallet.name,
                        walletName,
                        dapTextInputRecipientWalletAddress.text,
                        dapCmboBoxToken.mainLineText, amount, commission)

//                    nextActivated("transaction created")

                }
            }
        }
    }

    Connections
    {
        target: dapServiceController
        onTransactionCreated:
        {
            commandResult.success = aResult.success
            commandResult.message = aResult.message

            updateTimer.start()
            navigator.doneNewPayment()
        }
    }
}

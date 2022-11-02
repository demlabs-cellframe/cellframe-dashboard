import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{
    property var walletName: ""

    Component.onCompleted:
    {
        updateWalletTimer.stop()

        walletName = dapModelWallets.get(logicMainApp.currentIndex).name

        logicWallet.initNetworks()

        if (dapServiceController.ReadingChains)
            dapChainGroup.visible = true
        else
            dapChainGroup.visible = false

        dapComboBoxNetworkModel = dapNetworkModel

        dapTextNotEnoughTokensWarning.text = ""

        dapComboBoxTokenModel = networksModel.
            get(dapComboboxNetwork.currentIndex).tokens

        dapComboBoxChainModel = networksModel.
            get(dapComboboxNetwork.currentIndex).chains

//        dapTextInputAmountPayment.text = "0.0"
    }
    dapComboboxNetwork.onCurrentIndexChanged:
    {
        if (networksModel.count <= dapComboboxNetwork.currentIndex)
        {
            console.warn("networksModel.count <= dapComboboxNetwork.currentIndex")
        }
        else
        {
            print("dapComboboxNetwork.onCurrentIndexChanged")

            dapComboBoxTokenModel = networksModel.
                get(dapComboboxNetwork.currentIndex).tokens

            dapComboBoxChainModel = networksModel.
                get(dapComboboxNetwork.currentIndex).chains

            print("dapComboBoxTokenModel length", dapComboBoxTokenModel.count)

            if (dapComboBoxTokenModel.count === 0)
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

            dapTextInputAmountPayment.text = ""
        }
    }

    dapComboBoxToken.onCurrentIndexChanged:
    {
        dapTextInputAmountPayment.text = ""
    }

    dapButtonClose.onClicked:
    {
//        previousActivated(lastActionsWallet)
        updateWalletTimer.start()
        pop()
        //DmitriyT Removed this code below. Will see reaction of app.
        //dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
    }

    dapButtonSend.onClicked:
    {
        if (dapComboBoxTokenModel.count <= dapComboBoxToken.currentIndex)
        {
            console.warn("dapComboBoxTokenModel.count <= dapComboBoxToken.currentIndex")
        }
        else
        {
            console.log("balance:", dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).datoshi)
            console.log("amount:", dapTextInputAmountPayment.text)
            console.log("wallet address:", dapTextInputRecipientWalletAddress.text.length)

            if (dapTextInputAmountPayment.text === "" ||
                logicWallet.testAmount("0.0", dapTextInputAmountPayment.text))
            {
                console.log("Zero value")
                dapTextNotEnoughTokensWarning.text = qsTr("Zero value.")
            }
            else
            if (dapTextInputRecipientWalletAddress.text.length != 104)
            {
                console.log("Wrong address length")
                dapTextNotEnoughTokensWarning.text = qsTr("Enter a valid wallet address.")
            }
            else
            {
                console.log("dapWalletMessagePopup.smartOpen")
                dapWalletMessagePopup.smartOpen(
                            "Confirming the transaction",
                            "Attention, the transaction fee will be 0.05 " + dapComboBoxToken.displayText )

            }
        }
    }

    dapWalletMessagePopup.onSignalAccept:
    {
        print("dapWalletMessagePopup.onSignalAccept", accept)

        if (accept)
        {
            if (dapComboBoxTokenModel === null || dapComboBoxChainModel === null ||
                dapComboBoxTokenModel.count <= dapComboBoxToken.currentIndex ||
                dapComboBoxChainModel.count <= dapComboboxChain.currentIndex)
            {
                if (dapComboBoxTokenModel === null)
                    console.warn("dapComboBoxTokenModel === null")
                if (dapComboBoxChainModel === null)
                    console.warn("dapComboBoxChainModel === null")
                if (dapComboBoxTokenModel.count <= dapComboBoxToken.currentIndex)
                    console.warn("dapComboBoxTokenModel.count <= dapComboBoxToken.currentIndex")
                if (dapComboBoxChainModel.count <= dapComboboxChain.currentIndex)
                    console.warn("dapComboBoxChainModel.count <= dapComboboxChain.currentIndex")
            }
            else
            {
                var amountWithCommission = (parseFloat(logicWallet.clearZeros(dapTextInputAmountPayment.text)) + 0.1).toString()
                print("amountWithCommission", amountWithCommission)
                var full_balance = dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).full_balance
                print("full_balance", full_balance)

                if (!logicWallet.testAmount(full_balance, amountWithCommission))
                {
                    print("Not enough tokens")
                    dapTextNotEnoughTokensWarning.text =
                        qsTr("Not enough available tokens. Maximum value = %1. Enter a lower value. Current value with comission = %2").
                        arg(dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).balance_without_zeros).arg(amountWithCommission)
                }
                else
                {
                    print("Enough tokens. Correct address length.")
                    dapTextNotEnoughTokensWarning.text = ""

                    var amount = logicWallet.toDatoshi(dapTextInputAmountPayment.text)

                    console.log("DapCreateTransactionCommand:")
                    console.log("   network:", dapComboboxNetwork.displayText)
                    console.log("   chain:", dapComboBoxChainModel.get(dapComboboxChain.currentIndex).name)
                    console.log("   wallet from:", walletName)
                    console.log("   wallet to:", dapTextInputRecipientWalletAddress.text)
                    console.log("   token:", dapComboBoxToken.displayText)
                    console.log("   amount:", amount)

                    var commission = logicWallet.toDatoshi("0.05")

                    dapServiceController.requestToService("DapCreateTransactionCommand",
                        dapComboboxNetwork.displayText, dapComboBoxChainModel.get(dapComboboxChain.currentIndex).name,
                        walletName,
                        dapTextInputRecipientWalletAddress.text,
                        dapComboBoxToken.displayText, amount, commission)
                }
            }
        }
    }

    Connections
    {
        target: dapServiceController
        onTransactionCreated:
        {
            commandResult = aResult
            updateWalletTimer.start()
            navigator.doneNewPayment()
        }
    }
}

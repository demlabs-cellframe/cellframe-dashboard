import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{
    property var walletName: ""

    Component.onCompleted:
    {
        walletName = dapModelWallets.get(logicMainApp.currentIndex).name

        logicWallet.initNetworks()

        updateWalletTimer.stop()
        if (dapServiceController.ReadingChains)
            dapChainGroup.visible = true
        else
            dapChainGroup.visible = false

        dapCmboBoxNetworkModel = dapNetworkModel

        dapTextNotEnoughTokensWarning.text = ""

        dapCmboBoxTokenModel = networksModel.
            get(dapComboboxNetwork.currentIndex).tokens

        dapCmboBoxChainModel = networksModel.
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
        if (networksModel.count <= dapComboboxNetwork.currentIndex)
        {
            console.warn("networksModel.count <= dapComboboxNetwork.currentIndex")
        }
        else
        {
            print("dapComboboxNetwork.onCurrentIndexChanged")

            dapCmboBoxTokenModel = networksModel.
                get(dapComboboxNetwork.currentIndex).tokens

            dapCmboBoxChainModel = networksModel.
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
    }

    dapCmboBoxToken.onCurrentIndexChanged:
    {
        dapTextInputAmountPayment.text = "0.0"
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
        if (dapCmboBoxTokenModel.count <= dapCmboBoxToken.currentIndex)
        {
            console.warn("dapCmboBoxTokenModel.count <= dapCmboBoxToken.currentIndex")
        }
        else
        {
            print("balance:", dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).datoshi)
            print("amount:", dapTextInputAmountPayment.text)
            print("wallet address:", dapTextInputRecipientWalletAddress.text.length)

            if (dapTextInputAmountPayment.text === "" ||
                logicWallet.testAmount("0.0", dapTextInputAmountPayment.text))
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
                print("walletMessagePopup.smartOpen", dapCmboBoxToken.mainLineText)
                walletMessagePopup.smartOpen("Confirming the transaction", "Attention, the transaction fee will be 0.1 " + dapCmboBoxToken.mainLineText )
            }
        }
    }

    Connections
    {
        target: walletMessagePopup
        onSignalAccept:
        {
            print("walletMessagePopup.onSignalAccept")
            print("dapCmboBoxTokenModel.count", dapCmboBoxTokenModel.count,
                  "dapCmboBoxToken.currentIndex", dapCmboBoxToken.currentIndex)
            print("dapCmboBoxChainModel.count", dapCmboBoxChainModel.count,
                  "dapComboboxChain.currentIndex", dapComboboxChain.currentIndex)

            console.log("   network:", dapComboboxNetwork.mainLineText)
            console.log("   wallet from:", walletName)
            console.log("   wallet to:", dapTextInputRecipientWalletAddress.text)
            console.log("   token:", dapCmboBoxToken.mainLineText)
            console.log("   amount:", logicWallet.toDatoshi(dapTextInputAmountPayment.text))

            if (dapCmboBoxTokenModel.count <= dapCmboBoxToken.currentIndex ||
                dapCmboBoxChainModel.count <= dapComboboxChain.currentIndex)
            {
                if (dapCmboBoxTokenModel.count <= dapCmboBoxToken.currentIndex)
                    console.warn("dapCmboBoxTokenModel.count <= dapCmboBoxToken.currentIndex")
                if (dapCmboBoxChainModel.count <= dapComboboxChain.currentIndex)
                    console.warn("dapCmboBoxChainModel.count <= dapComboboxChain.currentIndex")
            }
            else
            {
                print ("accept", accept)

                if (accept)
                {
                    var amountWithCommission = (parseFloat(logicWallet.clearZeros(dapTextInputAmountPayment.text)) + 0.1).toString()
                    print("amountWithCommission", amountWithCommission)
                    var full_balance = dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).full_balance
                    print("full_balance", full_balance)

                    if (!logicWallet.testAmount(full_balance, amountWithCommission))
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

                        var amount = logicWallet.toDatoshi(dapTextInputAmountPayment.text)

                        console.log("DapCreateTransactionCommand:")
                        console.log("   network:", dapComboboxNetwork.mainLineText)
                        console.log("   chain:", dapCmboBoxChainModel.get(dapComboboxChain.currentIndex).name)
                        console.log("   wallet from:", walletName)
                        console.log("   wallet to:", dapTextInputRecipientWalletAddress.text)
                        console.log("   token:", dapCmboBoxToken.mainLineText)
                        console.log("   amount:", amount)

                        var commission = logicWallet.toDatoshi("0.1")

                        dapServiceController.requestToService("DapCreateTransactionCommand",
                            dapComboboxNetwork.mainLineText, dapCmboBoxChainModel.get(dapComboboxChain.currentIndex).name,
                            walletName,
                            dapTextInputRecipientWalletAddress.text,
                            dapCmboBoxToken.mainLineText, amount, commission)
                    }
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
            updateWalletTimer.start()
            navigator.doneNewPayment()
        }
    }
}

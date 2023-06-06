import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{
    Component.onCompleted:
    {
//        updateWalletTimer.stop()
        walletModule.timerUpdateFlag(false);

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

        balance.fullText = dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).coins + " " + dapComboBoxToken.displayText

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
            console.log("dapComboboxNetwork.onCurrentIndexChanged")

            dapComboBoxTokenModel = networksModel.
                get(dapComboboxNetwork.currentIndex).tokens

            dapComboBoxChainModel = networksModel.
                get(dapComboboxNetwork.currentIndex).chains

            console.log("dapComboBoxTokenModel length", dapComboBoxTokenModel.count)

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

//            dapTextInputAmountPayment.text = ""
            balance.fullText = dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).coins + " " + dapComboBoxToken.displayText

        }
    }

    dapComboBoxToken.onCurrentIndexChanged:
    {
//        dapTextInputAmountPayment.text = ""
        balance.fullText = dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).coins + " " + dapComboBoxToken.displayText

    }

    dapButtonClose.onClicked:
    {
        walletModule.timerUpdateFlag(true);
        pop()
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
                stringWorker.testAmount("0.0", dapTextInputAmountPayment.text))
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
            if (dapComboBoxTokenModel === null || dapComboBoxTokenModel.count <= dapComboBoxToken.currentIndex)
            {
                if (dapComboBoxTokenModel === null)
                    console.warn("dapComboBoxTokenModel === null")
//                if (dapComboBoxChainModel === null)
//                    console.warn("dapComboBoxChainModel === null")
                if (dapComboBoxTokenModel.count <= dapComboBoxToken.currentIndex)
                    console.warn("dapComboBoxTokenModel.count <= dapComboBoxToken.currentIndex")
//                if (dapComboBoxChainModel.count <= dapComboboxChain.currentIndex)
//                    console.warn("dapComboBoxChainModel.count <= dapComboboxChain.currentIndex")
            }
            else
            {

                var amount = mathWorker.coinsToBalance(dapTextInputAmountPayment.text)
                var commission = modulesController.getComission(dapComboBoxToken.displayText, dapComboboxNetwork.displayText)
                var amountWithCommission = mathWorker.sumCoins(dapTextInputAmountPayment.text, commission, false)

                commission = mathWorker.coinsToBalance(commission)
                var full_balance = dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).coins

                console.log("amount_datoshi", amount)
                console.log("comission_datoshi", commission)
                console.log("amountWithCommission_coins", amountWithCommission)
                console.log("full_balance_coins", full_balance)

                if (!stringWorker.testAmount(full_balance, amountWithCommission))
                {
                    console.log("Not enough tokens")
                    dapTextNotEnoughTokensWarning.text =
                        qsTr("Not enough available tokens. Maximum value = %1. Enter a lower value. Current value with comission = %2").
                        arg(dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).coins).arg(amountWithCommission)
                }
                else
                {
                    console.log("Enough tokens. Correct address length.")
                    dapTextNotEnoughTokensWarning.text = ""

                    console.log("DapCreateTransactionCommand:")
                    console.log("   network:", dapComboboxNetwork.displayText)
                    console.log("   wallet from:", walletInfo.name)
                    console.log("   wallet to:", dapTextInputRecipientWalletAddress.text)
                    console.log("   token:", dapComboBoxToken.displayText)
                    console.log("   amount:", amount)
                    console.log("   comission:", commission)



                    var argsRequest = logicMainApp.createRequestToService("DapCreateTransactionCommand",
                        dapComboboxNetwork.displayText,
                        walletInfo.name,
                        dapTextInputRecipientWalletAddress.text,
                        dapComboBoxToken.displayText, amount, commission)

                    walletModule.createTx(argsRequest);
                }
            }
        }
    }
    function calculatePrecentAmount(percent)
    {
        var commission = 0.05

        if(!stringWorker.testAmount(dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).coins, commission))
            return "0.00"

        var balanceDatoshi = dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).datoshi
        var precentDatoshi = mathWorker.coinsToBalance(percent)
        var comissionDatoshi = mathWorker.coinsToBalance(commission)

        var availBalance = mathWorker.subCoins(balanceDatoshi, comissionDatoshi, true)

        var resAmount = mathWorker.multCoins(availBalance, precentDatoshi, false)


        //down fixed
        var digits = 6
        const factor = 10 ** digits;
        var abtAmount = (Math.round(parseFloat(resAmount) * factor - 0.5) / factor).toFixed(digits);
        abtAmount = stringWorker.clearZeros(abtAmount)

        var resAbt
        if(abtAmount[0]=== ".")
            resAbt = "~0"+abtAmount
        else
            resAbt = "~"+abtAmount

        var res = [resAmount, resAbt]
//        console.log(res[0], res[1])



        return res
    }


    Connections
    {
        target: walletModule
        function onSigTxCreate(aResult)
        {
            commandResult = aResult
            walletModule.timerUpdateFlag(true);
            navigator.doneNewPayment()
        }
    }
}

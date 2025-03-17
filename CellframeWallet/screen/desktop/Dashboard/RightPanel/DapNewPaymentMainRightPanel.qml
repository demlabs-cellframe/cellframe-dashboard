import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{
    Component.onCompleted:
    {
        loadIndicator.running = false
        dapButtonSend.enabled = true

        walletModule.setWalletTokenModel(dapComboboxNetwork.displayText)
        if (dapServiceController.ReadingChains)
            dapChainGroup.visible = true
        else
            dapChainGroup.visible = false

        dapTextNotEnoughTokensWarning.text = ""
        balance.fullText = walletTokensModel.get(dapComboBoxToken.displayText).value
                         + " " + dapComboBoxToken.displayText

    }

    dapComboBoxToken.onCurrentIndexChanged:
    {
        balance.fullText = walletTokensModel.get(dapComboBoxToken.displayText).value
                                 + " " + dapComboBoxToken.displayText
    }

    dapButtonClose.onClicked:
    {
        txExplorerModule.statusProcessing = true
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
            console.log("balance:", dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).valueDatoshi)
            console.log("address from:", dapComboboxNetwork.model.get(dapComboboxNetwork.currentIndex).address)
            console.log("amount:", dapTextInputAmountPayment.text)
            console.log("address to:", dapTextInputRecipientWalletAddress.text)

            if (dapTextInputAmountPayment.text === "" ||
                stringWorker.testAmount("0.0", dapTextInputAmountPayment.text))
            {
                console.log("Zero value")
                dapTextNotEnoughTokensWarning.text = qsTr("Zero value.")
            }
            else if (dapComboboxNetwork.model.get(dapComboboxNetwork.currentIndex).address === dapTextInputRecipientWalletAddress.text)
            {
                console.warn("An attempt to transfer tokens to your address.")
                dapTextNotEnoughTokensWarning.text = qsTr("Error. An attempt to transfer tokens to your address.")
            }
            else if (dapTextInputRecipientWalletAddress.text.length != 104 && dapTextInputRecipientWalletAddress.text != "null")
            {
                console.log("Wrong address length")
                dapTextNotEnoughTokensWarning.text = qsTr("Enter a valid wallet address.")
            }
            else
            {
                if (dapComboBoxTokenModel === null || dapComboBoxTokenModel.count <= dapComboBoxToken.currentIndex)
                {
                    if (dapComboBoxTokenModel === null)
                    {
                        console.warn("dapComboBoxTokenModel === null")
                        dapTextNotEnoughTokensWarning.text = qsTr("Error. No tokens")
                    }
                    if (dapComboBoxTokenModel.count <= dapComboBoxToken.currentIndex)
                    {
                        console.warn("dapComboBoxTokenModel.count <= dapComboBoxToken.currentIndex")
                        dapTextNotEnoughTokensWarning.text = qsTr("Error. No selected token")
                    }
                }
                else
                {
                    dapTextNotEnoughTokensWarning.text = ""
                    var data = {
                    "network"       : dapComboboxNetwork.displayText,
                    "amount"        : dapTextInputAmountPayment.text,
                    "send_ticker"   : dapComboBoxToken.displayText,
                    "wallet_name"   : walletInfo.name,
                    "validator_fee" : valueToFloat(dapFeeController.currentValue)}

                    var res = walletModule.approveTx(data);

                    switch(res.error) {
                    case 0:
                        console.log("Correct tx data")
                        console.log("dapWalletMessagePopup.smartOpen")
                        dapWalletMessagePopup.network = dapComboboxNetwork.displayText
                        dapWalletMessagePopup.smartOpen(
                                    qsTr("Confirming the transaction"),
                                    qsTr("Attention, the transaction fee will be held "))
                        break;
                    case 1:
                        console.warn("Rcv fee error")
                        dapTextNotEnoughTokensWarning.text =
                            qsTr("Error processing network information")
                        break;
                    case 2:
                        console.warn("Not enough tokens")
                        dapTextNotEnoughTokensWarning.text =
                            qsTr("Not enough available tokens. Maximum value with fee = %1.")
                                .arg(res.availBalance)
//                        dapTextNotEnoughTokensWarning.text =
//                            qsTr("Not enough available tokens. Maximum value with fee = %1. Enter a lower value. Current value = %2")
//                                .arg(res.availBalance).arg(dapTextInputAmountPayment.text)
                        break;
                    case 3:
                        console.warn("Not enough tokens for pay fee")
                        dapTextNotEnoughTokensWarning.text =
                            qsTr("Not enough available tokens for fee. Balance = %1. Current fee value = %2")
                                .arg(res.availBalance).arg(res.feeSum)
                        break;
                    case 4:
                        console.warn("No tokens for create transaction")
                        dapTextNotEnoughTokensWarning.text =
                            qsTr("No tokens for create transaction")
                        break;
                    default:
                        console.warn("Unknown error")
                        dapTextNotEnoughTokensWarning.text =
                            qsTr("Unknown error")
                        break;
                    }
                }
            }
        }
    }

    dapWalletMessagePopup.onSignalAccept:
    {
        console.log("dapWalletMessagePopup.onSignalAccept", accept)

        if (accept)
        {
            dapTextNotEnoughTokensWarning.text = ""
            //create tx

            var dataTx = {
            "network"           : dapComboboxNetwork.displayText,
            "amount"            : dapTextInputAmountPayment.text,
            "send_ticker"       : dapComboBoxToken.displayText,
            "wallet_from"       : walletInfo.name,
            "wallet_to"         : dapTextInputRecipientWalletAddress.text,
            "validator_fee"     : valueToFloat(dapFeeController.currentValue)}

            console.info(dataTx)
            walletModule.sendTx(dataTx)
        }
    }

    Connections
    {
        target: walletModule
        function onSigTxCreate(aResult)
        {
            commandResult = aResult
            if(aResult.toQueue)
            {
                navigator.toQueueNewPayment()
            }
            else
            {
                navigator.doneNewPayment()
            }

            loadIndicator.running = false
            dapButtonSend.enabled = true
        }

        function onTokenModelChanged()
        {
            if(dapComboBoxToken.model.count > 0)
            {
                dapComboBoxToken.setCurrentIndex(0)
                dapComboBoxToken.displayText = walletTokensModel.get(0).tokenName
            }
        }
    }
}

import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{
    Component.onCompleted:
    {
        walletModule.timerUpdateFlag(false);
        walletModule.setWalletTokenModel(dapComboboxNetwork.displayText)
        if (dapServiceController.ReadingChains)
            dapChainGroup.visible = true
        else
            dapChainGroup.visible = false

        dapTextNotEnoughTokensWarning.text = ""
        walletModule.startUpdateFee()
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
            console.log("balance:", dapComboBoxTokenModel.get(dapComboBoxToken.currentIndex).valueDatoshi)
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
                    var data = {
                    "network"      : dapComboboxNetwork.displayText,
                    "amount"       : dapTextInputAmountPayment.text,
                    "send_ticker"  : dapComboBoxToken.displayText,
                    "wallet_name"  : walletInfo.name}

                    var res = walletModule.approveTx(data);

                    switch(res.error) {
                    case 0:
                        console.log("Correct tx data")
                        console.log("dapWalletMessagePopup.smartOpen")
                        walletModule.stopUpdateFee()
                        dapWalletMessagePopup.network = dapComboboxNetwork.displayText
                        dapWalletMessagePopup.smartOpen(
                                    qsTr("Confirming the transaction"),
                                    qsTr("Attention, the transaction fee will be "))
                        break;
                    case 1:
                        console.warn("Rcv fee error")
                        dapTextNotEnoughTokensWarning.text =
                            qsTr("Error processing network information")
                        break;
                    case 2:
                        console.warn("Not enough tokens")
                        dapTextNotEnoughTokensWarning.text =
                            qsTr("Not enough available tokens. Maximum value with fee = %1. Enter a lower value. Current value = %2")
                                .arg(res.availBalance).arg(dapTextInputAmountPayment.text)
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

    Component.onDestruction:
    {
        console.log("The right panel for transferring funds was closed")
        walletModule.stopUpdateFee()
    }

    dapWalletMessagePopup.onSignalAccept:
    {
        console.log("dapWalletMessagePopup.onSignalAccept", accept)

        if (accept)
        {
            dapTextNotEnoughTokensWarning.text = ""
            //create tx

            var dataTx = {
            "network"      : dapComboboxNetwork.displayText,
            "amount"       : dapTextInputAmountPayment.text,
            "send_ticker"  : dapComboBoxToken.displayText,
            "wallet_from"  : walletInfo.name,
            "wallet_to"    : dapTextInputRecipientWalletAddress.text}

            console.info(dataTx)
            walletModule.sendTx(dataTx)
        }
        else
        {
            walletModule.startUpdateFee()
        }
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

        function onTokenModelChanged()
        {
            if(dapComboBoxToken.model.count > 0)
            {
                dapComboBoxToken.currentIndex = 0;
                dapComboBoxToken.displayText = walletTokensModel.get(0).tokenName
            }
        }
    }
}

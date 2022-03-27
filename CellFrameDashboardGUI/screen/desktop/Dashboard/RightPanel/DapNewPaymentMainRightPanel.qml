import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{
    // The form displayed after clicking on the "Send" button
//    dapNextRightPanel: newPaymentDone
//    dapPreviousRightPanel: lastActionsWallet

    Component.onCompleted:
    {
        if (dapServiceController.ReadingChains)
            dapChainGroup.visible = true
        else
            dapChainGroup.visible = false

        dapCmboBoxNetworkModel = _dapModelNetworks

        dapCmboBoxTokenModel = _dapModelWallets.get(globalLogic.currentIndex).networks.get(dapComboboxNetwork.currentIndex).tokens
        dapTextNotEnoughTokensWarning.text = ""

        dapCmboBoxChainModel = _dapModelWallets.get(globalLogic.currentIndex).networks.
            get(dapComboboxNetwork.currentIndex).chains

        dapTextInputAmountPayment.text = dapTextInputAmountPayment.placeholderText

        if(dapCmboBoxNetworkModel.count)
            dapComboboxNetwork.mainLineText = dapCmboBoxNetworkModel.get(0).name
        else
            dapComboboxNetwork.mainLineText = "Networks"
    }
    dapComboboxNetwork.onCurrentIndexChanged:
    {
        print("dapComboboxNetwork.onCurrentIndexChanged")
        print("networkName", dapCmboBoxNetworkModel.get(dapComboboxNetwork.currentIndex).name)

        dapCmboBoxChainModel = _dapModelWallets.get(globalLogic.currentIndex).networks.
            get(dapComboboxNetwork.currentIndex).chains

        dapCmboBoxTokenModel = _dapModelWallets.get(globalLogic.currentIndex).networks.get(dapComboboxNetwork.currentIndex).tokens

        print("dapCmboBoxTokenModel length", dapCmboBoxTokenModel.count)

        if (dapCmboBoxTokenModel.count === 0)
        {
            dapFrameAmountPayment.visible = false
            dapFrameInputAmountPayment.visible = false
            dapFrameRecipientWallet.visible = false
            dapFrameRecipientWalletAddress.visible = false
            dapButtonSend.visible = false
        }
        else
        {
            dapFrameAmountPayment.visible = true
            dapFrameInputAmountPayment.visible = true
            dapFrameRecipientWallet.visible = true
            dapFrameRecipientWalletAddress.visible = true
            dapButtonSend.visible = true
        }

        dapTextInputAmountPayment.text = dapTextInputAmountPayment.placeholderText
    }

    dapCmboBoxToken.onCurrentIndexChanged:
    {
        dapTextInputAmountPayment.text = dapTextInputAmountPayment.placeholderText
    }

    dapButtonClose.onClicked:
    {
        pop()
    }

    dapButtonSend.onClicked:
    {
        print("balanse:", dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).datoshi)
        print("amount:", dapTextInputAmountPayment.text)
        print("wallet address:", dapTextInputRecipientWalletAddress.text.length)

        if (dapTextInputAmountPayment.text === "" ||
            testAmount("0.0", dapTextInputAmountPayment.text))
        {
            print("Zero value")
            dapTextNotEnoughTokensWarning.text = qsTr("Zero value.")
        }
        else
        if (!testAmount(
            dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).full_balance,
            dapTextInputAmountPayment.text))
        {
            print("Not enough tokens")
            dapTextNotEnoughTokensWarning.text =
                qsTr("Not enough available tokens. Maximum value = %1. Enter a lower value.").
                arg(dapCmboBoxTokenModel.get(dapCmboBoxToken.currentIndex).balance_without_zeros)
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

            var amount = toDatoshi(dapTextInputAmountPayment.text)

            console.log("DapCreateTransactionCommand:")
            console.log("   network:", dapComboboxNetwork.mainLineText)
            console.log("   chain:", dapCmboBoxChainModel.get(dapComboboxChain.currentIndex).name)
            console.log("   wallet from:", _dapModelWallets.get(globalLogic.currentIndex).name)
            console.log("   wallet to:", dapTextInputRecipientWalletAddress.text)
            console.log("   token:", dapCmboBoxToken.mainLineText)
            console.log("   amount:", amount)
            dapServiceController.requestToService("DapCreateTransactionCommand",
//                dapComboboxNetwork.mainLineText, dapComboboxChain.mainLineText,
                dapComboboxNetwork.mainLineText, dapCmboBoxChainModel.get(dapComboboxChain.currentIndex).name,
                _dapModelWallets.get(globalLogic.currentIndex).name,
                dapTextInputRecipientWalletAddress.text,
                dapCmboBoxToken.mainLineText, amount)

//            nextActivated("transaction created")
            navigator.doneNewPayment()
        }
    }

//    function testAmount(balance, amount)
//    {
//        var res = testAmount1(balance, amount)
//        print("testAmount", balance, amount, res)

//        return res
//    }

    function testAmount(balance, amount)
    {
        balance = clearZeros(balance)
        amount = clearZeros(amount)

        var balanceArray = balance.split('.')
        var amountArray = amount.split('.')

        if (balanceArray.length < 1 || amountArray.length < 1)
            return false

        if (compareStringNumbers1(balanceArray[0], amountArray[0]) > 0)
            return true

        if (compareStringNumbers1(balanceArray[0], amountArray[0]) < 0)
            return false

        if (amountArray.length < 2)
            return true

        if (balanceArray.length < 2)
            return false

        if (compareStringNumbers2(balanceArray[1], amountArray[1]) > 0)
            return true

        if (compareStringNumbers2(balanceArray[1], amountArray[1]) < 0)
            return false

        return true
    }

    function clearZeros(str)
    {
        var i = 0;
        while (i < str.length)
        {
            if (str[i] !== '0')
                break
            ++i
        }
        str = str.slice(i, str.length)

        if (str.indexOf('.') === -1)
            return str

        i = str.length-1
        while (i >= 0)
        {
            if (str[i] !== '0')
                break
            --i
        }
        str = str.slice(0, i+1)

        return str
    }

    function compareStringNumbers1(str1, str2)
    {
        if (str1 === str2)
            return 0

        if (str1.length < str2.length)
            return -1

        if (str1.length > str2.length)
            return 1

        if (str1 < str2)
            return -1

        if (str1 > str2)
            return 1

        return 0
    }

    function compareStringNumbers2(str1, str2)
    {
        if (str1 === str2)
            return 0

        var size = str1.length

        if (str1.length > str2.length)
            size = str2.length

        for (var i = 0; i < size; ++i)
        {
            if (str1[i] < str2[i])
                return -1
            if (str1[i] > str2[i])
                return 1
        }

        if (str1.length < str2.length)
            return -1

        if (str1.length > str2.length)
            return 1

        return 0
    }

    function toDatoshi(str)
    {
        print("toDatoshi", str)

        var dotIndex = str.indexOf('.')

        if (dotIndex === -1)
        {
            str += "000000000"
        }
        else
        {
            var shift = 10 - str.length + dotIndex

            str += "0".repeat(shift)

            str = str.slice(0, dotIndex) + str.slice(dotIndex+1, str.length)
        }

        var i = 0;
        while (i < str.length)
        {
            if (str[i] !== '0')
                break
            ++i
        }
        str = str.slice(i, str.length)

        return str
    }
}

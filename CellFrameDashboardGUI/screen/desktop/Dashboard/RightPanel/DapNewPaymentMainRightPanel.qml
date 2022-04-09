import QtQuick 2.4

DapNewPaymentMainRightPanelForm
{
    // The form displayed after clicking on the "Send" button
    dapNextRightPanel: newPaymentDone
    dapPreviousRightPanel: lastActionsWallet

//    property var currentWallet: ""

    property var walletName: ""

    ListModel {
        id: networkModel
    }

    Component.onCompleted:
    {
//        currentWallet = dapModelWallets.get(SettingsWallet.currentIndex)

        walletName = dapModelWallets.get(logicMainApp.currentIndex).name

        initNetworks()

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
        previousActivated(lastActionsWallet)
        updateTimer.start()
        //DmitriyT Removed this code below. Will see reaction of app.
        //dapDashboardScreen.dapButtonNewPayment.colorBackgroundNormal = "#070023"
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
        if (dapTextInputRecipientWalletAddress.text.length != 104)
        {
            print("Wrong address length")
            dapTextNotEnoughTokensWarning.text = qsTr("Enter a valid wallet address.")
        }
//        else
//        if(!certificates.count)
//        {
//            print("No signature certificate")
//            dapTextNotEnoughTokensWarning.text = qsTr("No signature certificate. Reload 'Wallet' page")
//        }
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
                var amountWithCommission = (parseFloat(clearZeros(dapTextInputAmountPayment.text)) + 0.1).toString()
                if (!testAmount(
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

                    var amount = toDatoshi(dapTextInputAmountPayment.text)

                    console.log("DapCreateTransactionCommand:")
                    console.log("   network:", dapComboboxNetwork.mainLineText)
                    console.log("   chain:", dapCmboBoxChainModel.get(dapComboboxChain.currentIndex).name)
                    console.log("   wallet from:", walletName)
                    console.log("   wallet to:", dapTextInputRecipientWalletAddress.text)
                    console.log("   token:", dapCmboBoxToken.mainLineText)
                    console.log("   amount:", amount)

                    var commission = toDatoshi("0.1")


                    dapServiceController.requestToService("DapCreateTransactionCommand",
        //                dapComboboxNetwork.mainLineText, dapComboboxChain.mainLineText,
                        dapComboboxNetwork.mainLineText, dapCmboBoxChainModel.get(dapComboboxChain.currentIndex).name,
    //                    currentWallet.name,
                        walletName,
                        dapTextInputRecipientWalletAddress.text,
                        dapCmboBoxToken.mainLineText, amount, commission)

                    nextActivated("transaction created")
                    updateTimer.start()
                }
            }
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
//        print("clearZeros", str)

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
            str += "000000000000000000"
//            str += "000000000"
        }
        else
        {
            var shift = 19 - str.length + dotIndex
//            var shift = 10 - str.length + dotIndex

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

    function initNetworks()
    {
        networkModel.clear()

        var tempNetworks = dapModelWallets.
            get(logicMainApp.currentIndex).networks

        for (var i = 0; i < tempNetworks.count; ++i)
        {
            networkModel.append(
                        { "tokens" : [],
                          "chains" : [] })

            for (var j = 0; j < tempNetworks.get(i).tokens.count; ++j)
            {
                networkModel.get(i).tokens.append(
                    { "name" : tempNetworks.get(i).tokens.get(j).name,
                      "datoshi": tempNetworks.get(i).tokens.get(j).datoshi,
                      "full_balance": tempNetworks.get(i).tokens.get(j).full_balance,
                      "balance_without_zeros": tempNetworks.get(i).tokens.get(j).balance_without_zeros})
            }

            for (var k = 0; k < tempNetworks.get(i).chains.count; ++k)
            {
                networkModel.get(i).chains.append(
                    { "name" : tempNetworks.get(i).chains.get(k).name})
            }
        }

    }
}

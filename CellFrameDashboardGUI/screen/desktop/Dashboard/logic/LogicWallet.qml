import QtQuick 2.12
import QtQml 2.12

QtObject {

    function updateAllWallets()
    {
        dapModelWallets.clear()
        dapServiceController.requestToService("DapGetWalletsInfoCommand");
    }

    function updateCurrentWallet()
    {
        print("updateCurrentWallet", "networkArray", logicMainApp.networkArray)

        if (logicMainApp.currentIndex !== -1 && logicMainApp.networkArray !== "")
            dapServiceController.requestToService("DapGetWalletInfoCommand",
                dapModelWallets.get(logicMainApp.currentIndex).name,
                logicMainApp.networkArray);
    }

    function updateComboBox()
    {
        if(logicMainApp.currentIndex !== -1)
        {
            if(dapModelWallets.count)
            {
                dashboardScreen.dapListViewWallet.model = dapModelWallets.get(logicMainApp.currentIndex).networks
                dashboardTopPanel.dapFrameTitle.text = dapModelWallets.get(logicMainApp.currentIndex).name

                console.log("dapComboboxWallet.onCurrentIndexChanged")

                dashboardTab.state = "WALLETSHOW"
            }
        }
    }

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
        networksModel.clear()

        var tempNetworks = dapModelWallets.
            get(logicMainApp.currentIndex).networks

        for (var i = 0; i < tempNetworks.count; ++i)
        {
            networksModel.append(
                        { "tokens" : [],
                          "chains" : [] })

            for (var j = 0; j < tempNetworks.get(i).tokens.count; ++j)
            {
                networksModel.get(i).tokens.append(
                    { "name" : tempNetworks.get(i).tokens.get(j).name,
                      "datoshi": tempNetworks.get(i).tokens.get(j).datoshi,
                      "full_balance": tempNetworks.get(i).tokens.get(j).full_balance,                    
                      "balance_without_zeros": tempNetworks.get(i).tokens.get(j).balance_without_zeros})
            }

            for (var k = 0; k < tempNetworks.get(i).chains.count; ++k)
            {
                networksModel.get(i).chains.append(
                    { "name" : tempNetworks.get(i).chains.get(k).name})
            }
        }

    }

}

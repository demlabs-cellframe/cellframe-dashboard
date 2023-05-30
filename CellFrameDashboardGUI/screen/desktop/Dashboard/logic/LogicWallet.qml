import QtQuick 2.12
import QtQml 2.12

QtObject {

    property bool restoreWalletMode: false

    function updateAllWallets()
    {
        dapModelWallets.clear()
        logicMainApp.requestToService("DapGetWalletsInfoCommand", "true");
    }

    function updateCurrentWallet()
    {
//        print("updateCurrentWallet", logicMainApp.currentIndex, dapModelWallets.get(logicMainApp.currentIndex).status )

        if (logicMainApp.currentWalletIndex !== -1)
        {
            if(logicMainApp.currentWalletIndex < dapModelWallets.count)
            {
                logicMainApp.currentWalletIndex--
                return
            }

            logicMainApp.requestToService("DapGetWalletInfoCommand",
                dapModelWallets.get(logicMainApp.currentWalletIndex).name)
        }
    }

    function updateWalletModel()
    {
//        if(logicMainApp.currentWalletIndex !== -1)
//        {
//            if(dapModelWallets.count)
//            {
//                console.log("AAAAAAAAAAAAAAa", M_wallet.walletsModel)
//                dashboardScreen.dapListViewWallet.model = M_wallet.walletsModel[logicMainApp.currentWalletIndex].networks

////                dashboardScreen.dapListViewWallet.model = dapModelWallets.get(logicMainApp.currentWalletIndex).networks
////                dashboardTopPanel.dapFrameTitle.fullText = dapModelWallets.get(logicMainApp.currentWalletIndex).name

////                console.log("dapComboboxWallet.onCurrentIndexChanged")

//                dashboardTab.state = "WALLETSHOW"
//            }
//        }
    }

    function updateWalletsModel(model)
    {
        console.log(model)
        if(model == "isEqual")
            return


        var jsonDocument = JSON.parse(model)

        if(!jsonDocument)
        {
            dapModelWallets.clear()
            return
        }

        dapModelWallets.clear()
        dapModelWallets.append(jsonDocument)

        console.log("rcvWallets", "currentWalletName", logicMainApp.currentWalletName)

        var nameIndex = -1

        for (var i = 0; i < dapModelWallets.count; ++i)
        {
            if (dapModelWallets.get(i).name === logicMainApp.currentWalletName)
                nameIndex = i
        }

        console.log("rcvWallets", "nameIndex", nameIndex)

        if (nameIndex >= 0)
            logicMainApp.currentWalletIndex = nameIndex

        if (logicMainApp.currentWalletIndex < 0 && dapModelWallets.count > 0)
            logicMainApp.currentWalletIndex = 0
        if (dapModelWallets.count < 0)
            logicMainApp.currentWalletIndex = -1

        if(logicMainApp.currentWalletIndex !== -1)
        {
            if(dapModelWallets.count)
            {
                dashboardScreen.dapListViewWallet.model = dapModelWallets.get(logicMainApp.currentWalletIndex).networks
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
            get(logicMainApp.currentWalletIndex).networks

        for (var i = 0; i < tempNetworks.count; ++i)
        {
            networksModel.append(
                        { "tokens" : []})

            for (var j = 0; j < tempNetworks.get(i).tokens.count; ++j)
            {
                networksModel.get(i).tokens.append(
                    { "name" : tempNetworks.get(i).tokens.get(j).name,
                      "datoshi": tempNetworks.get(i).tokens.get(j).datoshi,
                      "coins": tempNetworks.get(i).tokens.get(j).coins})
            }
        }
    }
}

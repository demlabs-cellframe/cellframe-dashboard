import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12

QtObject
{
    property int selectTokenIndex: -1
    property int selectNetworkIndex: -1

    function unselectToken()
    {
        selectTokenIndex = -1
        selectNetworkIndex = -1
    }

    function initDetailsModel()
    {
        detailsModel.clear()
//        detailsModel = dapModelTokens.get(logicTokens.selectNetworkIndex).tokens.get(logicTokens.selectTokenIndex)
        detailsModel.append(dapModelTokens.get(logicTokens.selectNetworkIndex).tokens.get(logicTokens.selectTokenIndex))
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

    property var tokenModel:
        [
        {
            name: "network1",
            address: "12345",
            tokens:
                [
                {
                    name: "token1",
                    balance: "100"
                },
                {
                    name: "token2",
                    balance: "100"},
                {
                    name: "token3",
                    balance: "100"
                }
            ]
        },
        {
            name: "network2",
            address: "12345",
            tokens:
                [
                {
                    name: "token1",
                    balance: "100"
                },
                {
                    name: "token2",
                    balance: "100"},
                {
                    name: "token3",
                    balance: "100"
                }
            ]
        },
        {
            name: "network3",
            address: "12345",
            tokens:
                [
                {
                    name: "token1",
                    balance: "100"
                },
                {
                    name: "token2",
                    balance: "100"},
                {
                    name: "token3",
                    balance: "100"
                }
            ]
        }
    ]

    property var modelLastActions:
            [
                {
                    network: "network1",
                    status: "Local",
                    sign: "+",
                    amount: "412.8",
                    name: "token1",
                    date: "Today"
                },
                {
                    network: "network1",
                    status: "Mempool (X Confirms)",
                    sign: "+",
                    amount: "103",
                    name: "token4",
                    date: "July, 22"
                },
                {
                    network: "network3",
                    status: "Canceled",
                    sign: "-",
                    amount: "22.345",
                    name: "token1",
                    date: "December, 21"
                },
                {
                    network: "network1",
                    status: "Successful (X Confirms)",
                    sign: "+",
                    amount: "264.11",
                    name: "token4",
                    date: "December, 20"
                },
                {
                    network: "network4",
                    status: "Local",
                    sign: "-",
                    amount: "666.666",
                    name: "token1",
                    date: "November, 14"
                },
                {
                    network: "network4",
                    status: "Successful (X Confirms)",
                    sign: "-",
                    amount: "932.16",
                    name: "token1",
                    date: "November, 11"
                }
            ]
}

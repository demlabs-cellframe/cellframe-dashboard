import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12

QtObject
{
    property int selectTokenIndex: -1
    property int selectNetworkIndex: -1

    property var commandResult

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

/*    function testAmount(balance, amount)
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
    }*/

    //TODO: needed filtering
//    function modelUpdate()
//    {
//        temporaryModel.clear()
//        tokensModel.clear()
//        for(var i = 0; i < dapModelTokens.count; i++)
//        {
//            temporaryModel.append(dapModelTokens.get(i))
//            tokensModel.append(dapModelTokens.get(i))
//        }
//    }

//    function filterResults(text)
//    {
//        tokensModel.clear()
//        var fstr = text.toLocaleLowerCase()

//        for (var i = 0; i < temporaryModel.count; ++i)
//        {
//            var arrTokens = []
//            for(var j = 0; j < temporaryModel.get(i).tokens.count; j++)
//            {
//                var name = temporaryModel.get(i).tokens.get(j).name

//                if (name.toLowerCase().indexOf(fstr) >= 0)
//                {
//                    arrTokens.push(temporaryModel.get(i).tokens.get(j))
//                }
//            }

//            if(text === "")
//            {
//                tokensModel.append(temporaryModel.get(i))
//            }
//            else{
//                tokensModel.append({"network": temporaryModel.get(i).network,
//                                "tokens": arrTokens.toString()})
//            }

//        }

//        dapHistoryScreen.dapListViewHistory.positionViewAtBeginning()
//    }
}

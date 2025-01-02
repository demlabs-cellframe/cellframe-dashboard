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

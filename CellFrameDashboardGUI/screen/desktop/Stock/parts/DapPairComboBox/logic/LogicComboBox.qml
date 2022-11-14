import QtQuick 2.12
import QtQml 2.12

Item {

    signal awaitingFinished(string text)

    property bool validTextLength: false
    property string awaitingValidText: ""

    Timer{
        id: waitInputTimer
        interval: 100
        onTriggered: {
           awaitingFinished(awaitingValidText)  //возможно неверный объект
        }
    }

    function filter(text){
        validTextLength = text.length >= 0
        if (validTextLength) {            //минимум символов для поиска адресов 0
            awaitingValidText = text
            waitInputTimer.restart()
        }
    }

    function clear(){
        waitInputTimer.stop()
        awaitingValidText = ""
    }

    function searchElement(text)
    {
        var fstr = text.toLocaleLowerCase()

        mainModel.clear()
        for(var i = 0; i < temporaryModel.count; i++)
        {
            var tokenBuy = temporaryModel.get(i).tokenBuy
            var tokenSell = temporaryModel.get(i).tokenSell
            var rate = temporaryModel.get(i).priceText
            var change = temporaryModel.get(i).change

            if(tokenBuy.toLowerCase().indexOf(fstr) >= 0 ||
               tokenSell.toLowerCase().indexOf(fstr) >= 0 ||
               rate.toLowerCase().indexOf(fstr) >= 0 ||
               change.toLowerCase().indexOf(fstr) >= 0)
            {
                mainModel.append(temporaryModel.get(i))
            }
            else if(text === "")
            {
                mainModel.append(temporaryModel.get(i))
            }
        }
    }

    function setModel(model)
    {
        temporaryModel.clear()
        mainModel.clear();
        for(var i = 0; i < model.length; i++)
            temporaryModel.append(model[i])

        for (var i = 0; i < temporaryModel.count; ++i)
            mainModel.append(temporaryModel.get(i))

        control.model = mainModel
        displayElement = temporaryModel.get(0)
        initModelIsCompleted()
    }

    function getModelData(index, role)
    {
        if(index >= 0)
        {
            var text = model.get(index)[role]

            if (text === undefined)
                return ""
            else
                return model.get(index)[role];
        }
        else
            return ""
    }

    function getIcon(nameCoin)
    {
        if(nameCoin === "CELL")
            return "icons/cell_icon.png"
        else if(nameCoin === "DAI")
            return "icons/dai_icon.png"
        else if(nameCoin === "USDT")
            return "icons/usdt_icon.png"
        else if(nameCoin === "BNB")
            return "icons/bnb_icon.png"
        else if(nameCoin === "ETH")
            return "icons/eth_icon.png"
    }
}

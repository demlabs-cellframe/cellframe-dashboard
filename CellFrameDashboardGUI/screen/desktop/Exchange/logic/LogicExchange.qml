import QtQuick 2.12
import QtQml 2.12

QtObject {

    function generateData(model, length)
    {
        var currentData = 10000

        for (var i = 0; i < length; ++i)
        {
            currentData += Math.random()*10 - 5

//            print(currentData)

            model.append({ "data" : currentData })
        }
    }

    function getCandleModel(rowModel, candleModel, step)
    {
        var openValue = 0
        var closeValue = 0
        var minValue = 0
        var maxValue = 0

        for (var i = 0; i < rowModel.count; ++i)
        {
            if (i % step === 0)
            {
                openValue = rowModel.get(i).data
                closeValue = rowModel.get(i).data
                minValue = rowModel.get(i).data
                maxValue = rowModel.get(i).data
            }
            else
            {
                if (i % step === step-1)
                    closeValue = rowModel.get(i).data

                if (minValue > rowModel.get(i).data)
                    minValue = rowModel.get(i).data

                if (maxValue < rowModel.get(i).data)
                    maxValue = rowModel.get(i).data
            }

            if (i % step === step-1)
            {
                candleModel.append({
                    "time": i*10 + 1546543400,
                    "minimum": minValue,
                    "maximum": maxValue,
                    "open": openValue,
                    "close": closeValue })
//                print("minimum", minValue,
//                      "maximum", maxValue,
//                      "open", openValue,
//                      "close", closeValue)
            }
        }
    }

    function initCandleStickModel()
    {
        candleModel.append({"time":1546543400, "minimum":10000, "maximum":10550, "open":10050, "close":10100})
        candleModel.append({"time":1546543700, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546544000, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546544300, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546544600, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546544900, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546545200, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546545500, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546545800, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546546100, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546546400, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546546700, "minimum":10300, "maximum":10550, "open":10450, "close":10400})
        candleModel.append({"time":1546547000, "minimum":10200, "maximum":10650, "open":10350, "close":10400})
        candleModel.append({"time":1546547300, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546547600, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546547900, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546548200, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546548500, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546548800, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546549100, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546549400, "minimum":10300, "maximum":10650, "open":10450, "close":10400})
        candleModel.append({"time":1546549700, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546550000, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546550300, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546550600, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546550900, "minimum":10500, "maximum":10650, "open":10550, "close":10580})
        candleModel.append({"time":1546551200, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546551500, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546551800, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546552100, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546552400, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546552700, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546553000, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546553300, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546553600, "minimum":10650, "maximum":10950, "open":10800, "close":10750})
        candleModel.append({"time":1546553900, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546554200, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546554500, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
        candleModel.append({"time":1546554800, "minimum":10200, "maximum":10450, "open":10350, "close":10400})
    }

    function initConversonModel()
    {
        conversionList.append({"text":"TKN1/NGD"})
        conversionList.append({"text":"TKN2/NGD"})
        conversionList.append({"text":"NGD/KLVN"})
        conversionList.append({"text":"KLVN/USD"})
    }

    function initTimeModel()
    {
        timeModel.append({"text":"1 minute"})
        timeModel.append({"text":"5 minute"})
        timeModel.append({"text":"15 minute"})
        timeModel.append({"text":"30 minute"})
        timeModel.append({"text":"1 hour"})
        timeModel.append({"text":"4 hour"})
        timeModel.append({"text":"12 hour"})
        timeModel.append({"text":"24 hour"})
    }

    function initOrdersModel()
    {
        orderModel.append({"titleOrder":"Buy", "path":"qrc:/resources/icons/buy_icon.png", "currencyName":"KLVN", "tokenName":"TKN1", "balance": 0})
        orderModel.append({"titleOrder":"Sell", "path":"qrc:/resources/icons/sell_icon.png", "currencyName":"KLVN", "tokenName":"TKN1", "balance": 0})
    }

    function initHistoryModel()
    {
        modelExchangeHistory.append({"time":"Jule,11,11:55", "status":"Sell", "price":10550, "token":10.05013112})
        modelExchangeHistory.append({"time":"Jule,11,11:55", "status":"Buy", "price":10550, "token":1.00502423})
        modelExchangeHistory.append({"time":"Jule,11,11:55", "status":"Sell", "price":10550, "token":100.502222})
        modelExchangeHistory.append({"time":"Jule,11,11:55", "status":"Buy", "price":10550, "token":1.00503453})
        modelExchangeHistory.append({"time":"Jule,11,11:55", "status":"Buy", "price":10.23423, "token":1005.0})
        modelExchangeHistory.append({"time":"Jule,11,11:55", "status":"Sell", "price":10550, "token":10.050345})
        modelExchangeHistory.append({"time":"Jule,11,11:55", "status":"Sell", "price":10550, "token":10.05021312})
        modelExchangeHistory.append({"time":"Jule,11,11:55", "status":"Buy", "price":150.12, "token":1.005034543})
        modelExchangeHistory.append({"time":"Jule,11,11:55", "status":"Sell", "price":10550, "token":100.5012321})
    }

}

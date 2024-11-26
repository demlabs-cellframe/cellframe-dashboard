import QtQuick 2.12
import QtQml 2.12

QtObject {

    property var selectedItem:
    {
        "side":"",
        "price":"",
        "tokenBuy":"",
        "tokenSell":""
    }

    function initPairModelFilter()
    {
        pairModelFilter.append({"pair": "All pairs"})

        for(var i = 0; i < dapPairModel.count; i++)
        {
            if(dapPairModel.get(i).network === tokenPairsWorker.tokenNetwork)
            pairModelFilter.append({"pair": dapPairModel.get(i).tokenBuy + "/" + dapPairModel.get(i).tokenSell})
        }
    }

    function changeMainPage(page)
    {
        screenStackView.clear()
        screenStackView.push(page)
    }

    function changeRightPanel(page)
    {
        rightStackView.clear()
        rightStackView.push(page)
    }

    function closedDetails()
    {
        rightFrame.visible = false
        defaultRightPanel.visible = true
        closedDetailsSignal()
        changeRightPanel(emptyRightPanel)
        bufferDetails.clear()
    }

    function initOrdersModels()
    {
        historyModel.clear()
        for(var i = 0; i < orderHistoryModel.count; i++)
            historyModel.append(orderHistoryModel.get(i))
        openModel.clear()
        for(var i = 0; i < openOrdersModel.count; i++)
            openModel.append(openOrdersModel.get(i))

    }

    function openBuySellDialog(data)
    {
        print("openBuySellDialog",
              data.price, data.side, data.tokenBuy, data.tokenSell)
        selectedItem = data

        if(rightFrame.visible){
            rightStackView.pop()
            rightStackView.push(buysellPanel)
        }else{
            defaultRightPanel.visible = false
            rightFrame.visible = true
            rightStackView.push(buysellPanel)
        }


    }

    function openOrdersDetails(screen, data)
    {
        var isEqual = false
        var rightPage
        if(screen === "open"){
            rightPage = detailOpen
            checkingBufferDetails.append({date: data.date,
                                             pair: data.pair,
                                             type: data.type,
                                             side: data.side,
                                             price: data.price,
                                             filled: data.filled,
                                             amount: data.amount,
                                             total: data.total,
                                             triggerCondition: data.triggerCondition,
                                             expiresIn: data.expiresIn})


            if(bufferDetails.count)
            {
                if( bufferDetails.get(0).date === checkingBufferDetails.get(0).date &&
                    bufferDetails.get(0).pair === checkingBufferDetails.get(0).pair &&
                    bufferDetails.get(0).type === checkingBufferDetails.get(0).type &&
                    bufferDetails.get(0).side === checkingBufferDetails.get(0).side &&
                    bufferDetails.get(0).price === checkingBufferDetails.get(0).price &&
                    bufferDetails.get(0).filled === checkingBufferDetails.get(0).filled &&
                    bufferDetails.get(0).amount === checkingBufferDetails.get(0).amount &&
                    bufferDetails.get(0).total === checkingBufferDetails.get(0).total &&
                    bufferDetails.get(0).triggerCondition === checkingBufferDetails.get(0).triggerCondition &&
                    bufferDetails.get(0).expiresIn === checkingBufferDetails.get(0).expiresIn)
                {
                    isEqual = true
                }else{
                    isEqual = false
                }
            }
            else
                bufferDetails.append(checkingBufferDetails.get(0))



        }else{
            rightPage = detailHistory

            checkingBufferDetails.append({date: data.date,
                                             closedDate: data.closedDate,
                                             pair: data.pair,
                                             type: data.type,
                                             side: data.side,
                                             averagePrice: data.averagePrice,
                                             price: data.price,
                                             filled: data.filled,
                                             amount: data.amount,
                                             total: data.total,
                                             triggerCondition: data.triggerCondition,
                                             status: data.status})


            if(bufferDetails.count)
            {
                if( bufferDetails.get(0).date === checkingBufferDetails.get(0).date &&
                    bufferDetails.get(0).closedDate === checkingBufferDetails.get(0).closedDate &&
                    bufferDetails.get(0).pair === checkingBufferDetails.get(0).pair &&
                    bufferDetails.get(0).type === checkingBufferDetails.get(0).type &&
                    bufferDetails.get(0).side === checkingBufferDetails.get(0).side &&
                    bufferDetails.get(0).averagePrice === checkingBufferDetails.get(0).averagePrice &&
                    bufferDetails.get(0).price === checkingBufferDetails.get(0).price &&
                    bufferDetails.get(0).filled === checkingBufferDetails.get(0).filled &&
                    bufferDetails.get(0).amount === checkingBufferDetails.get(0).amount &&
                    bufferDetails.get(0).total === checkingBufferDetails.get(0).total &&
                    bufferDetails.get(0).triggerCondition === checkingBufferDetails.get(0).triggerCondition &&
                    bufferDetails.get(0).status === checkingBufferDetails.get(0).status)
                {
                    isEqual = true
                }else{
                    isEqual = false
                }
            }
            else
                bufferDetails.append(checkingBufferDetails.get(0))

        }

        if(!isEqual)
        {
            bufferDetails.clear()
            bufferDetails.append(checkingBufferDetails.get(0))

            if(rightFrame.visible){
                rightStackView.pop()
                rightStackView.push(rightPage)
            }else{
                defaultRightPanel.visible = false
                rightFrame.visible = true
                rightStackView.push(rightPage)
            }
        }

        checkingBufferDetails.clear()
    }

    function filtrResults()
    {
        if(isInitCompleted)
        {
            openModel.clear()
            historyModel.clear()

            filtrModel(orderHistoryModel, "history")
            filtrModel(openOrdersModel, "open")
        }

    }

    function filtrModel(temporaryModel, type)
    {
//        console.log("step 1", type)
        var today = new Date()
        var date1Day = new Date(new Date().setDate(new Date().getDate()-1))
        var date1Week = new Date(new Date().setDate(new Date().getDate()-7))
        var date1Month = new Date(new Date().setDate(new Date().getDate()-30))
        var date3Month = new Date(new Date().setDate(new Date().getDate()-90))
        var date6Month = new Date(new Date().setDate(new Date().getDate()-180))
        var date1Year = new Date(new Date().setDate(new Date().getDate()-365))

//        console.log("step 2", temporaryModel.count)
        for (var i = 0; i < temporaryModel.count; ++i)
        {
//            console.log("step 3", currentSide, temporaryModel.get(i).side)
            if(currentSide === "Both" || temporaryModel.get(i).side === currentSide)
            {
//                console.log("step 4", currentPair, temporaryModel.get(i).pair)
                if (currentPair === "All pairs" || temporaryModel.get(i).pair === currentPair)
                {
                    var payDate = new Date(Date.parse(temporaryModel.get(i).date))

//                    console.log("step 5", payDate, currentPeriod, today, yesterday,week)
                    if (checkDate(payDate, currentPeriod, today,
                                  date1Day, date1Week, date1Month,
                                  date3Month, date6Month, date1Year))
                    {
//                        console.log("step 6")
                        if(type === "history")
                            historyModel.append(temporaryModel.get(i))
                        else
                            openModel.append(temporaryModel.get(i))
                    }

                }
            }
        }
    }

    function checkDate(date, period, today,
                       date1Day, date1Week, date1Month,
                       date3Month, date6Month, date1Year)
    {
        print("checkDate", period)

        if (period === "All time")
            return true

        if (period === "1 Day" && (date >= date1Day && date <= today))
            return true

        if (period === "1 Week" && (date >= date1Week && date <= today))
            return true

        if (period === "1 Month" && (date >= date1Month && date <= today))
            return true

        if (period === "3 Month" && (date >= date3Month && date <= today))
            return true

        if (period === "6 Month" && (date >= date6Month && date <= today))
            return true

        if (period === "1 Year" && (date >= date1Year && date <= today))
            return true


        return false
    }

    function isSameDay(date1, date2)
    {
        return (date1.getFullYear() === date2.getFullYear()
                && date1.getMonth() === date2.getMonth()
                && date1.getDate() === date2.getDate()) ? true : false
    }

    function getDate(date)
    {
        var parts = date.split(".");
        return new Date(parseInt(parts[2], 10),
                          parseInt(parts[1], 10) - 1,
                          parseInt(parts[0], 10));
    }

    function setStatusCreateButton(total, price)
    {
        if(price === "0.0" || total === "0.0" || total === "" || price === "")
            return false

        return true

        var totalValue = isSell ? mathWorker.divCoins(mathWorker.coinsToBalance(total),
                                                   mathWorker.coinsToBalance(price),false):
                                  total

        var nameToken = isSell ? dexModule.token1 :
                                 dexModule.token2
        var str;

        if(logicStock.currantToken === nameToken)
        {
            str = mathWorker.subCoins(mathWorker.coinsToBalance(logicStock.currantBalance), mathWorker.coinsToBalance(totalValue), false)

            if(str.length < 70)
                return true
            else
                return false
        }
        // else if(logicStock.unselectedTokenNameWallet === nameToken)
        // {
        //     str = mathWorker.subCoins(mathWorker.coinsToBalance(logicStock.unselectedTokenBalanceWallet), mathWorker.coinsToBalance(totalValue), false)

        //     if(str.length < 70)
        //         return true
        //     else
        //         return false
        // }
        else
        {
            return false
        }
    }
}

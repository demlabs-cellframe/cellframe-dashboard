import QtQuick 2.12
import QtQml 2.12

QtObject {

    function initPairModelFilter()
    {
        pairModelFilter.append({"pair": "All pairs"})
        for(var i = 0; i < pairModel.count; i++)
        {
            pairModelFilter.append({"pair": pairModel.get(i).pair})
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
        var yesterday = new Date(new Date().setDate(new Date().getDate()-1))
        var week = new Date(new Date().setDate(new Date().getDate()-7))

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
                    if (checkDate(payDate, currentPeriod, today, yesterday, week))
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

    function checkDate(date, period, today, yesterday, week)
    {
        if (period === "All time")
            return true

        if (period === "Today" && isSameDay(today, date))
            return true

        if (period === "Yesterday" && isSameDay(yesterday, date))
            return true

        if (period === "Last week" && ((date > week && date < today) ||
                 isSameDay(week, date) || isSameDay(today, date)))
            return true

        if (period === "This month" && date.getMonth() === today.getMonth())
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
}

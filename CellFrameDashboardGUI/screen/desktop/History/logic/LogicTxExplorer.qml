import QtQuick 2.12
import QtQml 2.12

QtObject {


    function rcvAllWalletHistory(walletHistory, isLastActions)
    {
        if (walletHistory.length !== lastHistoryLength)
        {
            print("onAllWalletHistoryReceived",
                  "walletHistory.length", walletHistory.length,
                  "lastHistoryLength", lastHistoryLength)

            if (walletHistory.length < lastHistoryLength)
            {
                print("ERROR! walletHistory.length < lastHistoryLength",
                      walletHistory.length, lastHistoryLength)
            }
            else
            {
                lastHistoryLength = walletHistory.length

                temporaryModel.clear()

                for (var q = 0; q < walletHistory.length; ++q)
                {
                    if (temporaryModel.count === 0)
                        temporaryModel.append({"wallet" : walletHistory[q].Wallet,
                                              "network" : walletHistory[q].Network,
                                              "name" : walletHistory[q].Name,
                                              "status" : walletHistory[q].Status,
                                              "amount" : walletHistory[q].AmountWithoutZeros,
                                              "date" : walletHistory[q].Date,
                                              "SecsSinceEpoch" : walletHistory[q].SecsSinceEpoch,
                                              "hash": walletHistory[q].Hash})
                    else
                    {
                        var j = 0;
                        while (temporaryModel.get(j).SecsSinceEpoch > walletHistory[q].SecsSinceEpoch)
                        {
                            ++j;
                            if (j >= temporaryModel.count)
                                break;
                        }
                        temporaryModel.insert(j, {"wallet" : walletHistory[q].Wallet,
                                              "network" : walletHistory[q].Network,
                                              "name" : walletHistory[q].Name,
                                              "status" : walletHistory[q].Status,
                                              "amount" : walletHistory[q].AmountWithoutZeros,
                                              "date" : walletHistory[q].Date,
                                              "SecsSinceEpoch" : walletHistory[q].SecsSinceEpoch,
                                              "hash": walletHistory[q].Hash})
                    }
                    if(isLastActions)
                    {
                        var currDate = new Date(Date.parse(walletHistory[q].Date))

                        if (lastDate === new Date(0))
                        {
                            lastDate = currDate
                            prevDate = currDate
                        }
                        if (lastDate < currDate)
                        {
                            prevDate = lastDate
                            lastDate = currDate
                        }
                    }
                }

                var test = true

                if (previousModel.count !== temporaryModel.count)
                    test = false
                else
                {
                    for (var i = 0; i < previousModel.count; ++i)
                        if (!logicExplorer.compareHistoryElements(temporaryModel.get(i), previousModel.get(i)))
                        {
                            test = false
                            break
                        }
                }

                previousModel.clear()
                for (var k = 0; k < temporaryModel.count; ++k)
                    previousModel.append(temporaryModel.get(k))

                if (!test)
                {
                    if(isLastActions)
                    {
                        print("New model != Previous model")

                        today = new Date()
                        yesterday = new Date(new Date().setDate(new Date().getDate()-1))

                        modelLastActions.clear()

                        for (var m = 0; m < temporaryModel.count; ++m)
                        {
                            var payDate = new Date(Date.parse(temporaryModel.get(m).date))

                            if (isSameDay(lastDate, payDate) || isSameDay(prevDate, payDate))
                                modelLastActions.append(temporaryModel.get(m))
                        }

                        print("modelLastActions.count", modelLastActions.count)

                        print("Reset position")
                        dapLastActionsView.positionViewAtBeginning()
                    }
                    else
                        outNewModel()
                }
            }
        }
    }

    function updateWalletHistory(isLastActions)
    {
        if (logicMainApp.currentIndex >= 0)
        {
            if(isLastActions)
            {
                lastDate = new Date(0)
                prevDate = new Date(0)
            }

            logicMainApp.getAllWalletHistory(logicMainApp.currentIndex)
        }
    }

    function compareHistoryElements(elem1, elem2)
    {
        if (elem1.wallet !== elem2.wallet)
            return false
        if (elem1.network !== elem2.network)
            return false
        if (elem1.name !== elem2.name)
            return false
        if (elem1.status !== elem2.status)
            return false
        if (elem1.amount !== elem2.amount)
            return false
        if (elem1.date !== elem2.date)
            return false
        if (elem1.SecsSinceEpoch !== elem2.SecsSinceEpoch)
            return false

        return true
    }

    function filterResults()
    {
        previousModel.clear()

        outNewModel()
    }

    function outNewModel()
    {
        modelHistory.clear()

        var today = new Date()
        var yesterday = new Date(new Date().setDate(new Date().getDate()-1))
        var week = new Date(new Date().setDate(new Date().getDate()-7))

        var begin
        var end

        if (isCurrentRange)
        {
            var index = currentPeriod.indexOf('-')

            begin = getDate(currentPeriod.slice(0, index))
            end = getDate(currentPeriod.slice(index+1))
        }

        for (var i = 0; i < temporaryModel.count; ++i)
        {
            if (currentString === "" || checkText(temporaryModel.get(i), currentString))
            {
                if (currentStatus === "All statuses" || temporaryModel.get(i).status === currentStatus)
                {
                    var payDate = new Date(Date.parse(temporaryModel.get(i).date))

                    if (isCurrentRange)
                    {
                        if ((payDate > begin && payDate < end) ||
                            isSameDay(payDate, begin) || isSameDay(payDate, end))
                            modelHistory.append(temporaryModel.get(i))
                    }
                    else
                    {
                        if (checkDate(payDate, currentPeriod, today, yesterday, week))
                            modelHistory.append(temporaryModel.get(i))
                    }
                }

            }
        }

//        print("Reset position")
        dapHistoryScreen.dapListViewHistory.positionViewAtBeginning()
    }

    function checkText(item, line)
    {
        if (item.network.includes(line))
            return true

        if (item.name.includes(line))
            return true

        if (item.status.includes(line))
            return true

        if (item.amount.toString().includes(line))
            return true

        return false
    }

    function checkDate(date, period, today, yesterday, week)
    {
        if (period === "all time")
            return true

        if (period === "today" && isSameDay(today, date))
            return true

        if (period === "yesterday" && isSameDay(yesterday, date))
            return true

        if (period === "last week" && ((date > week && date < today) ||
                 isSameDay(week, date) || isSameDay(today, date)))
            return true

        if (period === "this month" && date.getMonth() === today.getMonth())
            return true

        return false
    }

    function isSameDay(date1, date2)
    {
//        console.log(date1.getFullYear(),
//                    date1.getMonth(),
//                    date1.getDate(),

//                    date2.getFullYear(),
//                    date2.getMonth(),
//                    date2.getDate(),

//                    (date1.getFullYear() === date2.getFullYear()
//                    && date1.getMonth() === date2.getMonth()
//                    && date1.getDate() === date2.getDate()))

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

    ////@ Functions for "Today" or "Yesterday" or "Month, Day" or "Month, Day, Year" output
    function getDateString(date)
    {
//        console.log("getDateString", date.toLocaleString(Qt.locale("en_EN"), "MMMM, d, yyyy"))

        if (isSameDay(today, date))
        {
            return qsTr("Today")
        }
        else if (isSameDay(yesterday, date))
        {
            return qsTr("Yesterday")
        }
        else if (!isSameYear(today, date))
        {
            return date.toLocaleString(Qt.locale("en_EN"), "MMMM, d, yyyy")
        }
        else
        {
            return date.toLocaleString(Qt.locale("en_EN"), "MMMM, d") // Does locale should be changed?
        }
    }

    ////@ Checks if dates have same year
    function isSameYear(date1, date2)
    {
        return (date1.getFullYear() === date2.getFullYear()) ? true : false
    }
}
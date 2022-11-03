import QtQuick 2.12
import QtQml 2.12

QtObject {

    property int selectTxIndex: -1

    property var commandResult

    function initDetailsModel()
    {
        detailsModel.clear()
        detailsModel.append(modelHistory.get(selectTxIndex))
    }

    function rcvAllWalletHistory(walletHistory, isLastActions)
    {
        if(walletHistory !== "isEqual")
        {

            console.log("onAllWalletHistoryReceived")
            console.log("jsonDocument.length", walletHistory.length)

            var jsonDocument = JSON.parse(walletHistory)

            if (jsonDocument.length !== lastHistoryLength)
            {
                console.log("onAllWalletHistoryReceived",
                      "jsonDocument.length", jsonDocument.length,
                      "lastHistoryLength", lastHistoryLength)

                if (jsonDocument.length < lastHistoryLength)
                {
                    console.error("ERROR! jsonDocument.length < lastHistoryLength",
                          jsonDocument.length, lastHistoryLength)
                }
                else
                {
                    lastHistoryLength = jsonDocument.length

                    temporaryModel.clear()

                    for (var q = 0; q < jsonDocument.length; ++q)
                    {
                        if (temporaryModel.count === 0)
                            temporaryModel.append(jsonDocument[q])
                        else
                        {

                            var j = 0;
                            while (temporaryModel.get(j).date_to_secs > jsonDocument[q].date_to_secs)
                            {
                                ++j;
                                if (j >= temporaryModel.count)
                                    break;
                            }
                            temporaryModel.insert(j, jsonDocument[q])

                            if(isLastActions)
                            {
                                var currDate = new Date(Date.parse(
                                    temporaryModel.get(j).date))

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
                            console.log("New model != Previous model")

                            today = new Date()
                            yesterday = new Date(new Date().setDate(new Date().getDate()-1))

                            modelLastActions.clear()

                            for (var m = 0; m < temporaryModel.count; ++m)
                            {
                                var payDate = new Date(Date.parse(temporaryModel.get(m).date))

                                if (isSameDay(lastDate, payDate) || isSameDay(prevDate, payDate))
                                    modelLastActions.append(temporaryModel.get(m))
                            }

                            console.log("modelLastActions.count", modelLastActions.count)

                            console.log("Reset position")
                            dapLastActionsView.positionViewAtBeginning()
                        }
                        else
                            outNewModel()
                    }
                }
            }
        }
    }

    function updateWalletHistory(isLastActions, update)
    {
        if (logicMainApp.currentIndex >= 0)
        {
            if(isLastActions)
            {
                lastDate = new Date(0)
                prevDate = new Date(0)
            }

            logicMainApp.getAllWalletHistory(logicMainApp.currentIndex, update)
        }
    }

    function compareHistoryElements(elem1, elem2)
    {
        if (elem1.tx_hash !== elem2.tx_hash)
            return false
        if (elem1.tx_status !== elem2.tx_status)
            return false
        if (elem1.status !== elem2.status)
            return false
        if (elem1.date_to_secs !== elem2.date_to_secs)
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
                var status = temporaryModel.get(i).tx_status === "ACCEPTED" ? temporaryModel.get(i).status : "Declined"

                if (currentStatus === "All statuses" || status === currentStatus)
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
        var fstr = line.toLocaleLowerCase()

        if(!item.network || !item.token || !item.tx_status || !item.status || !item.value || !item.date)
            return false

        if (item.network.toLowerCase().indexOf(fstr) >= 0)
            return true

        if (item.token.toLowerCase().indexOf(fstr) >= 0)
            return true

        var statusStr = item.tx_status === "ACCEPTED" ? item.status : "Declined"
        if (statusStr.toLowerCase().indexOf(fstr) >= 0)
            return true

        if (item.value.toString().toLowerCase().indexOf(fstr) >= 0)
            return true

        return false
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

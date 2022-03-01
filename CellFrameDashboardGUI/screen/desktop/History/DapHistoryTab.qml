import QtQuick 2.4
import "../SettingsWallet.js" as SettingsWallet

DapHistoryTabForm
{
    property string currentString: ""
    property string currentStatus: "All statuses"
    property string currentPeriod: "all time"
    property bool isCurrentRange: false

    property int requestCounter: 0

    ListModel
    {
        id: modelHistory
    }
    ListModel
    {
        id: temporaryModel
    }

    Component.onCompleted:
    {
        if (SettingsWallet.currentIndex >= 0 &&
            requestCounter === 0)
        {
            modelHistory.clear()

            requestCounter = getWalletHistory(SettingsWallet.currentIndex)
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletHistoryReceived:
        {
            if (requestCounter <= 0)
                return

            --requestCounter

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
                                          "hash" : walletHistory[q].Hash})
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
                                          "hash" : walletHistory[q].Hash})
                }
            }

            if (requestCounter <= 0)
            {
                modelHistory.clear()

                for (var i = 0; i < temporaryModel.count; ++i)
                    modelHistory.append(temporaryModel.get(i))
            }

        }
    }

    dapHistoryTopPanel.onCurrentSearchString: {
        console.log("currentSearchString", text)

        currentString = text

        filterResults()
    }

    dapHistoryScreen.dapHistoryRightPanel.onCurrentStatusSelected: {
        console.log("currentStatusSelected", status)

        currentStatus = status

        filterResults()
    }

    dapHistoryScreen.dapHistoryRightPanel.onCurrentPeriodSelected: {
        console.log("currentPeriodSelected", period, isRange)

        currentPeriod = period
        isCurrentRange = isRange

        filterResults()
    }

    function filterResults()
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
        console.log(date1.getFullYear(),
                    date1.getMonth(),
                    date1.getDate(),

                    date2.getFullYear(),
                    date2.getMonth(),
                    date2.getDate(),

                    (date1.getFullYear() === date2.getFullYear()
                    && date1.getMonth() === date2.getMonth()
                    && date1.getDate() === date2.getDate()))

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

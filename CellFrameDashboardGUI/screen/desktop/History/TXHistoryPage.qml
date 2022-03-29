import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/screen/desktop/Wallet/RightPanel"
import "qrc:/screen/controls"

DapPage {

    property string currentString: ""
    property string currentStatus: "All statuses"
    property string currentPeriod: "all time"
    property bool isCurrentRange: false
    readonly property var currentIndex: 3

    property int requestCounter: 0

    property alias dapHistoryTopPanel: historyTopPanel
    property alias dapHistoryScreen: historyScreen

    ListModel
    {
        id: modelHistory
    }

    ListModel
    {
        id: temporaryModel
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

    dapHeader.initialItem: HeaderItem {
        id:historyTopPanel
        onFindHandler: {
            currentString = text
            filterResults()
        }
    }

    dapScreen.initialItem:
        TXHistoryScreen
        {
            id:historyScreen

            dapHistoryRightPanel.onCurrentStatusSelected: {
                console.log("currentStatusSelected", status)
                currentStatus = status
                filterResults()
            }

            dapHistoryRightPanel.onCurrentPeriodSelected: {
                console.log("currentPeriodSelected", period, isRange)

                currentPeriod = period
                isCurrentRange = isRange

                filterResults()
            }
        }

    onRightPanel: false

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
                                              "SecsSinceEpoch" : walletHistory[q].SecsSinceEpoch})
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
                                              "SecsSinceEpoch" : walletHistory[q].SecsSinceEpoch})
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

    Connections
    {
        target: dapMainPage
        onUpdatePage:
        {
            if(index === currentIndex)
            {
                if (globalLogic.currentIndex >= 0 &&
                        requestCounter === 0)
                {
                    temporaryModel.clear()
                    modelHistory.clear()

                    requestCounter = globalLogic.getWalletHistory(globalLogic.currentIndex, _dapModelWallets)
                }
            }
        }
    }
}

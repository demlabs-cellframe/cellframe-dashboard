import QtQuick 2.4

DapHistoryTabForm
{
    property string currentString: ""
    property string currentStatus: "All statuses"
    property string currentPeriod: "all time"
    property bool isCurrentRange: false

    property int lastHistoryLength: 0

    ListModel
    {
        id: modelHistory
    }
    ListModel
    {
        id: temporaryModel
    }

    ListModel
    {
        id: previousModel
    }

    Timer {
        id: updateTimer
        interval: 1000; running: false; repeat: true
        onTriggered:
        {
            updateWalletHisory()
        }
    }

    Component.onCompleted:
    {
        print("DapHistoryTab onCompleted", updateTimer.running)

        updateWalletHisory()

        if (!updateTimer.running)
            updateTimer.start()
    }

    Component.onDestruction:
    {
        print("DapHistoryTab onDestruction", updateTimer.running)

        updateTimer.stop()
    }

    Connections
    {
        target: dapServiceController
        onAllWalletHistoryReceived:
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
                    }

                    var test = true

                    if (previousModel.count !== temporaryModel.count)
                        test = false
                    else
                    {
                        for (var i = 0; i < previousModel.count; ++i)
                            if (!compareHistoryElements(temporaryModel.get(i), previousModel.get(i)))
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
                        print("New model != Previous model")
                        outNewModel()
                    }
                }
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

    function updateWalletHisory()
    {
        print("function updateWalletHisory")

        if (logicMainApp.currentIndex >= 0)
        {
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

        print("Reset position")
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

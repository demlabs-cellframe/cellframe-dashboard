import QtQuick 2.9
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"
import "../../SettingsWallet.js" as SettingsWallet

DapLastActionsRightPanelForm
{
    ////@ Variables to calculate Today, Yesterdat etc.
    property date today: new Date()
    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))

    property date lastDate: new Date(0)
    property date prevDate: new Date(0)

    property alias dapModelLastActions: modelLastActions

    property int requestCounter: 0

    property int lastHistoryLength: 0

    ListModel
    {
        id: modelLastActions
    }

    ListModel
    {
        id: newModelLastActions
    }

    ListModel
    {
        id: temporaryModel
    }

    ListModel
    {
        id: previousModel
    }

    Component
    {
        id: delegateSection
        Rectangle
        {
            height: 30 * pt
            width: parent.width
            color: currTheme.backgroundMainScreen

            property date payDate: new Date(Date.parse(section))

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: currTheme.textColor
                text: getDateString(payDate)
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
            }
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

            for (var i = 0; i < walletHistory.length; ++i)
            {
                if (temporaryModel.count === 0)
                    temporaryModel.append({ "network" : walletHistory[i].Network,
                        "name" : walletHistory[i].Name,
                        "amount" : walletHistory[i].AmountWithoutZeros,
                        "status" : walletHistory[i].Status,
                        "date" : walletHistory[i].Date,
                        "SecsSinceEpoch" : walletHistory[i].SecsSinceEpoch})
                else
                {
                    var j = 0;
                    while (temporaryModel.get(j).SecsSinceEpoch > walletHistory[i].SecsSinceEpoch)
                    {
                        ++j;
                        if (j >= temporaryModel.count)
                            break;
                    }
                    temporaryModel.insert(j, { "network" : walletHistory[i].Network,
                        "name" : walletHistory[i].Name,
                        "amount" : walletHistory[i].AmountWithoutZeros,
                        "status" : walletHistory[i].Status,
                        "date" : walletHistory[i].Date,
                        "SecsSinceEpoch" : walletHistory[i].SecsSinceEpoch})
                }

                var currDate = new Date(Date.parse(walletHistory[i].Date))

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

            if (requestCounter <= 0)
            {
                var test = true

                if (previousModel.count !== temporaryModel.count)
                    test = false
                else
                {
                    for (var k = 0; k < previousModel.count; ++k)
                        if (!compareHistoryElements(temporaryModel.get(k), previousModel.get(k)))
                        {
                            test = false
                            break
                        }
                }

                previousModel.clear()
                for (var l = 0; l < temporaryModel.count; ++l)
                    previousModel.append(temporaryModel.get(l))

                if (!test)
                {
                    print("New model != Previous model")

                    today = new Date()
                    yesterday = new Date(new Date().setDate(new Date().getDate()-1))

/*                    newModelLastActions.clear()

                    for (var m = 0; m < temporaryModel.count; ++m)
                    {
                        var payDate = new Date(Date.parse(temporaryModel.get(m).date))

                        if (isSameDay(lastDate, payDate) || isSameDay(prevDate, payDate))
                            newModelLastActions.append(temporaryModel.get(m))
                    }

                    var p = modelLastActions.count-1;

                    print("newModelLastActions.count", newModelLastActions.count)

                    for (var n = newModelLastActions.count-1; n >= 0; --n)
                    {
                        if (p >= 0 &&
                            compareHistoryElements(newModelLastActions.get(n), modelLastActions.get(p)))
                        {
                            --p;
                            continue;
                        }

                        if (p >= 0 &&
                            !compareHistoryElements(newModelLastActions.get(n), modelLastActions.get(p)))
                        {
                            for (var q = p; q >= 0; --q)
                                modelLastActions.remove(q)
                            p = -1
                        }

                        if (p < 0)
                            modelLastActions.insert(0, newModelLastActions.get(n))
                    }*/

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
            }
        }

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

                    for (var i = 0; i < walletHistory.length; ++i)
                    {
                        if (temporaryModel.count === 0)
                            temporaryModel.append({ "network" : walletHistory[i].Network,
                                "name" : walletHistory[i].Name,
                                "amount" : walletHistory[i].AmountWithoutZeros,
                                "status" : walletHistory[i].Status,
                                "date" : walletHistory[i].Date,
                                "SecsSinceEpoch" : walletHistory[i].SecsSinceEpoch})
                        else
                        {
                            var j = 0;
                            while (temporaryModel.get(j).SecsSinceEpoch > walletHistory[i].SecsSinceEpoch)
                            {
                                ++j;
                                if (j >= temporaryModel.count)
                                    break;
                            }
                            temporaryModel.insert(j, { "network" : walletHistory[i].Network,
                                "name" : walletHistory[i].Name,
                                "amount" : walletHistory[i].AmountWithoutZeros,
                                "status" : walletHistory[i].Status,
                                "date" : walletHistory[i].Date,
                                "SecsSinceEpoch" : walletHistory[i].SecsSinceEpoch})
                        }

                        var currDate = new Date(Date.parse(walletHistory[i].Date))

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

                    var test = true

                    if (previousModel.count !== temporaryModel.count)
                        test = false
                    else
                    {
                        for (var k = 0; k < previousModel.count; ++k)
                            if (!compareHistoryElements(temporaryModel.get(k), previousModel.get(k)))
                            {
                                test = false
                                break
                            }
                    }

                    previousModel.clear()
                    for (var l = 0; l < temporaryModel.count; ++l)
                        previousModel.append(temporaryModel.get(l))

                    if (!test)
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
                }
            }
        }

    }

    Connections
    {
        target: dapMainWindow
        onModelWalletsUpdated:
        {
            lastHistoryLength = 0

            updateWalletHisory()
        }
    }

    Timer {
        id: updateTimer
        interval: 1000; running: false; repeat: true
        onTriggered:
        {
//            print("DapLastActionsRightPanel updateTimer", updateTimer.running)

            updateWalletHisory()
        }
    }

    Component.onCompleted:
    {
        print("DapLastActionsRightPanel onCompleted", updateTimer.running)

        lastHistoryLength = 0

        updateWalletHisory()

        if (!updateTimer.running)
            updateTimer.start()
    }

    Component.onDestruction:
    {
        print("DapLastActionsRightPanel onDestruction", updateTimer.running)

        updateTimer.stop()
    }

    function updateWalletHisory()
    {
        if (SettingsWallet.currentIndex >= 0)
        {
            lastDate = new Date(0)
            prevDate = new Date(0)

            temporaryModel.clear()

            getAllWalletHistory(SettingsWallet.currentIndex)
        }
//        if (SettingsWallet.currentIndex >= 0 &&
//            requestCounter === 0)
//        {
//            lastDate = new Date(0)
//            prevDate = new Date(0)

//            temporaryModel.clear()

//            requestCounter = getWalletHistory(SettingsWallet.currentIndex)
//        }
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

    ////@ Checks if dates are same
    function isSameDay(date1, date2)
    {
        return (isSameYear(date1, date2) && date1.getMonth() === date2.getMonth() && date1.getDate() === date2.getDate()) ? true : false
    }

    ////@ Checks if dates have same year
    function isSameYear(date1, date2)
    {
        return (date1.getFullYear() === date2.getFullYear()) ? true : false
    }
}

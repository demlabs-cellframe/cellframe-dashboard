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

    property int networkCounter: 0

    ListModel
    {
        id: modelLastActions
    }

    ListModel
    {
        id: temporaryModel
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
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
            }
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletHistoryReceived:
        {
            if (networkCounter <= 0)
                return

            console.log("onWalletHistoryReceived")

            --networkCounter

            for (var i = 0; i < walletHistory.length; ++i)
            {
                if (temporaryModel.count === 0)
                    temporaryModel.append({ "network" : walletHistory[i].Network,
                        "name" : walletHistory[i].Name,
                        "amount" : walletHistory[i].Amount,
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
                        "amount" : walletHistory[i].Amount,
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

            if (networkCounter <= 0)
            {
                modelLastActions.clear()

                for (var k = 0; k < temporaryModel.count; ++k)
                {
                    var payDate = new Date(Date.parse(temporaryModel.get(k).date))

                    if (isSameDay(lastDate, payDate) || isSameDay(prevDate, payDate))
                        modelLastActions.append(temporaryModel.get(k))
                }
            }
        }
    }

    Connections
    {
        target: dapMainWindow
        onModelWalletsUpdated:
        {
            getWalletHistory()
        }
    }

    Component.onCompleted:
    {
        today = new Date()
        yesterday = new Date(new Date().setDate(new Date().getDate()-1))

        getWalletHistory()
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


    function getWalletHistory()
    {
        var index = SettingsWallet.currentIndex

        if (index < 0)
            return

        if (networkCounter > 0)
            return

        lastDate = new Date(0)

        modelLastActions.clear()
        networkCounter = 0

        var model = dapModelWallets.get(index).networks
        var name = dapModelWallets.get(index).name

        for (var i = 0; i < model.count; ++i)
        {
            var network = model.get(i).name
            var address = model.get(i).address
            var chain = "zero"
            if (model.get(i).chains.count > 0)
                chain = model.get(i).chains.get(0).name

            print("network", network, "chain", chain)

            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                network, chain, address, name);

            ++networkCounter
        }
    }

}

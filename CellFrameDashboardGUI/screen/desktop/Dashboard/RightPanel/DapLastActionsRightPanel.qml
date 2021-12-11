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

    property alias dapModelLastActions: modelLastActions

    property int networkCounter: 0

    ListModel
    {
        id: modelLastActions
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
                if (modelLastActions.count === 0)
                    modelLastActions.append({ "network" : walletHistory[i].Network,
                        "name" : walletHistory[i].Name,
                        "amount" : walletHistory[i].Amount,
                        "status" : walletHistory[i].Status,
                        "date" : walletHistory[i].Date,
                        "SecsSinceEpoch" : walletHistory[i].SecsSinceEpoch})
                else
                {
                    var j = 0;
                    while (modelLastActions.get(j).SecsSinceEpoch > walletHistory[i].SecsSinceEpoch)
                    {
                        ++j;
                        if (j >= modelLastActions.count)
                            break;
                    }
                    modelLastActions.insert(j, { "network" : walletHistory[i].Network,
                        "name" : walletHistory[i].Name,
                        "amount" : walletHistory[i].Amount,
                        "status" : walletHistory[i].Status,
                        "date" : walletHistory[i].Date,
                        "SecsSinceEpoch" : walletHistory[i].SecsSinceEpoch})
                }

                console.log("modelLastActions",
                            walletHistory[i].Network,
                            walletHistory[i].Name,
                            walletHistory[i].Amount,
                            walletHistory[i].Status,
                            walletHistory[i].Date)
            }
        }
    }

    Connections
    {
        target: dapMainWindow
        onModelWalletsUpdated:
        {
            console.log("onModelWalletsUpdated")

            getWalletHistory()
        }
    }

    Component.onCompleted:
    {
        console.log("onCompleted")
        getWalletHistory()
    }

    ////@ Functions for "Today" or "Yesterday" or "Month, Day" or "Month, Day, Year" output
    function getDateString(date)
    {
        console.log("getDateString", date.toLocaleString(Qt.locale("en_EN"), "MMMM, d, yyyy"))

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

        modelLastActions.clear()
        networkCounter = 0

        var model = dapModelWallets.get(index).networks
        var name = dapModelWallets.get(index).name

        console.log("getWalletHistory", index, model.count)

        for (var i = 0; i < model.count; ++i)
        {
            var network = model.get(i).name
            var address = model.get(i).address
            var chain = "zero"
            if (network === "core-t")
                chain = "zerochain"

            console.log("DapGetWalletHistoryCommand - name:", name,
                "network:", network, "chain:", chain, "address:", address)
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                network, chain, address, name);

            ++networkCounter
        }
    }

}

import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

Rectangle {
    anchors.fill: parent
    color: "#2E3138"
    id:controlLastActions

    property date today: new Date()
    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))

    ListModel
    {
        id: modelLastActions
    }

    Rectangle
    {
        id: viewWallets
        anchors.fill: parent
        color: "#363A42"
        radius: 16 * pt

        // Header
        Item
        {
            id: waalletsHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 38 * pt

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 18 * pt
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Last Actions")
                font.family: "Quicksand"
                font.pixelSize: 14
                font.bold: true
                color: "#ffffff"
            }
        }

        ListView
        {

            id: lastActionsView
            anchors.fill: parent
            clip: true
            model: modelLastActions
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: delegateSection

            delegate: Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5 * pt
                anchors.rightMargin: 5 * pt
    //            width: control.width
                color: currTheme.backgroundElements
                height: 50 * pt

                RowLayout
                {
                    anchors.fill: parent
                    anchors.rightMargin: 20 * pt
                    anchors.leftMargin: 16 * pt

                    ColumnLayout
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: 2 * pt

                        Text
                        {
                            Layout.fillWidth: true
                            text: network
                            color: currTheme.textColor
                            font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                            elide: Text.ElideRight
                        }

                        Text
                        {
                            Layout.fillWidth: true
                            text: status
                            color: currTheme.textColor
                            font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                        }
                    }

                    Text
                    {
                        property string sign: (status === "Sent") ? "- " : "+ "
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignRight
                        verticalAlignment: Qt.AlignVCenter
                        color: currTheme.textColor
                        text: sign + amount + " " + name
                        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                    }
                }

                Rectangle
                {
                    width: parent.width
                    height: 1 * pt
                    color: currTheme.lineSeparatorColor
                    anchors.bottom: parent.bottom
                }
            }
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
    }

    Component.onCompleted: {
        getWalletHistory()
    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: viewWallets
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: viewWallets
        visible: viewWallets.visible
    }
    InnerShadow {
        anchors.fill: viewWallets
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
        color: "#4C4B5A"
        source: topLeftSadow
        visible: viewWallets.visible
    }

    Connections
    {
        target: dapServiceController
        onWalletHistoryReceived:
        {
            {
                for (var q = 0; q < walletHistory.length; ++q)
                {
                    if (modelHistory.count === 0)
                        modelHistory.append({"wallet" : walletHistory[q].Wallet,
                                              "network" : walletHistory[q].Network,
                                              "name" : walletHistory[q].Name,
                                              "status" : walletHistory[q].Status,
                                              "amount" : walletHistory[q].Amount,
                                              "date" : walletHistory[q].Date,
                                              "SecsSinceEpoch" : walletHistory[q].SecsSinceEpoch})
                    else
                    {
                        var j = 0;
                        while (modelHistory.get(j).SecsSinceEpoch > walletHistory[q].SecsSinceEpoch)
                        {
                            ++j;
                            if (j >= modelHistory.count)
                                break;
                        }
                        modelHistory.insert(j, {"wallet" : walletHistory[q].Wallet,
                                              "network" : walletHistory[q].Network,
                                              "name" : walletHistory[q].Name,
                                              "status" : walletHistory[q].Status,
                                              "amount" : walletHistory[q].Amount,
                                              "date" : walletHistory[q].Date,
                                              "SecsSinceEpoch" : walletHistory[q].SecsSinceEpoch})
                    }
                }
            }
        }
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

            console.log("DapGetWalletHistoryCommand")
            console.log("   wallet name:", name)
            console.log("   network:", network)
            console.log("   chain:", chain)
            console.log("   wallet address:", address)
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                network, chain, address, name);
        }
    }
}

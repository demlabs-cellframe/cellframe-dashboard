import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

Rectangle {
    anchors.fill: parent
    color: "transparent"
    id:controlLastActions

    property var dapWallets: []
    property string currWallet

    ListModel{
        id: dapModelWallets
    }

    ListModel
    {
        id: modelLastActions
    }
    ListModel
    {
        id: temporaryModel
    }

    Rectangle
    {
        id: viewLastActions
        anchors.fill: parent
        color: "#363A42"
        radius: 16 * pt

        Rectangle
        {
            anchors.fill: parent
            color: viewLastActions.color
            radius: viewLastActions.radius
            layer.enabled: true
            layer.effect: OpacityMask
            {
                maskSource: Rectangle
                {
                    width: viewLastActions.width
                    height: viewLastActions.height
                    radius: viewLastActions.radius
                }
            }

            // Header
            Item
            {
                id: lastActionsHeader
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
                anchors.top: lastActionsHeader.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                clip: true
                model: modelLastActions
                delegate: DapDelegateLastActions{}

                section.property: "date"
                section.criteria: ViewSection.FullString
                section.delegate: delegateDate

                ScrollBar.vertical: ScrollBar {
                    active: true
                }

                Component
                {
                    id: delegateDate
                    Rectangle
                    {
                        height: 30 * pt
                        width: parent.width
                        color: "#2E3138"

                        Text
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 16 * pt
                            anchors.rightMargin: 16 * pt
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignLeft
                            color: "#ffffff"
                            font.family: "Quicksand"
                            font.pixelSize: 12
                            text: section

                        }
                    }
                }
            }
        }
    }

    Component.onCompleted:
    {
        modelLastActions.clear()
        dapServiceController.requestToService("DapGetWalletsInfoCommand");
    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: viewLastActions
        horizontalOffset: 2
        verticalOffset: 2
        radius: 10
        samples: 10
        cached: true
        color: "#2A2C33"
        source: viewLastActions
        visible: viewLastActions.visible
    }
    InnerShadow {
        anchors.fill: viewLastActions
        horizontalOffset: -1
        verticalOffset: -1
        radius: 0
        samples: 10
        cached: true
        color: "#4C4B5A"
        source: topLeftSadow
        visible: viewLastActions.visible
    }

    Connections
    {
        target: dapServiceController
        onWalletsReceived:
        {
            dapWallets.splice(0,dapWallets.length)
            dapModelWallets.clear()

//            for (var q = 0; q < walletList.length; ++q)
//            {
//                dapWallets.push(walletList[q])
//            }

//            for (var i = 0; i < dapWallets.length; ++i)
//            {
//                dapModelWallets.append({ "name" : dapWallets[i].Name,
//                                      "icon" : dapWallets[i].Icon,
//                                      "networks" : []})
//                for (var n = 0; n < Object.keys(dapWallets[i].Networks).length; ++n)
//                {
//                    dapModelWallets.get(i).networks.append({"name": dapWallets[i].Networks[n],
//                          "address": dapWallets[i].findAddress(dapWallets[i].Networks[n]),
//                          "tokens": []})

//                    for (var t = 0; t < Object.keys(dapWallets[i].Tokens).length; ++t)
//                    {
//                        if(dapWallets[i].Tokens[t].Network === dapWallets[i].Networks[n])
//                        {
//                            dapModelWallets.get(i).networks.get(n).tokens.append(
//                                 {"name": dapWallets[i].Tokens[t].Name,
//                                  "full_balance": dapWallets[i].Tokens[t].FullBalance,
//                                  "balance_without_zeros": dapWallets[i].Tokens[t].BalanceWithoutZeros,
//                                  "datoshi": dapWallets[i].Tokens[t].Datoshi,
//                                  "network": dapWallets[i].Tokens[t].Network})
//                        }
//                    }
//                }
//                getWalletHistory(i)
//            }

            dapWallets.splice(0,dapWallets.length)
            dapModelWallets.clear()

            for (var q = 0; q < walletList.length; ++q)
            {
                dapWallets.push(walletList[q])
            }

            for (var i = 0; i < dapWallets.length; ++i)
            {
                dapModelWallets.append({ "name" : dapWallets[i].Name,
                                      "icon" : dapWallets[i].Icon,
                                      "networks" : []})
                for (var n = 0; n < Object.keys(dapWallets[i].Networks).length; ++n)
                {
                    dapModelWallets.get(i).networks.append({"name": dapWallets[i].Networks[n],
                          "address": dapWallets[i].findAddress(dapWallets[i].Networks[n]),
                          "chains": [],
                          "tokens": []})

                    var chains = dapWallets[i].getChains(dapWallets[i].Networks[n])
                    for (var c = 0; c < chains.length; ++c)
                    {
                        print(chains[c])
                        dapModelWallets.get(i).networks.get(n).chains.append({"name": chains[c]})
                    }
                    for (var t = 0; t < Object.keys(dapWallets[i].Tokens).length; ++t)
                    {
                        if(dapWallets[i].Tokens[t].Network === dapWallets[i].Networks[n])
                        {
                            dapModelWallets.get(i).networks.get(n).tokens.append(
                                 {"name": dapWallets[i].Tokens[t].Name,
                                  "full_balance": dapWallets[i].Tokens[t].FullBalance,
                                  "balance_without_zeros": dapWallets[i].Tokens[t].BalanceWithoutZeros,
                                  "datoshi": dapWallets[i].Tokens[t].Datoshi,
                                  "network": dapWallets[i].Tokens[t].Network})
                        }
                    }
                }
                getWalletHistory(i, dapModelWallets.get(i).name)
            }
        }
        onAllWalletHistoryReceived:
        {
            temporaryModel.clear()

            for (var q = 0; q < walletHistory.length; ++q)
            {
                if (temporaryModel.count === 0)
                    temporaryModel.append({"wallet" : walletHistory[q].Wallet,
                                          "network" : walletHistory[q].Network,
                                          "name" : walletHistory[q].Name,
                                          "status" : walletHistory[q].Status,
//                                          "amount" : walletHistory[q].AmountWithoutZeros,
                                          "amount" : dapMath.balanceToCoins(walletHistory[q].Datoshi),
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
                                          "amount" : dapMath.balanceToCoins(walletHistory[q].Datoshi),
                                          "date" : walletHistory[q].Date,
                                          "SecsSinceEpoch" : walletHistory[q].SecsSinceEpoch,
                                          "hash": walletHistory[q].Hash})
                }
            }

            for (var q = 0; q < temporaryModel.count; ++q)
            {
                modelLastActions.append(temporaryModel.get(q))
            }
        }
    }

    function getWalletHistory(index, name)
    {
        var network_array = ""
        var model = dapModelWallets.get(index).networks

        for (var i = 0; i < model.count; ++i)
        {
            if (model.get(i).chains.count > 0)
            {
                for (var j = 0; j < model.get(i).chains.count; ++j)
                {
                    network_array += model.get(i).name + ":"
                    network_array += model.get(i).chains.get(j).name + ":"
                    network_array += model.get(i).address + "/"
                }
            }
            else
            {
                network_array += model.get(i).name + ":"
                network_array += "zero" + ":"
                network_array += model.get(i).address + "/"
            }
        }

        dapServiceController.requestToService("DapGetAllWalletHistoryCommand", network_array, name);
    }
}

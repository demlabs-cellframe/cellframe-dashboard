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

    ListModel{
        id: dapModelWallets
    }

    ListModel
    {
        id: modelLastActions
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
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: viewLastActions
        visible: viewLastActions.visible
    }
    InnerShadow {
        anchors.fill: viewLastActions
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
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

            for (var q = 0; q < walletList.length; ++q)
            {
                dapWallets.push(walletList[q])
            }

            for (var i = 0; i < dapWallets.length; ++i)
            {
                dapModelWallets.append({ "name" : dapWallets[i].Name,
                                      "balance" : dapWallets[i].Balance,
                                      "icon" : dapWallets[i].Icon,
                                      "address" : dapWallets[i].Address,
                                      "networks" : []})
                for (var n = 0; n < Object.keys(dapWallets[i].Networks).length; ++n)
                {
                    dapModelWallets.get(i).networks.append({"name": dapWallets[i].Networks[n],
                          "address": dapWallets[i].findAddress(dapWallets[i].Networks[n]),
                          "tokens": []})

                    for (var t = 0; t < Object.keys(dapWallets[i].Tokens).length; ++t)
                    {
                        if(dapWallets[i].Tokens[t].Network === dapWallets[i].Networks[n])
                        {
                            dapModelWallets.get(i).networks.get(n).tokens.append(
                                 {"name": dapWallets[i].Tokens[t].Name,
                                  "balance": dapWallets[i].Tokens[t].Balance,
                                  "emission": dapWallets[i].Tokens[t].Emission,
                                  "network": dapWallets[i].Tokens[t].Network})
                        }
                    }
                }
                getWalletHistory(i)
            }
        }
        onWalletHistoryReceived:
        {
            for (var q = 0; q < walletHistory.length; ++q)
            {
                    modelLastActions.append({"wallet" : walletHistory[q].Wallet,
                                          "network" : walletHistory[q].Network,
                                          "name" : walletHistory[q].Name,
                                          "status" : walletHistory[q].Status,
                                          "amount" : walletHistory[q].AmountWithoutZeros,
                                          "date" : walletHistory[q].Date,
                                          "SecsSinceEpoch" : walletHistory[q].SecsSinceEpoch})
            }
        }
    }

    function getWalletHistory(index)
    {
        var model = dapModelWallets.get(index).networks
        var name = dapModelWallets.get(index).name

        for (var i = 0; i < model.count; ++i)
        {
            var network = model.get(i).name
            var address = model.get(i).address
            var chain = "zero"
            if (network === "core-t")
                chain = "zerochain"

            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                network, chain, address, name);
        }
    }
}

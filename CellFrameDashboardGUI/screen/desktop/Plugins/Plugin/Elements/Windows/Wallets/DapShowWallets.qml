import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0

Item {
    anchors.fill: parent
    id:controlWallets

    property var dapWallets: []

    Rectangle
    {
        id: viewWallets
        anchors.fill: parent
        color: "#363A42"
        radius: 16 * pt

        Rectangle
        {
            anchors.fill: parent
            color: viewWallets.color
            radius: viewWallets.radius
            layer.enabled: true
            layer.effect: OpacityMask
            {
                maskSource: Rectangle
                {
                    width: viewWallets.width
                    height: viewWallets.height
                    radius: viewWallets.radius
                }
            }

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
                    text: qsTr("Wallets")
                    font.family: "Quicksand"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#ffffff"
                }
            }

            ListView
            {
                id: listViewWallets
                anchors.top: waalletsHeader.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                clip: true

                model: ListModel{
                    id: dapModelWallets
                }

                delegate: DapWalletsComponent { }
            }
        }
    }

    Component.onCompleted: {
        dapServiceController.requestToService("DapGetWalletsInfoCommand");

    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: viewWallets
        horizontalOffset: 2
        verticalOffset: 2
        radius: 10
        samples: 10
        cached: true
        color: "#2A2C33"
        source: viewWallets
        visible: viewWallets.visible
    }
    InnerShadow {
        anchors.fill: viewWallets
        horizontalOffset: -1
        verticalOffset: -1
        radius: 0
        samples: 10
        cached: true
        color: "#4C4B5A"
        source: topLeftSadow
        visible: viewWallets.visible
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
                                      "icon" : dapWallets[i].Icon,
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
                                  "full_balance": dapWallets[i].Tokens[t].FullBalance,
                                  "balance_without_zeros": dapMath.balanceToCoins(dapWallets[i].Tokens[t].Datoshi),
                                  "datoshi": dapWallets[i].Tokens[t].Datoshi,
                                  "network": dapWallets[i].Tokens[t].Network})
                        }
                    }
                }
            }
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
//import qmlclipboard 1.0

import "Chart"
import "OrderBook"
import "OpenOrders"
import "OrderHistory"

Page {
    id: walletsPage
    title: qsTr("DEX")
    hoverEnabled: true
    background:
    Rectangle
    {
        color: currTheme.mainBackground
    }
//    background: Rectangle
//    {
//        color: "blue"
//    }
//    anchors.fill: parent

    property int currentPage: 0

    property int roundPower: candleChartWorker.commonRoundPower

    ListModel
    {
        id: pageModel
        ListElement {
            name: qsTr("Chart")
        }
        ListElement {
            name: qsTr("Order book")
        }
        ListElement {
            name: qsTr("Open orders")
        }
        ListElement {
            name: qsTr("Order history")
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.topMargin: 20

        spacing: 0

        ListView {
            clip: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            orientation: ListView.Horizontal
            Layout.fillWidth: true
            height: 31
            interactive: true

            model: pageModel
            currentIndex: currentPage

            spacing: 25

            delegate:
            ColumnLayout
            {
                spacing: 0

                Label
                {
                    Layout.minimumHeight: 15
                    Layout.maximumHeight: 15
                    elide: Text.ElideMiddle
                    text: name
                    font: mainFont.dapFont.medium13
                    horizontalAlignment: Text.AlignHCenter
                    color: index === currentPage ?
                               currTheme.lime :
                               currTheme.white
                }

                Rectangle
                {
                    Layout.topMargin: 11
                    Layout.alignment: Qt.AlignCenter
                    Layout.minimumHeight: 3
                    Layout.maximumHeight: 3
                    width: 20
                    radius: 2
                    color: index === currentPage ?
                               currTheme.hilightColorComboBox :
                               currTheme.textColor
                }

                MouseArea
                {
                    width: parent.width
                    height: parent.height

                    onClicked:
                    {
                        if(currentPage !== index)
                        {
                            currentPage = index
                        }
                    }
                }
            }
        }

        SwipeView
        {
             id: swipeView

             Layout.fillWidth: true
             Layout.fillHeight: true
             Layout.topMargin: 16

             orientation: Qt.Horizontal
             currentIndex: currentPage

             interactive: true

//             interactive: currentIndex !== 0

             onCurrentIndexChanged: /* no call*/
             {
                 currentPage = currentIndex
             }

             clip: true

             ChartPage
             {
             }

             OrderBookPage
             {
             }

             OpenOrdersPage
             {
             }

             OrderHistoryPage
             {
             }
        }
    }

    Component.onCompleted:
    {
        console.log("DEXPage onCompleted",
                    "dapPairModel.length", dapPairModel.length)

//        logicMainApp.requestToService("DapGetXchangeTokenPair",
//            "full_info")

        if (dapPairModel.length > 0)
            logicMainApp.requestToService(
                "DapGetXchangeTokenPriceAverage",
                tokenPairsWorker.tokenNetwork,
                tokenPairsWorker.tokenBuy,
                tokenPairsWorker.tokenSell)

        updatePriceTimer.start()

    }

    Component.onDestruction:
    {
//        console.log("DEXPage onDestruction")

        updatePriceTimer.start()
    }


    Connections{
        target: tokenPairsWorker
        onPairModelUpdated:
        {
            console.log("DapStockTab", "onPairModelUpdated")

            console.log(tokenPairsWorker.tokenNetwork,
                        tokenPairsWorker.tokenBuy,
                        tokenPairsWorker.tokenSell)

            console.log("dapPairModel.length",
                        dapPairModel.length,
                        dapPairModel[0].tokenBuy,
                        dapPairModel[0].tokenSell)

            logicMainApp.requestToService(
                "DapGetXchangeTokenPriceAverage",
                tokenPairsWorker.tokenNetwork,
                tokenPairsWorker.tokenBuy,
                tokenPairsWorker.tokenSell)
        }
    }

/*    Connections
    {
        target: dapServiceController

        onRcvXchangeTokenPriceAverage:
        {
//            console.log("DapStockTab TokenPriceAverage", rcvData.rate)

//            console.log(rcvData.token1,
//                  rcvData.token2,
//                  rcvData.network)

//            console.log(tokenPairsWorker.tokenBuy,
//                  tokenPairsWorker.tokenSell,
//                  tokenPairsWorker.tokenNetwork)

            if (!logicMainApp.simulationStock)
            {
                if (rcvData.rate !== "0" &&
                    rcvData.token1 === tokenPairsWorker.tokenBuy &&
                    rcvData.token2 === tokenPairsWorker.tokenSell &&
                    rcvData.network === tokenPairsWorker.tokenNetwork)
                {
                    candleChartWorker.setNewPrice(rcvData.rate)

                    logicMainApp.tokenPrice = candleChartWorker.currentTokenPrice
                    logicMainApp.tokenPriceText = candleChartWorker.currentTokenPriceText

                    tokenPriceChanged()
                }
            }
        }
    }*/


    Timer {
        id: updatePairTimer
        interval: 10000 //10 sec
        running: false
        repeat: true
        onTriggered:
        {
//            console.log("PAIR TIMER TICK")
            // logicMainApp.requestToService("DapGetXchangeTokenPair",
            //     "full_info", "update")
        }
    }

    Timer
    {
        id: updatePriceTimer
        repeat: true
        interval: 1000
        onTriggered:
        {
//            console.log("updatePriceTimer",
//                  "dapPairToken1", tokenPairsWorker.tokenBuy,
//                  "dapPairToken2", tokenPairsWorker.tokenSell,
//                  "dapPairNetwork", tokenPairsWorker.tokenNetwork)

            logicMainApp.requestToService(
                "DapGetXchangeTokenPriceAverage",
                tokenPairsWorker.tokenNetwork,
                tokenPairsWorker.tokenBuy,
                tokenPairsWorker.tokenSell)

//            dapServiceController.requestToService(
//                "DapGetXchangeTokenPriceAverage",
//                tokenPairsWorker.tokenNetwork,
//                tokenPairsWorker.tokenBuy,
//                tokenPairsWorker.tokenSell,
//                "simulation")
        }
    }


}

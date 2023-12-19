import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

//import StockDataWorker 1.0

import "../controls"

DapPage
{
    id: stockTab

    property int roundPower: candleChartWorker.commonRoundPower

    signal fakeWalletChanged() //for top panel

    signal tokenPairChanged()

    signal tokenPriceChanged()

    LogicStock { id: logicStock }

//    ListModel { id: sellBookModel }
//    ListModel { id: buyBookModel }
    ListModel { id: openOrdersModel }
    ListModel { id: orderHistoryModel }

    dapScreen.initialItem: DapStockScreen
    {
        id: stockScreen
    }

    dapHeader.initialItem: DapStockTopPanel
    {
        id: stockTopPanel
    }

    onRightPanel: false

//     Timer {
//         id: updatePairTimer
//         interval: 10000 //10 sec
//         running: false
//         repeat: true
//         onTriggered:
//         {
// //            console.log("PAIR TIMER TICK")
//             logicMainApp.requestToService("DapGetXchangeTokenPair", "full_info", "update")
//         }
//    }


    // Timer {
    //     id: updateOrdersListTimer
    //     interval: 5000
    //     running: false
    //     repeat: true
    //     onTriggered:
    //     {
    //         logicMainApp.requestToService("DapGetXchangeOrdersList")
    //         logicMainApp.requestToService("DapGetWalletsInfoCommand","true");
    //     }
    // }

    Component.onCompleted:
    {
        dexModule.statusProcessing = true
        console.log("DapStockTab Component.onCompleted",
              tokenPairsWorker.tokenNetwork, tokenPairsWorker.tokenBuy, tokenPairsWorker.tokenSell)

        // logicMainApp.requestToService("DapGetXchangeTokenPair", "full_info", "update")

        if (!updatePriceTimer.running)
            updatePriceTimer.start()

        // if (!updatePairTimer.running)
        //     updatePairTimer.start()

        if (!updateOrdersListTimer.running)
            updateOrdersListTimer.start()

        if (logicMainApp.simulationStock)
        {
            var firstPrice = 1234.45678901234
//            var firstPrice = 1234567890.45678901234
//            var firstPrice = 0.00145678901234

            candleChartWorker.resetPriceData(
                        firstPrice, firstPrice.toFixed(10), false)

            var rcvData = ""

            candleChartWorker.setTokenPriceHistory(rcvData)

            orderBookWorker.generateBookModel(firstPrice, 30, 0.04)

            simulationTimer.start()
        }
    }

    Component.onDestruction:
    {
        dexModule.statusProcessing = false
        // updatePairTimer.stop()
        updateOrdersListTimer.stop()
        updatePriceTimer.stop()
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

            // logicMainApp.requestToService(
            //     "DapGetXchangeTokenPriceAverage",
            //     tokenPairsWorker.tokenNetwork,
            //     tokenPairsWorker.tokenBuy,
            //     tokenPairsWorker.tokenSell)

//            dapServiceController.requestToService(
//                "DapGetXchangeTokenPriceAverage",
//                tokenPairsWorker.tokenNetwork,
//                tokenPairsWorker.tokenBuy,
//                tokenPairsWorker.tokenSell,
//                "simulation")
        }
    }

//    Connections{
//        target: dapMainWindow
//        onModelPairsUpdated:
//        {
//            console.log("DapStockTab", "onModelPairsUpdated")

//            dapServiceController.requestToService(
//                "DapGetXchangeTokenPriceAverage",
//                tokenPairsWorker.tokenNetwork,
//                tokenPairsWorker.tokenBuy,
//                tokenPairsWorker.tokenSell)
//        }
//    }

    Connections{
        target: tokenPairsWorker
        function onPairModelUpdated()
        {
            // console.log("DapStockTab", "onPairModelUpdated")

            // console.log(tokenPairsWorker.tokenNetwork,
            //             tokenPairsWorker.tokenBuy,
            //             tokenPairsWorker.tokenSell)

            // console.log("dapPairModel.length",
            //             dapPairModel.length,
            //             dapPairModel[0].tokenBuy,
            //             dapPairModel[0].tokenSell)

            // logicMainApp.requestToService(
            //     "DapGetXchangeTokenPriceAverage",
            //     tokenPairsWorker.tokenNetwork,
            //     tokenPairsWorker.tokenBuy,
            //     tokenPairsWorker.tokenSell)
        }
    }

    Connections
    {
        target: dapServiceController

        function onRcvXchangeTokenPriceAverage(rcvData)
        {
           console.log("DapStockTab TokenPriceAverage", rcvData.rate)

// //            console.log(rcvData.token1,
// //                  rcvData.token2,
// //                  rcvData.network)

// //            console.log(tokenPairsWorker.tokenBuy,
// //                  tokenPairsWorker.tokenSell,
// //                  tokenPairsWorker.tokenNetwork)

//             if (!logicMainApp.simulationStock)
//             {
//                 if (rcvData.rate !== "0" &&
//                     rcvData.token1 === tokenPairsWorker.tokenBuy &&
//                     rcvData.token2 === tokenPairsWorker.tokenSell &&
//                     rcvData.network === tokenPairsWorker.tokenNetwork)
//                 {
//                     candleChartWorker.setNewPrice(rcvData.rate)

//                     candleChartWorker.currentTokenPrice = candleChartWorker.currentTokenPrice
//                     candleChartWorker.currentTokenPriceText = candleChartWorker.currentTokenPriceText

//                     tokenPriceChanged()
//                 }
//             }
        }
    }

    onTokenPairChanged:
    {
        console.log("DapStockTab onTokenPairChanged")

        updateOrdersListTimer.stop()
        // logicMainApp.requestToService("DapGetXchangeOrdersList")
        updateOrdersListTimer.start()

//        console.log(candleChartWorker.currentTokenPrice)

        if (!logicMainApp.simulationStock)
        {
            console.log("stockDataWorker.resetPriceData", candleChartWorker.currentTokenPrice)

            candleChartWorker.resetPriceData(
                candleChartWorker.currentTokenPrice, candleChartWorker.currentTokenPriceText, false)
            orderBookWorker.resetBookModel()

            tokenPriceChanged()
        }

        // logicMainApp.requestToService("DapGetXchangeTokenPriceHistory",
        //     tokenPairsWorker.tokenNetwork, tokenPairsWorker.tokenBuy, tokenPairsWorker.tokenSell)
    }

    Timer
    {
        id: simulationTimer
        repeat: true
        interval: 1000
        onTriggered:
        {
            interval = 500 + Math.round(Math.random()*3000)

            candleChartWorker.generateNewPrice(0.004)

            candleChartWorker.currentTokenPrice = candleChartWorker.currentTokenPrice
            candleChartWorker.currentTokenPriceText = candleChartWorker.currentTokenPriceText

            tokenPriceChanged()
        }
    }

}

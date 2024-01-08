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

    }

    Component.onDestruction:
    {
        dexModule.statusProcessing = false
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

}

import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

//import StockDataWorker 1.0

import "../controls"

DapPage
{
    id: stockTab

    property int roundPower: 6

    signal fakeWalletChanged() //for top panel

    signal tokenPairChanged()

    signal tokenPriceChanged()

    LogicStock { id: logicStock }

//    StockDataWorker
//    {
//        id: dataWorker
//    }

    ListModel { id: sellBookModel }
    ListModel { id: buyBookModel }
    ListModel { id: openOrdersModel }
    ListModel { id: orderHistoryModel }

//    Timer{id: timer}

    dapScreen.initialItem: DapStockScreen
    {
        id: stockScreen
    }

    dapHeader.initialItem: DapStockTopPanel
    {
        id: stockTopPanel
    }

    onRightPanel: false

    Timer {
        id: updatePairTimer
        interval: 1000*60
        running: false
        repeat: true
        onTriggered:
        {
//            console.log("PAIR TIMER TICK")
            dapServiceController.requestToService("DapGetXchangeTokenPair", "full_info")
        }
    }


    Timer {
        id: updateOrdersListTimer
        interval: 5000
        running: false
        repeat: true
        onTriggered:
        {
            dapServiceController.requestToService("DapGetXchangeOrdersList")
        }
    }

    Component.onCompleted:
    {
        print("DapStockTab Component.onCompleted")
        dapServiceController.requestToService("DapGetXchangeTokenPair", "full_info")
        dapServiceController.requestToService("DapGetXchangeOrdersList")

//        logicStock.initPairModel()
//        logicStock.initBalance()
//        stockDataWorker.generateBookModel(0.245978, 18)
//        logicStock.initBookModels()
//        logicStock.initOrderLists()
//        generateTimer.start()
        if (!updatePriceTimer.running)
            updatePriceTimer.start()

        if (!updatePairTimer.running)
            updatePairTimer.start()

        if (!updateOrdersListTimer.running)
            updateOrdersListTimer.start()
    }

    Component.onDestruction:
    {
        updatePairTimer.stop()
        updateOrdersListTimer.stop()
        updatePriceTimer.stop()
    }

    Timer
    {
        id: generateTimer
        repeat: true
        interval: 1000
        onTriggered:
        {
            interval = 100 + Math.round(Math.random()*200)

//            logicStock.generateBookState()
//            stockDataWorker.generateNewBookState()
        }
    }

    Timer
    {
        id: updatePriceTimer
        repeat: true
        interval: 1000
        onTriggered:
        {
//            print("updatePriceTimer",
//                  "dapPairToken1", logicMainApp.token1Name,
//                  "dapPairToken2", logicMainApp.token2Name,
//                  "dapPairNetwork", logicMainApp.tokenNetwork)

            dapServiceController.requestToService(
                "DapGetXchangeTokenPriceAverage",
                logicMainApp.tokenNetwork,
                logicMainApp.token1Name,
                logicMainApp.token2Name)
//            dapServiceController.requestToService(
//                "DapGetXchangeTokenPriceAverage",
//                logicMainApp.tokenNetwork,
//                logicMainApp.token1Name,
//                logicMainApp.token2Name,
//                "simulation")
        }
    }

    Connections{
        target: dapMainWindow
        onModelPairsUpdated:
        {
//            print("DapStockTab", "onModelPairsUpdated")

        }
    }

    Connections
    {
        target: dapServiceController

        onRcvXchangeTokenPriceAverage:
        {
            print("DapStockTab TokenPriceAverage", rcvData.rate)

//            print(rcvData.token1,
//                  rcvData.token2,
//                  rcvData.network)

//            print(logicMainApp.token1Name,
//                  logicMainApp.token2Name,
//                  logicMainApp.tokenNetwork)

            if (rcvData.rate !== "0" &&
                rcvData.token1 === logicMainApp.token1Name &&
                rcvData.token2 === logicMainApp.token2Name &&
                rcvData.network === logicMainApp.tokenNetwork)
            {
                stockDataWorker.setNewPrice(rcvData.rate)

                logicMainApp.tokenPrice = stockDataWorker.currentTokenPrice

                tokenPriceChanged()
            }
        }
    }

    onTokenPairChanged:
    {
        print("DapStockTab onTokenPairChanged")

        updateOrdersListTimer.stop()
        dapServiceController.requestToService("DapGetXchangeOrdersList")
        updateOrdersListTimer.start()

        console.log(logicMainApp.tokenPrice)

        stockDataWorker.resetPriceData(logicMainApp.tokenPrice, false)
        stockDataWorker.resetBookModel()

        tokenPriceChanged()
    }

}

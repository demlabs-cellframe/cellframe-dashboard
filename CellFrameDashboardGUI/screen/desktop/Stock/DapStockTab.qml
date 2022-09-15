import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

//import StockDataWorker 1.0

import "../controls"

DapPage
{
    id: stockTab

    property int roundPower: stockDataWorker.commonRoundPower

    signal fakeWalletChanged() //for top panel

    signal tokenPairChanged()

    signal tokenPriceChanged()

    LogicStock { id: logicStock }

    ListModel { id: sellBookModel }
    ListModel { id: buyBookModel }
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

    Timer {
        id: updatePairTimer
        interval: 10000 //10 sec
        running: false
        repeat: true
        onTriggered:
        {
//            console.log("PAIR TIMER TICK")
            dapServiceController.requestToService("DapGetXchangeTokenPair", "full_info", "update")
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
            dapServiceController.requestToService("DapGetWalletsInfoCommand");
        }
    }

    Component.onCompleted:
    {
        print("DapStockTab Component.onCompleted",
              logicMainApp.tokenNetwork, logicMainApp.token1Name, logicMainApp.token2Name)

        if (!updatePriceTimer.running)
            updatePriceTimer.start()

        if (!updatePairTimer.running)
            updatePairTimer.start()

        if (!updateOrdersListTimer.running)
            updateOrdersListTimer.start()

        if (logicMainApp.simulationStock)
        {
            var firstPrice = 1234.45678901234
//            var firstPrice = 1234567890.45678901234
//            var firstPrice = 0.00145678901234

            stockDataWorker.resetPriceData(
                        firstPrice, firstPrice.toFixed(10), false)

            var rcvData = ""

            stockDataWorker.setTokenPriceHistory(rcvData)

            stockDataWorker.generateBookModel(firstPrice, 30, 0.04)

            simulationTimer.start()

/*            stockDataWorker.setNewPrice("123.456789")

            logicMainApp.tokenPrice = stockDataWorker.currentTokenPrice

            tokenPriceChanged()

            simulationTimer.start()*/
        }
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
            print("DapStockTab", "onModelPairsUpdated")

            dapServiceController.requestToService(
                "DapGetXchangeTokenPriceAverage",
                logicMainApp.tokenNetwork,
                logicMainApp.token1Name,
                logicMainApp.token2Name)
        }
    }

    Connections
    {
        target: dapServiceController

        onRcvXchangeTokenPriceAverage:
        {
//            print("DapStockTab TokenPriceAverage", rcvData.rate)

//            print(rcvData.token1,
//                  rcvData.token2,
//                  rcvData.network)

//            print(logicMainApp.token1Name,
//                  logicMainApp.token2Name,
//                  logicMainApp.tokenNetwork)

            if (!logicMainApp.simulationStock)
            {
                if (rcvData.rate !== "0" &&
                    rcvData.token1 === logicMainApp.token1Name &&
                    rcvData.token2 === logicMainApp.token2Name &&
                    rcvData.network === logicMainApp.tokenNetwork)
                {
                    stockDataWorker.setNewPrice(rcvData.rate)

                    logicMainApp.tokenPrice = stockDataWorker.currentTokenPrice
                    logicMainApp.tokenPriceText = stockDataWorker.currentTokenPriceText

                    tokenPriceChanged()
                }
            }
        }
    }

    onTokenPairChanged:
    {
        print("DapStockTab onTokenPairChanged")

        dapServiceController.requestToService("DapGetXchangeTokenPriceHistory",
            logicMainApp.tokenNetwork, logicMainApp.token1Name, logicMainApp.token2Name)

        updateOrdersListTimer.stop()
        dapServiceController.requestToService("DapGetXchangeOrdersList")
        updateOrdersListTimer.start()

//        console.log(logicMainApp.tokenPrice)

        if (!logicMainApp.simulationStock)
        {
            stockDataWorker.resetPriceData(
                logicMainApp.tokenPrice, logicMainApp.tokenPriceText, false)
            stockDataWorker.resetBookModel()

            tokenPriceChanged()
        }
    }

    Timer
    {
        id: simulationTimer
        repeat: true
        interval: 1000
        onTriggered:
        {
            interval = 500 + Math.round(Math.random()*3000)

            stockDataWorker.generateNewPrice(0.004)

            logicMainApp.tokenPrice = stockDataWorker.currentTokenPrice
            logicMainApp.tokenPriceText = stockDataWorker.currentTokenPriceText

            tokenPriceChanged()
        }
    }

}

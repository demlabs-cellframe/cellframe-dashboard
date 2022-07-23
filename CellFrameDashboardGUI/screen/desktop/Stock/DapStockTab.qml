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

    signal tokenPriceChanged(var price)

    LogicStock { id: logicStock }

//    StockDataWorker
//    {
//        id: dataWorker
//    }

    ListModel { id: sellBookModel }
    ListModel { id: buyBookModel }
    ListModel { id: openOrdersModel }
    ListModel { id: orderHistoryModel }

    Timer{id: timer}

    Component.onCompleted:
    {
        print("DapStockTab onCompleted",
              "dapPairIndex", dapPairIndex,
              "dapPairModel.count", dapPairModel.count)

//        dapServiceController.requestToService("DapGetXchangeTokenPair", "subzero", "full_info")

//        logicStock.initPairModel()
        logicStock.initBalance()
//        stockDataWorker.generateBookModel(0.245978, 18)
//        logicStock.initBookModels()
        logicStock.initOrderLists()
//        generateTimer.start()
        updatePriceTimer.start()
    }

//    Connections
//    {
//        target: dapServiceController

//        onRcvXchangeTokenPair:
//        {
////            print("DapStockTab onRcvXchangeTokenPair", rcvData)
//            logicStock.readPairModel(rcvData)

//            tokenPairChanged()
//        }
//    }


    dapScreen.initialItem: DapStockScreen
    {
        id: stockScreen
    }

    dapHeader.initialItem: DapStockTopPanel
    {
        id: stockTopPanel
    }

    onRightPanel: false

    Timer
    {
        id: generateTimer
        repeat: true
        interval: 1000
        onTriggered:
        {
            interval = 100 + Math.round(Math.random()*200)

//            logicStock.generateBookState()
//            stockDataWorker.generateNewOrderState()
        }
    }

    Timer
    {
        id: updatePriceTimer
        repeat: true
        interval: 1000
        onTriggered:
        {
            print("updatePriceTimer",
                  "dapPairIndex", dapPairIndex,
                  "dapPairModel.count", dapPairModel.count)

            if (dapPairModel.count > 0 &&
                dapPairIndex >= 0 && dapPairIndex < dapPairModel.count)
            {
                var pair = dapPairModel.get(dapPairIndex)
                print("pair", pair.token1, pair.token2, pair.network)

//                dapServiceController.requestToService(
//                    "DapGetXchangeTokenPriceAverage",
//                    pair.network, pair.token1, pair.token2)
                dapServiceController.requestToService(
                    "DapGetXchangeTokenPriceAverage",
                    pair.network, pair.token1, pair.token2, "simulation")
            }
        }
    }

    Connections{
        target: dapMainWindow
        onModelPairsUpdated:
        {
            print("DapStockTab", "onModelPairsUpdated")

        }
    }

    Connections
    {
        target: dapServiceController

        onRcvXchangeTokenPriceAverage:
        {
            print("DapStockTab TokenPriceAverage", rcvData.rate)

            if (rcvData.rate !== "0")
                tokenPriceChanged(rcvData.rate)
        }
    }

}

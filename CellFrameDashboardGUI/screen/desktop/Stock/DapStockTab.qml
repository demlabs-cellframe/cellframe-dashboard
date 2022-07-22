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
//        dapServiceController.requestToService("DapGetXchangeTokenPair", "subzero", "full_info")

//        logicStock.initPairModel()
        logicStock.initBalance()
        stockDataWorker.generateBookModel(0.245978, 18)
//        logicStock.initBookModels()
        logicStock.initOrderLists()
        generateTimer.start()
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
            stockDataWorker.generateNewOrderState()
        }
    }
}

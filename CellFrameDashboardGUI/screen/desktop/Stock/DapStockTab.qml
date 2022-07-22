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
        interval: logicMainApp.autoUpdateInterval; running: false; repeat: true
        onTriggered:
        {
            console.log("PAIR TIMER TICK")
            dapServiceController.requestToService("DapGetXchangeTokenPair", "full_info")
        }
    }
    Component.onCompleted:
    {
//        logicStock.initPairModel()
//        logicStock.initBalance()
        stockDataWorker.generateBookModel(0.245978, 18)
//        logicStock.initBookModels()
        logicStock.initOrderLists()
        generateTimer.start()

        if (!updatePairTimer.running)
            updatePairTimer.start()
    }

    Component.onDestruction:
    {
        updatePairTimer.stop()
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
            stockDataWorker.generateNewOrderState()
        }
    }
}

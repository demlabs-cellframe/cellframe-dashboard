import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import StockDataWorker 1.0

import "../controls"

DapPage
{
    id: stockTab

    property int roundPower: 6

    signal fakeWalletChanged() //for top panel

    LogicStock { id: logicStock }

    StockDataWorker
    {
        id: dataWorker
    }

    ListModel { id: sellBookModel }
    ListModel { id: buyBookModel }
    ListModel { id: openOrdersModel }
    ListModel { id: orderHistoryModel }
    ListModel { id: pairModel }

    Timer{id: timer}

    Component.onCompleted:
    {
//        logicStock.initPairModel()
        logicStock.initBalance()
        logicStock.initBookModels()
        logicStock.initOrderLists()
        generateTimer.start()
    }

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

            logicStock.generateBookState()
        }
    }
}

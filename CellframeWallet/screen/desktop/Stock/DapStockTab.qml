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
        updateOrdersListTimer.start()

//        console.log(candleChartWorker.currentTokenPrice)

        if (!logicMainApp.simulationStock)
        {
            console.log("stockDataWorker.resetPriceData", candleChartWorker.currentTokenPrice)

            // candleChartWorker.resetPriceData(
            //     candleChartWorker.currentTokenPrice, candleChartWorker.currentTokenPriceText, false)
            orderBookWorker.resetBookModel()

            tokenPriceChanged()
        }

    }

}

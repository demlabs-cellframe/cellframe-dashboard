import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "Parts"
import "logic"

Page
{
    ListModel{ id: rowDataModel }

    ListModel{ id: candleModel }

    ListModel{ id: conversionList }

    ListModel{ id: timeModel }

    ListModel{ id: modelExchangeHistory }

    LogicExchange { id: logicExchange }

    Component.onCompleted:
    {
//        logicExchange.initCandleStickModel()
        logicExchange.initConversonModel()
        logicExchange.initTimeModel()
//        logicExchange.initOrdersModel()
        logicExchange.initHistoryModel()

        logicExchange.generateData(rowDataModel, 10000)

        logicExchange.getCandleModel(rowDataModel, candleModel, 20)
    }

    background: Rectangle
    {
        color: currTheme.backgroundMainScreen
    }

    OrderPanelDelegate
    {
        id: delegateOrderPanel
    }

    DapRectangleLitAndShaded
    {
        id: mainFrameDashboard
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            ColumnLayout
            {
                anchors.fill: parent
                spacing: 0

                ///Top panel in tab Exchange
                ExchangeTopPanel
                {
                    id: topPanelExchange
                    Layout.fillWidth: true
                }

                CandleChart
                {
                    id: candleChart
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 10 * pt
                }

                ///Dividing horizontal line
                Rectangle
                {
                    id: horizontalLine
                    Layout.fillWidth: true
                    height: 1 * pt
                    color: currTheme.lineSeparatorColor
                }

                ///Orders panel
                RowLayout
                {
                    id: exchangeBottomPanel
                    Layout.maximumHeight: 300 * pt
                    spacing: 0

                    OrderPanelDelegate
                    {
                        id: orderBuy
                        Layout.fillHeight: true
                        Layout.maximumWidth: 260 * pt
                        Layout.margins: 10 * pt
                        Layout.leftMargin: 20 * pt

                        titleOrder: "Buy"
                        imagePath: "qrc:/resources/icons/buy_icon.png"
                        currencyName: "KLVN"
                        tokenName: "TKN1"
                        balance: "0.123"
                    }

                    OrderPanelDelegate
                    {
                        id: orderSell
                        Layout.fillHeight: true
                        Layout.maximumWidth: 260 * pt
                        Layout.margins: 10 * pt
                        Layout.leftMargin: 20 * pt

                        titleOrder: "Sell"
                        imagePath: "qrc:/resources/icons/sell_icon.png"
                        currencyName: "KLVN"
                        tokenName: "TKN1"
                        balance: "0.123"
                    }

                    ///Dividing vertical line
                    Rectangle
                    {
                        id: verticalLine
                        Layout.fillHeight: true
                        width: 1 * pt
                        color: currTheme.lineSeparatorColor
                    }

                    ExchangeHistoryWidget
                    {
                        id: historyWidget
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 10 * pt

                    }
                }
            }
    }

}


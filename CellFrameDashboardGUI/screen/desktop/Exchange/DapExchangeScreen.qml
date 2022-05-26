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

    ListModel{ id: orderModel }

    ListModel{ id: modelExchangeHistory }

    LogicExchange { id: logicExchange }

    Component.onCompleted:
    {
//        logicExchange.initCandleStickModel()
        logicExchange.initConversonModel()
        logicExchange.initTimeModel()
        logicExchange.initOrdersModel()
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
//        anchors.topMargin: 24 * pt
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            Item
            {
                anchors.fill: parent

                ///Top panel in tab Exchange
                ExchangeTopPanel
                {
                    id: topPanelExchange
                }

                CandleChart
                {
                    id: candleChart

                    anchors.top: topPanelExchange.bottom
                    anchors.left: parent.left
                    anchors.right:parent.right
                    anchors.leftMargin: 24 * pt
                    anchors.rightMargin: 24 * pt
                    anchors.topMargin: 16 * pt
                    height: 282 * pt
                }

                ///Dividing horizontal line
                Rectangle
                {
                    id:horizontalLine
                    anchors.top: candleChart.bottom
                    anchors.topMargin: 24 * pt
                    height: 1*pt
                    width: parent.width
                    color: currTheme.lineSeparatorColor
                }

                ///Orders panel
                Item
                {
                    id:exchangeBottomPanel
                    anchors.top: horizontalLine.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 24 * pt
                    anchors.rightMargin: 24 * pt

                    ///List of orders
                    ListView
                    {
                        id: orderListView
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        orientation: ListView.Horizontal
                        interactive: false
                        model: orderModel
                        delegate: delegateOrderPanel
                        width: childrenRect.width
                    }

                    ///Dividing vertical line
                    Rectangle
                    {
                        id:verticalLine
                        anchors.left: orderListView.right
                        height: parent.height
                        width: 1 * pt
                        color: currTheme.lineSeparatorColor
                    }

                    ExchangeHistoryWidget
                    {
                        width:430 * pt
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: verticalLine.right
                        anchors.right: parent.right
                        anchors.leftMargin: 20 * pt

                    }
                }
            }
    }

}


import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "Chart"
import "OrderBook"
import "CreateOrder"

Item
{
    signal goToRightHome()
    signal goToDoneCreate()

    onGoToRightHome:
    {
        changeRightPage("OrderBook/OrderBook.qml")
    }
    onGoToDoneCreate:
    {
        changeRightPage("CreateOrder/OrderCreateDone.qml")
    }

    Component.onCompleted:
    {
//        logicStock.initPairModel()
        changeRightPage("OrderBook/OrderBook.qml")
//        changeRightPage("CreateOrder/OrderCreateDone.qml")
    }

    RowLayout
    {
        anchors.fill: parent
        spacing: 20

        ColumnLayout
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20

            DapRectangleLitAndShaded
            {
                id: mainFrame
                Layout.fillWidth: true
                Layout.fillHeight: true

                color: currTheme.backgroundElements
                radius: currTheme.radiusRectangle
                shadowColor: currTheme.shadowColor
                lightColor: currTheme.reflectionLight

                contentData:
                    ChartPanel
                    {
                        anchors.fill: parent
                    }
            }

            RowLayout
            {
                Layout.fillWidth: true
                spacing: 20

                DapButton
                {
                    enabled: (logicStock.selectedTokenBalanceWallet > 0 || logicStock.unselectedTokenBalanceWallet > 0) ? true : false
                    id: createOrderButton
                    Layout.fillWidth: true
                    implicitHeight: 36
                    textButton: qsTr("Create order")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14
                    onClicked:
                    {
                        changeRightPage("CreateOrder/OrderCreate.qml")
                    }
                }

                DapButton
                {
                    enabled: false
                    Layout.fillWidth: true
                    implicitHeight: 36
                    textButton: qsTr("My orders")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14
                    onClicked:
                    {
                        stockTopPanel.setBackToStockVisible(true)

                        stockScreen.changeMainPage(
                                    "parts/MyOrders/MyOrdersTab.qml")
//                        changeRightPage("CreateOrder.qml")

                    }
                }
            }

        }

        DapRectangleLitAndShaded
        {
            id: rightFrame
            Layout.minimumWidth: 350
            Layout.fillHeight: true

            color: currTheme.backgroundElements
            radius: currTheme.radiusRectangle
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData:
                StackView {
                    id: rightStackView
                    anchors.fill: parent

                    clip: true
                }

//                OrderBook
//                {
//                    anchors.fill: parent
//                }
        }

    }

    function changeRightPage(page)
    {
        rightStackView.clear()
        rightStackView.push(page)
    }
}


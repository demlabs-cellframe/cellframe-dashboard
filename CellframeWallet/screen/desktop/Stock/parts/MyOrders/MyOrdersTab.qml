import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "RightPanels"
import "logic"

RowLayout
{
    id: myOrdersTab

    property string allOrders: "../AllOrders.qml"
    property string myOrders: "../MyOrders.qml"
    property string ordersHistory: "../OrdersHistory.qml"
    property string buysellPanel: "../RightPanels/BuySellPanel.qml"
    property string detailOpen: "../RightPanels/DetailsOpen.qml"
    property string detailHistory: "../RightPanels/DetailsHistory.qml"
    property string orderDone: "../../CreateOrder/OrderCreateDone.qml"
    property string orderExchangeDone: "../../CreateOrder/OrderExchangeDone.qml"

    property string currentPair: "All pairs"
    property string currentSide: "Both"
    property string currentPeriod: "All time"
    property bool isInitCompleted: false

    signal setCurrentMainScreen(var screen)
//    signal setCurrentSide(var side)
    signal setFilterSide(var side)
    signal setFilterPair(var pair)
    signal setFilterPeriod(var period)
    signal closedDetailsSignal()
    signal initCompleted()

    signal goToRightHome()

    onGoToRightHome:
    {
        logic.closedDetails()
    }

    ListModel{id: bufferDetails}
    ListModel{id: checkingBufferDetails}
    ListModel{id: pairModelFilter}

    ListModel
    {
        id: allOrdersModel
    }
    ListModel
    {
        id: myOrdersModel
    }
    ListModel
    {
        id: historyModel
    }
    ListModel
    {
        id: openModel
    }

    Item{id: emptyRightPanel}

    LogicMyOrders{id: logic}

    onSetCurrentMainScreen:
        logic.changeMainPage(screen)

    Component.onCompleted: {
        logic.initOrdersModels()
        logic.initPairModelFilter()
//        logic.changeMainPage(openOrders)
        logic.changeRightPanel(emptyRightPanel)
        initCompleted()
        isInitCompleted = true
    }

    Connections
    {
        target: dapServiceController

        function onRcvXchangeOrderPurchase(rcvData)
        {
            var jsonDoc = JSON.parse(rcvData)
            logicStock.resultCreate = jsonDoc.result
            logic.changeRightPanel(orderDone)
        }

        function onRcvXchangeRemove(rcvData)
        {
            var jsonDoc = JSON.parse(rcvData)
            var resultCreate = jsonDoc.result
            if(resultCreate.success)
            {
                var msg = rcvData.toQueue ? qsTr("Placed to queue") : qsTr("Order removed")
                dapMainWindow.infoItem.showInfo(
                            180,0,
                            dapMainWindow.width*0.5,
                            8,
                            msg,
                            "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
            }
            else
            {
                dapMainWindow.infoItem.showInfo(
                            210,0,
                            dapMainWindow.width*0.5,
                            8,
                            qsTr("Error order remove"),
                            "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")
            }
        }
        // function onRcvXchangeTxList(rcvData)
        // {
        //     console.log("onRcvXchangeTxList")
        //     console.log(rcvData)

        //     var jsonDocument = JSON.parse(rcvData)
        //     allOrdersModel.clear()
        //     allOrdersModel.append(jsonDocument)
        // }
    }

    onSetFilterPair: {
        currentPair = pair
        logic.filtrResults()
    }

    onSetFilterSide: {
        currentSide = side
        logic.filtrResults()
    }

    onSetFilterPeriod: {
        currentPeriod = period
        logic.filtrResults()
    }

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

            color: currTheme.secondaryBackground
            radius: currTheme.frameRadius
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData:
                StackView {
                    id: screenStackView
                    anchors.fill: parent
                    clip: true
                }

        }
    }

    DefaultRightPanel
    {
        id: defaultRightPanel
        Layout.minimumWidth: !dexModule.isRegularTypePanel ? 350 : 270
        Layout.fillHeight: true
    }

    DapRectangleLitAndShaded
    {
        id: rightFrame
        visible: false
        Layout.minimumWidth: 350
        Layout.fillHeight: true

        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            StackView {
                id: rightStackView
                anchors.fill: parent
                clip: true

                pushExit: Transition {
                    id: pushExit
                    PropertyAction { property: "x"; value: pushExit.ViewTransition.item.pos }
                }
                popEnter: Transition {
                    id: popEnter
                    PropertyAction { property: "x"; value: popEnter.ViewTransition.item.pos }
                }

                pushEnter: Transition {
                    PropertyAnimation {
                        property: "x"
                        easing.type: Easing.Linear
                        from: 350
                        to: 0
                        duration: 350
                    }
                }
                popExit: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: 0
                        to: 350
                        duration: 350
                    }
                }
            }
    }
}

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
    property alias stockHome: stockHome

    id: stockHome
    signal goToRightHome()
    signal goToDoneCreate()
    signal goToDoneExchange()
    signal goToTokensList()
    signal regularPairSwap()

    property string panelPath: ""
    property string tokensListPath: "CreateOrderLight/TokensListRightPanel.qml"


    Connections
    {
        target: dexModule

        function onTypePanelChanged()
        {
            updateDefaultPanel()
            changeRightPage(panelPath)
        }

    }

    function updateDefaultPanel()
    {
        if(dexModule.typePanel === "regular")
        {
            panelPath = "CreateOrderLight/CreateOrderLight.qml"
        }
        else if(dexModule.typePanel === "advanced")
        {
            panelPath = "OrderBook/OrderBook.qml"
        }
    }

    Connections
    {
        target: dapServiceController

        function onRcvXchangeCreate(rcvData)
        {
            var jsonDoc = JSON.parse(rcvData)
            logicStock.resultCreate = jsonDoc.result
            goToDoneCreate()
        }

        function onRcvXchangeOrderPurchase(rcvData)
        {
            logicStock.resultCreate = rcvData
            goToDoneExchange()
        }
    }

    onGoToRightHome:
    {
        changeRightPage(panelPath)
    }
    onGoToDoneCreate:
    {
        changeRightPage("CreateOrder/OrderCreateDone.qml")
    }

    onGoToDoneExchange:
    {
        changeRightPage("CreateOrder/OrderExchangeDone.qml")
    }

    onGoToTokensList:
    {
        changeRightPage(tokensListPath)
    }

    Component.onCompleted:
    {
        updateDefaultPanel()
//        logicStock.initPairModel()
        changeRightPage(panelPath)
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

                color: currTheme.secondaryBackground
                radius: currTheme.frameRadius
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
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                DapButton
                {
                    enabled: !modulesController.isNodeWorking ? false : dexModule.balance ? true : false
                    id: createOrderButton
                    Layout.fillWidth: visible
                    implicitHeight: 36
                    textButton: qsTr("Create order")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14
                    visible: !dexModule.isRegularTypePanel
                    onClicked:
                    {
                        changeRightPage("CreateOrder/OrderCreate.qml")
                    }

                    DapCustomToolTip{
                        contentText: qsTr("Create order")
                    }
                }

                DapButton
                {
                    Layout.fillWidth: createOrderButton.visible
                    Layout.preferredWidth: createOrderButton.visible ? -1 : 331
                    implicitHeight: 36
                    textButton: !dexModule.isRegularTypePanel ? qsTr("Orders") : qsTr("My orders")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14
                    enabled: modulesController.isNodeWorking
                    onClicked:
                    {
                        stockTopPanel.setBackToStockVisible(true)

                        stockScreen.changeMainPage(
                                    "parts/MyOrders/MyOrdersTab.qml")
//                        changeRightPage("CreateOrder.qml")

                    }

                    DapCustomToolTip{
                        contentText: qsTr("My orders")
                    }
                }
            }
        }

        DapRectangleLitAndShaded
        {
            id: rightFrame
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

    function changeRightPage(page)
    {
        rightStackView.pop()
        rightStackView.push(page)
    }
}


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

    property string defaultModeType: "regular"
    property string currantModeType: "regular"

    property string panelPath: ""

    function updateDefaultPanel()
    {
        if(currantModeType === "regular")
        {
            panelPath = "CreateOrderLight/CreateOrderLight.qml"
        }
        else if(currantModeType === "advanced")
        {
            panelPath = "OrderBook/OrderBook.qml"
        }
    }

    onCurrantModeTypeChanged:
    {
        updateDefaultPanel()
        changeRightPage(panelPath)
    }

    onGoToRightHome:
    {
        changeRightPage(panelPath)
    }
    onGoToDoneCreate:
    {
        changeRightPage("CreateOrder/OrderCreateDone.qml")
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
                spacing: 20

                DapButton
                {
                    enabled: walletModule.balanceDEX ? true : false
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

                    DapCustomToolTip{
                        contentText: qsTr("Create order")
                    }
                }

                DapButton
                {
                    Layout.fillWidth: true
                    implicitHeight: 36
                    textButton: qsTr("Orders")
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


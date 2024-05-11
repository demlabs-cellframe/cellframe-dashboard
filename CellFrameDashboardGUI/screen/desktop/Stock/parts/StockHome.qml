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
    signal goToTokensList()

    property string defaultModeType: "regular"
    property string currantModeType: "regular"

    property string panelPath: ""
    property string tokensListPath: "CreateOrderLight/TokensListRightPanel.qml"

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
                    enabled: walletModule.balanceDEX ? true : false
                    id: createOrderButton
                    Layout.fillWidth: visible
                    implicitHeight: 36
                    textButton: qsTr("Create order")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14
                    visible: currantModeType === "advanced"
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


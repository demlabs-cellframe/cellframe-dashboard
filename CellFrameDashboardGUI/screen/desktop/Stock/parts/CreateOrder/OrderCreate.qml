import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../Chart"
import "../../../controls"

Page
{

    background: Rectangle{color:"transparent"}
    id: createForm

    property string currentOrder: "Limit"

    property bool isSell: false
    signal sellBuyChanged()

    Connections{
        target: dapServiceController
        function onRcvXchangeCreate(rcvData){
            logicStock.resultCreate = rcvData
            goToDoneCreate()
        }
        function onRcvXchangePurchase(rcvData){
            logicStock.resultCreate = rcvData
            goToDoneCreate()
        }
    }

    ListModel {
        id: expiresModel
        ListElement {
            name: qsTr("Not")
        }
        ListElement {
            name: qsTr("1 day")
        }
        ListElement {
            name: qsTr("2 days")
        }
        ListElement {
            name: qsTr("3 days")
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16

                id: itemButtonClose
                height: 20
                width: 20
                heightImage: 20
                widthImage: 20

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
                onClicked: goToRightHome()
            }

            Text
            {
                id: textHeader
                text: qsTr("Create order")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        TwoTextBlocks
        {
            id: textBalance
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.topMargin: 10
            label: qsTr("Balance:")
            //text: walletModule.getBalanceDEX(dexModule.token2) + " " + dexModule.token2
            textColor: currTheme.white
            textFont: mainFont.dapFont.regular14

            Component.onCompleted: 
            {
                setBalanceText(dexModule.token2)
            }

        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.topMargin: 12
            spacing: 10

            Text
            {
                id: textMode
                Layout.fillWidth: true
                font: mainFont.dapFont.medium14
                color: currTheme.white

                text: qsTr("Buy ") + dexModule.token1
            }

            DapSelectorSwitch
            {
                id: buySellSwitcher
                height: 35
                firstName: qsTr("Buy")
                secondName: qsTr("Sell")
                firstColor: currTheme.green
                secondColor: currTheme.red
                itemHorisontalBorder: 16

                onToggled:
                {
                    isSell = secondSelected
                    if (isSell)
                    {
                        textMode.text = qsTr("Sell ") + dexModule.token1
                        setBalanceText(dexModule.token1)
                    }
                    else
                    {
                        textMode.text = qsTr("Buy ") + dexModule.token1
                        setBalanceText(dexModule.token2)

                    }
                    sellBuyChanged()
                }
            }
        }

        Connections
        {
            target: dexModule

            function onCurrentTokenPairChanged()
            {
                buySellSwitcher.setSelected("first")
                setBalanceText(dexModule.token2)
            }
        }

        Connections
        {
            target: walletModule

            function onCurrantBalanceDEXChanged()
            {
                buySellSwitcher.setSelected("first")
                setBalanceText(dexModule.token2)
            }
        }    

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 5
            Layout.topMargin: 7
            Layout.rightMargin: 16
            spacing: 36

            DapRadioButton
            {
                Layout.fillWidth: true

                indicatorInnerSize: 46
                spaceIndicatorText: -5
                fontRadioButton: mainFont.dapFont.regular14
                implicitHeight: 35

                nameRadioButton: qsTr("Limit")
                checked: true

                onClicked: {
                    limit.visible = true
                    market.visible = false
                    stopLimit.visible = false
                    currentOrder = "Limit"
                }
            }

            DapRadioButton
            {
                Layout.fillWidth: true

                indicatorInnerSize: 46
                spaceIndicatorText: -5
                fontRadioButton: mainFont.dapFont.regular14
                implicitHeight: 35

                nameRadioButton: qsTr("Market")
                checked: false

                onClicked: {
                    limit.visible = false
                    market.visible = true
                    stopLimit.visible = false
                    currentOrder = "Market"
                }
            }

            DapRadioButton
            {
                Layout.fillWidth: true
                enabled: false

                indicatorInnerSize: 46
                spaceIndicatorText: -5
                fontRadioButton: mainFont.dapFont.regular14
                implicitHeight: 35

                nameRadioButton: qsTr("Stop limit")
                checked: false

                onClicked: {
                    limit.visible = false
                    market.visible = false
                    stopLimit.visible = true
                    currentOrder = "Stop limit"
                }
            }
        }

        OrderLimit
        {
            id: limit
            Layout.fillWidth: true
        }

        OrderMarket
        {
            id: market
            Layout.fillWidth: true
            visible: false
        }

        OrderStopLimit
        {
            id: stopLimit
            Layout.fillWidth: true
            visible: false
        }
    }

    function setStatusCreateButton(total, price)
    {
        if(price === "0.0" || total === "0.0" || total === "" || price === "")
            return false

        return true
        
        var totalValue = isSell ? mathWorker.divCoins(mathWorker.coinsToBalance(total),
                                                   mathWorker.coinsToBalance(price),false):
                                  total

        var nameToken = isSell ? dexModule.token1 :
                                 dexModule.token2
        var str;

        if(logicStock.currantToken === nameToken)
        {
            str = mathWorker.subCoins(mathWorker.coinsToBalance(logicStock.currantBalance), mathWorker.coinsToBalance(totalValue), false)

            if(str.length < 70)
                return true
            else
                return false
        }
        // else if(logicStock.unselectedTokenNameWallet === nameToken)
        // {
        //     str = mathWorker.subCoins(mathWorker.coinsToBalance(logicStock.unselectedTokenBalanceWallet), mathWorker.coinsToBalance(totalValue), false)

        //     if(str.length < 70)
        //         return true
        //     else
        //         return false
        // }
        else
        {
            return false
        }
    }

    function setBalanceText(token)
    {
        var value = walletModule.getBalanceDEX(token)
        textBalance.text = value + " " + token
        logicStock.currantBalance = value
        logicStock.currantToken = value
    }
}


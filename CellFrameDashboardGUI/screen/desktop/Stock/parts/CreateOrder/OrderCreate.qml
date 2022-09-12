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
        onRcvXchangeCreate:{
            logicStock.resultCreate = rcvData
            goToDoneCreate()
        }
        onRcvXchangePurchase:{
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
                color: currTheme.textColor
            }
        }

        ChartTextBlock
        {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.topMargin: 10
            label: qsTr("Balance:")
            text:
            {
                if(isSell)
                {
                    if(logicStock.selectedTokenNameWallet === logicMainApp.token2Name)
                        return logicStock.unselectedTokenBalanceWallet + " " + logicStock.unselectedTokenNameWallet
                    else
                        return logicStock.selectedTokenBalanceWallet + " " + logicStock.selectedTokenNameWallet
                }
                else
                {
                    if(logicStock.selectedTokenNameWallet === logicMainApp.token2Name)
                        return logicStock.selectedTokenBalanceWallet + " " + logicStock.selectedTokenNameWallet
                    else
                        return logicStock.unselectedTokenBalanceWallet + " " + logicStock.unselectedTokenNameWallet
                }
            }
            textColor: currTheme.textColor
            textFont: mainFont.dapFont.regular14
//            font: mainFont.dapFont.regular14

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
//                Layout.topMargin: 18
                font: mainFont.dapFont.medium14
                color: currTheme.textColor

                text: qsTr("Buy ") + logicMainApp.token1Name
            }

            DapSelectorSwitch
            {
                height: 35
                firstName: qsTr("Buy")
                secondName: qsTr("Sell")
                firstColor: currTheme.textColorGreen
                secondColor: currTheme.textColorRed
                itemHorisontalBorder: 16

                onToggled:
                {
                    isSell = secondSelected
                    if (isSell)
                    {
                        textMode.text = qsTr("Sell ") + logicMainApp.token1Name
                    }
                    else
                    {
                        textMode.text = qsTr("Buy ") + logicMainApp.token1Name

                    }
                    sellBuyChanged()
                }
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
        if(price === "0" || total === "0" || total === "" || price === "")
            return false

        var totalValue = isSell ? dapMath.divCoins(dapMath.coinsToBalance(total),
                                                   dapMath.coinsToBalance(price),false):
                                  total

        var nameToken = isSell ? logicMainApp.token1Name :
                                 logicMainApp.token2Name
        var str;


//        console.log("isSell", isSell, "\n",
//                    "total", total, "\n",
//                    "totalValue", totalValue, "\n",
//                    "price", price, "\n",
//                    "nameToken", nameToken, "\n",
//                    "selectedTokenNameWallet", logicStock.selectedTokenNameWallet, "\n",
//                    "unselectedTokenNameWallet", logicStock.unselectedTokenNameWallet, "\n",
//                    "selectedTokenBalanceWallet", logicStock.selectedTokenBalanceWallet, "\n",
//                    "unselectedTokenBalanceWallet", logicStock.unselectedTokenBalanceWallet)




        if(logicStock.selectedTokenNameWallet === nameToken)
        {
            str = dapMath.subCoins(dapMath.coinsToBalance(logicStock.selectedTokenBalanceWallet), dapMath.coinsToBalance(totalValue), false)

            if(str.length < 70)
                return true
            else
                return false
        }
        else if(logicStock.unselectedTokenNameWallet === nameToken)
        {
            str = dapMath.subCoins(dapMath.coinsToBalance(logicStock.unselectedTokenBalanceWallet), dapMath.coinsToBalance(totalValue), false)

            if(str.length < 70)
                return true
            else
                return false
        }
        else
        {
            return false
        }
    }
}


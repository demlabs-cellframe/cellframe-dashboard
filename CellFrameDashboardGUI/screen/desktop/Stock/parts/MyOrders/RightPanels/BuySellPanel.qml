import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../parts"
import "../../../../controls"
import "../../Chart"
import "../../CreateOrder"

DapRectangleLitAndShaded {
    id: root

    color: currTheme.mainBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

//    property var currentElement: logic.selectedItem

    property bool isBuy: logic.selectedItem.side === "buy"

    contentData:
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
                onClicked: logic.closedDetails()
            }

            Text
            {
                id: textHeader
                text: isBuy ?
                          qsTr("Buy ") + logic.selectedItem.tokenBuy :
                          qsTr("Sell ") + logic.selectedItem.tokenSell
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
            Layout.fillWidth: true
            Layout.maximumHeight: 20
            Layout.leftMargin: 16
            Layout.topMargin: 10
            label: qsTr("Balance:")
            text:
            {
                if(isBuy)
                {
                    if(logicStock.selectedTokenNameWallet === tokenPairsWorker.tokenSell)
                        return logicStock.unselectedTokenBalanceWallet + " " + logicStock.unselectedTokenNameWallet
                    else
                        return logicStock.selectedTokenBalanceWallet + " " + logicStock.selectedTokenNameWallet
                }
                else
                {
                    if(logicStock.selectedTokenNameWallet === tokenPairsWorker.tokenSell)
                        return logicStock.selectedTokenBalanceWallet + " " + logicStock.selectedTokenNameWallet
                    else
                        return logicStock.unselectedTokenBalanceWallet + " " + logicStock.unselectedTokenNameWallet
                }
            }
            textColor: currTheme.white
            textFont: mainFont.dapFont.regular14
//            font: mainFont.dapFont.regular14

        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.topMargin: 12
            color: currTheme.mainBackground
            height: 30
            Text
            {
                color: currTheme.white
                text: qsTr("Price")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.topMargin: 20
                anchors.bottomMargin: 5
            }
        }

        OrderTextBlock
        {
            id: price
            enabled: false
            Layout.fillWidth: true
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            Layout.topMargin: 12
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            textToken: isBuy ?
                      logic.selectedItem.tokenSell :
                      logic.selectedItem.tokenBuy
            textValue: logic.selectedItem.price
//            textToken: tokenPairsWorker.tokenSell
//            textValue: candleChartWorker.currentTokenPrice
            onEdited: {
                createButton.enabled = logic.setStatusCreateButton(total.textValue , price.textValue)
                if(amount.textValue !== "0")
                    total.textValue = mathWorker.multCoins(mathWorker.coinsToBalance(amount.textValue),
                                                    mathWorker.coinsToBalance(logic.selectedItem.price),false)
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.topMargin: 12
            color: currTheme.mainBackground
            height: 30
            Text
            {
                color: currTheme.white
                text: qsTr("Amount")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.topMargin: 20
                anchors.bottomMargin: 5
            }
        }

        OrderTextBlock
        {
            id: amount
            Layout.fillWidth: true
            Layout.topMargin: 12
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            textToken: tokenPairsWorker.tokenBuy
            textValue: "0.0"
            onEdited:
            {
                console.log(logic.selectedItem, "AAAAAAAAAAAAAAAAAAAAAAAAA")
                total.textValue = mathWorker.multCoins(mathWorker.coinsToBalance(textValue),
                                                    mathWorker.coinsToBalance(logic.selectedItem.price),false)

                button25.selected = false
                button50.selected = false
                button75.selected = false
                button100.selected = false

                createButton.enabled = logic.setStatusCreateButton(total.textValue, logic.selectedItem.price)
            }
        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.topMargin: 12
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            DapButton
            {
                id: button25
                Layout.fillWidth: true
                implicitHeight: 25
                textButton: qsTr("25%")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button25.selected = true
                    button50.selected = false
                    button75.selected = false
                    button100.selected = false

                    var result = logicStock.getPercentBalance("0.25", price.textValue, isSell)

                    amount.textValue = result[0]
                    total.textValue = result[1]
                }
            }

            DapButton
            {
                id: button50
                Layout.fillWidth: true
                implicitHeight: 25
                textButton: qsTr("50%")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button25.selected = false
                    button50.selected = true
                    button75.selected = false
                    button100.selected = false

                    var result = logicStock.getPercentBalance("0.5", price.textValue, isSell)

                    amount.textValue = result[0]
                    total.textValue = result[1]
                }
            }

            DapButton
            {
                id: button75
                Layout.fillWidth: true
                implicitHeight: 25
                textButton: qsTr("75%")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button25.selected = false
                    button50.selected = false
                    button75.selected = true
                    button100.selected = false

                    var result = logicStock.getPercentBalance("0.75", price.textValue, isSell)

                    amount.textValue = result[0]
                    total.textValue = result[1]
                }
            }

            DapButton
            {
                id: button100
                Layout.fillWidth: true
                implicitHeight: 25
                textButton: qsTr("100%")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button25.selected = false
                    button50.selected = false
                    button75.selected = false
                    button100.selected = true

                    var result = logicStock.getPercentBalance("1.0", price.textValue, isSell)

                    amount.textValue = result[0]
                    total.textValue = result[1]
                }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.topMargin: 12
            color: currTheme.mainBackground
            height: 30
            Text
            {
                color: currTheme.white
                text: qsTr("Total")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.topMargin: 20
                anchors.bottomMargin: 5
            }
        }

        OrderTextBlock
        {
            id: total
            Layout.fillWidth: true
            Layout.topMargin: 12
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            textToken: tokenPairsWorker.tokenSell
            textValue: "0.0"
            onEdited:
            {
                button25.selected = false
                button50.selected = false
                button75.selected = false
                button100.selected = false

                amount.textValue = mathWorker.divCoins(mathWorker.coinsToBalance(textValue),
                                                    mathWorker.coinsToBalance(logic.selectedItem.price),false)
                createButton.enabled = logic.setStatusCreateButton(total.textValue , price.textValue)
            }
            onTextValueChanged: createButton.enabled = logic.setStatusCreateButton(total.textValue, logic.selectedItem.price)
        }

        DapButton
        {
            id:createButton
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 22
            implicitHeight: 36
            implicitWidth: 132
            textButton: isBuy ?
                      qsTr("Buy "):
                      qsTr("Sell ")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14

            onClicked:
            {

/*                var net = logicMainApp.tokenNetwork
                var tokenSell = isSell ? logicMainApp.token1Name : logicMainApp.token2Name
                var tokenBuy = isSell ? logicMainApp.token2Name : logicMainApp.token1Name
                var currentWallet = dapModelWallets.get(logicMainApp.currentWalletIndex).name
>>>>>>> 04b3a0bdd7e314a710a5aff7e1f5d26907280ca8

                var amountBuy = isSell ? mathWorker.coinsToBalance(total.textValue) :
                                          mathWorker.coinsToBalance(amount.textValue)

                var amountSell = isSell ? mathWorker.coinsToBalance(amount.textValue) :
                                         mathWorker.coinsToBalance(total.textValue)

                var priceValue = isSell? price.textValue : 1/price.textValue

    //            console.log("tokenSell",tokenSell,
    //                        "tokenBuy", tokenBuy,
    //                        "amountSell", amountSell,
    //                        "amountBuy", amountBuy,
    //                        "priceValue" , priceValue)

                var hash = logicStock.searchOrder(net, tokenSell, tokenBuy, priceValue, amountSell, amountBuy)

                if(hash !== "0")
                    dapServiceController.requestToService("DapXchangeOrderPurchase", hash,
                                                          net, currentWallet, amountSell)
                else
                    dapServiceController.requestToService("DapXchangeOrderCreate", net, tokenSell, tokenBuy,
                                                          currentWallet, amountSell, priceValue)*/
            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}

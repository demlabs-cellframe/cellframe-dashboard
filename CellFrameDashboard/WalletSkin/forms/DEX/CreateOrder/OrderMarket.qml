import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../Chart"

ColumnLayout {
    Layout.fillWidth: true
//    Layout.topMargin: 16
    spacing: 0

    Component.onCompleted: updateForms()

/*    Connections{
        target: createForm
        onSellBuyChanged:{
            createButton.enabled = setStatusCreateButton(total.textValue, logicMainApp.tokenPrice)
//            updateForms()
        }
    }
    Connections{
        target: stockTab
        onTokenPairChanged:{
            updateForms()
        }
    }*/

    Rectangle
    {
        Layout.fillWidth: true
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
            anchors.topMargin: 20
//            anchors.bottomMargin: 5
        }
    }

    OrderTextBlock
    {
        id: price
        enabled: false
        Layout.fillWidth: true
        Layout.minimumHeight: 40
        Layout.maximumHeight: 40
//        Layout.topMargin: 12
        textToken: createLogic.unselectedTokenName
        textValue: createLogic.selectedTokenPrice
        onEdited: {
            createButton.enabled = setStatusCreateButton(total.textValue , price.textValue)
//            if(amount.textValue !== "" || amount.textValue !== "0")
//                total.textElement.setText(dapMath.multCoins(dapMath.coinsToBalance(amount.textValue),
//                                                dapMath.coinsToBalance(tokenPairsWorker.tokenPrice),false))
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
            anchors.topMargin: 20
//            anchors.bottomMargin: 5
        }
    }

    OrderTextBlock
    {
        id: amount
        Layout.fillWidth: true
//        Layout.topMargin: 12
        Layout.minimumHeight: 40
        Layout.maximumHeight: 40
        textToken: tokenPairsWorker.tokenBuy
        textValue: ""
        onEdited:
        {
//            total.textElement.setText(dapMath.multCoins(dapMath.coinsToBalance(textValue),
//                                                dapMath.coinsToBalance(tokenPairsWorker.tokenPrice),false))

            button25.selected = false
            button50.selected = false
            button75.selected = false
            button100.selected = false

//            createButton.enabled = setStatusCreateButton(total.textValue, tokenPairsWorker.tokenPrice)
        }
    }

    RowLayout
    {
        Layout.fillWidth: true
        Layout.topMargin: 12

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

                var result = createLogic.getPercentBalance("0.25", price.textValue, isSell)

                amount.textValue = result[0]
//                total.textValue = result[1]
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

                var result = createLogic.getPercentBalance("0.5", price.textValue, isSell)

                amount.textValue = result[0]
//                total.textValue = result[1]
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

                var result = createLogic.getPercentBalance("0.75", price.textValue, isSell)

                amount.textValue = result[0]
//                total.textValue = result[1]
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

                var result = createLogic.getPercentBalance("1.0", price.textValue, isSell)

                amount.textValue = result[0]
//                total.textValue = result[1]
            }
        }
    }

/*    Rectangle
    {
        Layout.fillWidth: true
        Layout.topMargin: 12
        color: currTheme.backgroundMainScreen
        height: 30
        Text
        {
            color: currTheme.textColor
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
        textValue: ""
        onEdited:
        {
            button25.selected = false
            button50.selected = false
            button75.selected = false
            button100.selected = false

            amount.textElement.setText(dapMath.divCoins(dapMath.coinsToBalance(textValue),
                                                dapMath.coinsToBalance(tokenPairsWorker.tokenPrice),false))
            createButton.enabled = setStatusCreateButton(total.textValue , price.textValue)
        }
        onTextValueChanged: createButton.enabled = setStatusCreateButton(total.textValue, tokenPairsWorker.tokenPrice)
    }*/

    DapButton
    {
        id:createButton
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: 22
        implicitHeight: 36
        implicitWidth: 132
        textButton: qsTr("Create")
        horizontalAligmentText: Text.AlignHCenter
        indentTextRight: 0
        fontButton: mainFont.dapFont.medium14

        onClicked:
        {

            var net = tokenPairsWorker.tokenNetwork
            var tokenSell = isSell ? tokenPairsWorker.tokenBuy : tokenPairsWorker.tokenSell
            var tokenBuy = isSell ? tokenPairsWorker.tokenSell : tokenPairsWorker.tokenBuy
            var currentWallet = dapModelWallets.get(logicMainApp.currentIndex).name

            var amountBuy = isSell ? dapMath.coinsToBalance(total.textValue) :
                                      dapMath.coinsToBalance(amount.textValue)

            var amountSell = isSell ? dapMath.coinsToBalance(amount.textValue) :
                                     dapMath.coinsToBalance(total.textValue)

            var priceValue = isSell? price.textValue : 1/price.textValue

//            console.log("tokenSell",tokenSell,
//                        "tokenBuy", tokenBuy,
//                        "amountSell", amountSell,
//                        "amountBuy", amountBuy,
//                        "priceValue" , priceValue)

            var hash = createLogic.searchOrder(net, tokenSell, tokenBuy, priceValue, amountSell, amountBuy)

            if(hash !== "0")
                logicMainApp.requestToService("DapXchangeOrderPurchase", hash,
                                                      net, currentWallet, amountSell)
            else
                logicMainApp.requestToService("DapXchangeOrderCreate", net, tokenSell, tokenBuy,
                                                      currentWallet, amountSell, priceValue)
        }
    }

    Item{
        Layout.fillHeight: true
    }

    function updateForms()
    {
        price.textValue = tokenPairsWorker.tokenPrice
//        price.setRealValue(logicMainApp.tokenPrice)
//        total.textValue = ""
        amount.textValue = ""
//        createButton.enabled = setStatusCreateButton(total.textValue, logicMainApp.tokenPrice)
        button25.selected = false
        button50.selected = false
        button75.selected = false
        button100.selected = false
    }
}

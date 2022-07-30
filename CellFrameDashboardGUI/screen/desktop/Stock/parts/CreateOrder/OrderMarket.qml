import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../Chart"

ColumnLayout {
    Layout.fillWidth: true
    Layout.topMargin: 16
    spacing: 0

    Component.onCompleted: updateForms()

    Connections{
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
    }

    Rectangle
    {
        Layout.fillWidth: true
        color: currTheme.backgroundMainScreen
        height: 30
        Text
        {
            color: currTheme.textColor
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
        textToken: logicMainApp.token2Name
        textValue: logicMainApp.tokenPrice
        onEdited: {
            if(amount.textValue !== "0")
                total.textValue = dapMath.multCoins(dapMath.coinsToBalance(amount.textValue),
                                                dapMath.coinsToBalance(logicMainApp.tokenPrice),false)
        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        Layout.topMargin: 12
        color: currTheme.backgroundMainScreen
        height: 30
        Text
        {
            color: currTheme.textColor
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
        textToken: logicMainApp.token1Name
        textValue: "0.0"
        onEdited:
        {
            total.textValue = dapMath.multCoins(dapMath.coinsToBalance(textValue),
                                                dapMath.coinsToBalance(logicMainApp.tokenPrice),false)

            button25.selected = false
            button50.selected = false
            button75.selected = false
            button100.selected = false

            createButton.enabled = setStatusCreateButton(total.textValue, logicMainApp.tokenPrice)
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
        textToken: logicMainApp.token2Name
        textValue: "0.0"
        onEdited:
        {
            button25.selected = false
            button50.selected = false
            button75.selected = false
            button100.selected = false

            amount.textValue = dapMath.divCoins(dapMath.coinsToBalance(textValue),
                                                dapMath.coinsToBalance(logicMainApp.tokenPrice),false)
        }
        onTextValueChanged: createButton.enabled = setStatusCreateButton(total.textValue, logicMainApp.tokenPrice)
    }

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
            var net = logicMainApp.tokenNetwork
            var isSell = sellBuySwitch.checked
            var tokenSell = isSell ? logicStock.unselectedTokenNameWallet : logicStock.selectedTokenNameWallet
            var tokenBuy = isSell ? logicStock.selectedTokenNameWallet : logicStock.unselectedTokenNameWallet
            var currentWallet = dapModelWallets.get(logicMainApp.currentIndex).name

            var amountValue = dapMath.coinsToBalance(amount.textValue)
            var hash = logicStock.searchOrder(net, tokenSell, tokenBuy, price.textValue, amountValue)

            if(hash !== "0")
                dapServiceController.requestToService("DapXchangeOrderPurchase", hash,
                                                      net, currentWallet, amountValue)

            else
                dapServiceController.requestToService("DapXchangeOrderCreate", net, tokenSell, tokenBuy,
                                                      currentWallet, amountValue, price.textValue)
        }
    }

    Item{
        Layout.fillHeight: true
    }

    function updateForms()
    {
        price.textValue = logicMainApp.tokenPrice
//        price.setRealValue(logicMainApp.tokenPrice)
        total.textValue = "0"
        amount.textValue = "0"
        createButton.enabled = setStatusCreateButton(total.textValue, logicMainApp.tokenPrice)
        button25.selected = false
        button50.selected = false
        button75.selected = false
        button100.selected = false
    }
}

import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../Chart"

ColumnLayout {
    Layout.fillWidth: true
    Layout.topMargin: 16
    spacing: 0

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
        textToken: logicStock.unselectedTokenNameWallet
        realValue: logicMainApp.tokenPrice
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
        textToken: logicStock.selectedTokenNameWallet
        textValue: "0.0"
        onEdited:
        {
            total.setRealValue(realValue * logicMainApp.tokenPrice)

            button25.selected = false
            button50.selected = false
            button75.selected = false
            button100.selected = false
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

                amount.setRealValue(
                    (logicStock.selectedTokenBalanceWallet / logicMainApp.tokenPrice)*0.25)
                total.setRealValue(logicStock.selectedTokenBalanceWallet*0.25)
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

                amount.setRealValue(
                    (logicStock.selectedTokenBalanceWallet / logicMainApp.tokenPrice)*0.5)
                total.setRealValue(logicStock.selectedTokenBalanceWalletl*0.5)
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

                amount.setRealValue(
                    (logicStock.selectedTokenBalanceWallet / logicMainApp.tokenPrice)*0.75)
                total.setRealValue(logicStock.selectedTokenBalanceWallet*0.75)
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

                amount.setRealValue(
                    logicStock.selectedTokenBalanceWallet / logicMainApp.tokenPrice)
                total.setRealValue(logicStock.selectedTokenBalanceWallet)
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
        textToken: logicStock.unselectedTokenNameWallet
        textValue: "0.0"
        onEdited:
        {
            button25.selected = false
            button50.selected = false
            button75.selected = false
            button100.selected = false

            amount.setRealValue(realValue / logicMainApp.tokenPrice)
        }
    }

    DapButton
    {
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

            var amountValue = logicStock.toDatoshi(amount.textValue)
            var hash = logicStock.searchOrder(net, tokenSell, tokenBuy, price.realValue, amountValue)

            console.log("HASH: ", hash)

            if(hash !== "0")
                dapServiceController.requestToService("DapXchangeOrderPurchase", hash,
                                                      net, currentWallet, amountValue)

            else
                dapServiceController.requestToService("DapXchangeOrderCreate", net, tokenSell, tokenBuy,
                                                      currentWallet, amountValue, price.realValue)
        }
    }

    Item{
        Layout.fillHeight: true
    }
}

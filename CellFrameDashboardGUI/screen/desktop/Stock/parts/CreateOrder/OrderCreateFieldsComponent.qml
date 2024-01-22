import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../Chart"
import "../MyOrders/logic"
import "../../../controls"
import "../MyOrders/parts"


ColumnLayout {
    property string tmpPriceValue: ""

    property alias price: price
    property alias amount: amount
    
    property string parentPage: ""
    property string limitType: ""

    property bool sell: true
    property string balance: ""
    property string logicPrice: ""

    signal createBtnClicked()

    Layout.fillWidth: true
    Layout.topMargin: 16
    spacing: 0

    Component.onCompleted:
    {
        updateTokensField()
        updateForms()
    }

    // STOP
    Rectangle
    {
        Layout.fillWidth: true
        color: currTheme.mainBackground
        height: 30
        visible: limitType === "STOP_LIMIT"

        Text
        {
            color: currTheme.white
            text: qsTr("Stop")
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
        id: stop
        Layout.fillWidth: true
        Layout.topMargin: 12
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.minimumHeight: 40
        Layout.maximumHeight: 40
        visible: limitType === "STOP_LIMIT"
    }

    // PRICE / LIMIT
    Rectangle
    {
        Layout.fillWidth: true
        color: currTheme.mainBackground
        height: 30

        Text
        {
            color: currTheme.white
            text: limitType === "STOP_LIMIT" ? qsTr("Limit") : qsTr("Price")
            font: mainFont.dapFont.medium12
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.topMargin: 20
            anchors.bottomMargin: 5
        }

        Text
        {
            color: currTheme.white
            text: qsTr("Expires in")
            font: mainFont.dapFont.medium12
            horizontalAlignment: Text.AlignRight
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 57
            anchors.topMargin: 20
            anchors.bottomMargin: 5
            visible: limitType === "STOP_LIMIT" || limitType === "LIMIT"
        }
    }

    RowLayout
    {
        Layout.fillWidth: true
        Layout.topMargin: 12
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        spacing: 8

        OrderTextBlock
        {
            id: price
            enabled: limitType === "MARKET" || parentPage === "BUY_SELL" ? false : true
            Layout.fillWidth: true
            Layout.minimumWidth: 203
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40

            onEdited: {
                if(parentPage === "BUY_SELL")
                {
                    createButton.enabled = setStatusCreateButton(total.textValue , price.textValue)
                    if(amount.textValue !== "0")
                        total.textValue = mathWorker.multCoins(mathWorker.coinsToBalance(amount.textValue),
                                                               mathWorker.coinsToBalance(logicPrice), false)
                }
                else if(limitType === "LIMIT")
                {
                    if(tmpPriceValue !== textValue)
                    {
                        dexModule.setCurrentPrice(textValue)
                    }
                    tmpPriceValue = ""
                    createButton.enabled = setStatusCreateButton(total.textValue , price.textValue)
                    if(dexModule.isValidValue(amount.textValue) && dexModule.isValidValue(textValue))
                        total.textElement.setText(mathWorker.multCoins(mathWorker.coinsToBalance(amount.textValue),
                                                                       mathWorker.coinsToBalance(sell ? textValue : dexModule.invertValue(textValue)),false))
                }
                else if(limitType === "MARKET")
                {
                    createButton.enabled = setStatusCreateButton(total.textValue , price.textValue)
                    if(dexModule.isValidValue(amount.textValue) && dexModule.isValidValue(textValue))
                        total.textElement.setText(mathWorker.multCoins(mathWorker.coinsToBalance(amount.textValue),
                                                                       mathWorker.coinsToBalance(sell ? textValue : dexModule.invertValue(textValue)),false))
                }
            }
        }

        Rectangle
        {
            id: expiresRect
            Layout.fillWidth: true
            Layout.minimumWidth: 95
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            color: "transparent"
            visible: limitType === "STOP_LIMIT" || limitType === "LIMIT"

            DapCustomComboBox
            {
                id: expiresComboBox
                anchors.fill: parent
                anchors.margins: 2
                font: mainFont.dapFont.regular16
                model: expiresModel
                backgroundColorShow: currTheme.secondaryBackground
                enabled: limitType === "STOP_LIMIT"
            }
        }
    }

    // AMOUNT
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

        onEdited:
        {
            setPercentButtons(false, false, false, false)

            if(parentPage === "BUY_SELL")
            {
                total.textValue = mathWorker.multCoins(mathWorker.coinsToBalance(textValue),
                                                                    mathWorker.coinsToBalance(logicPrice),false)
                createButton.enabled = setStatusCreateButton(total.textValue, logicPrice)
            }
            else if(limitType === "LIMIT")
            {
                if(dexModule.isValidValue(price.textValue) && dexModule.isValidValue(textValue))
                    total.textElement.setText(mathWorker.multCoins(mathWorker.coinsToBalance(textValue),
                                                                   mathWorker.coinsToBalance(sell ? price.textValue : dexModule.invertValue(price.textValue)),false))
                createButton.enabled = setStatusCreateButton(total.textValue, price.textValue)
            }
            else if(limitType === "MARKET")
            {
                if(dexModule.isValidValue(price.textValue) && dexModule.isValidValue(textValue))
                    total.textElement.setText(mathWorker.multCoins(mathWorker.coinsToBalance(textValue),
                                                                   mathWorker.coinsToBalance(sell ? price.textValue : dexModule.invertValue(price.textValue)),false))
                createButton.enabled = setStatusCreateButton(total.textValue, candleChartWorker.currentTokenPrice)
            }
        }
    }

    // PERCENT BUTTONS
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
                setPercentButtons(true, false, false, false)

                if(limitType === "STOP_LIMIT")
                {
                    amount.setRealValue(
                        (logicStock.selectedTokenBalanceWallet / candleChartWorker.currentTokenPrice) * 0.25)
                }
                else
                {
                    var result = logicStock.getPercentBalance(balance, "0.25", price.textValue, sell)
                    amount.textValue = result[0]
                    total.textValue = result[1]
                }
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
                setPercentButtons(false, true, false, false)

                if(limitType === "STOP_LIMIT")
                {
                    amount.setRealValue(
                        (logicStock.selectedTokenBalanceWallet / candleChartWorker.currentTokenPrice) * 0.5)
                }
                else
                {
                    var result = logicStock.getPercentBalance(balance, "0.5", price.textValue, sell)
                    amount.textValue = result[0]
                    total.textValue = result[1]
                }
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
                setPercentButtons(false, false, true, false)

                if(limitType === "STOP_LIMIT")
                {
                    amount.setRealValue(
                        (logicStock.selectedTokenBalanceWallet / candleChartWorker.currentTokenPrice) * 0.75)
                }
                else
                {
                    var result = logicStock.getPercentBalance(balance, "0.75", price.textValue, sell)
                    amount.textValue = result[0]
                    total.textValue = result[1]
                }
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
                setPercentButtons(false, false, false, true)

                if(limitType === "STOP_LIMIT")
                {
                    amount.setRealValue(
                        (logicStock.selectedTokenBalanceWallet / candleChartWorker.currentTokenPrice))
                }
                else
                {
                    var result = logicStock.getPercentBalance(balance, "1.0", price.textValue, sell)
                    amount.textValue = result[0]
                    total.textValue = result[1]
                }
            }
        }
    }

    // TOTAL HEADER
    Rectangle
    {
        Layout.fillWidth: true
        Layout.topMargin: 12
        color: currTheme.mainBackground
        height: 30
        visible: limitType !== "STOP_LIMIT"

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
        visible: limitType !== "STOP_LIMIT"
        onEdited:
        {
            setPercentButtons(false, false, false, false)

            if(dexModule.isValidValue(price.textValue) && dexModule.isValidValue(textValue))
                    amount.textElement.setText(mathWorker.divCoins(mathWorker.coinsToBalance(textValue),
                                                           mathWorker.coinsToBalance(sell ? price.textValue : dexModule.invertValue(price.textValue)),false))
            createButton.enabled = setStatusCreateButton(total.textValue , price.textValue)
        }

        onTextValueChanged: {
            if(limitType === "LIMIT")
            {
                createButton.enabled = setStatusCreateButton(total.textValue, logicPrice)
            }
            else if(limitType === "LIMIT")
            {
                createButton.enabled = setStatusCreateButton(total.textValue, price.textValue)
            }
            else if(limitType === "MARKET")
            {
                createButton.enabled = setStatusCreateButton(total.textValue, candleChartWorker.currentTokenPrice)
            }
        }
    }

    // CREATE BUTTON
    DapButton
    {
        id: createButton
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: 22
        implicitHeight: 36
        implicitWidth: 132
        textButton: parentPage === "CREATE_ORDER" ? qsTr("Create") : !sell ? qsTr("Buy") : qsTr("Sell")
        horizontalAligmentText: Text.AlignHCenter
        indentTextRight: 0
        fontButton: mainFont.dapFont.medium14
        enabled: false
        onClicked: createBtnClicked()
    }

    Item {
        Layout.fillHeight: true
    }

    function updateTokensField()
    {
        if(limitType === "LIMIT" || limitType === "MARKET")
        {
            if(!sell)
            {
                price.textValue = dexModule.currentRate
                price.textToken = dexModule.token2
                amount.textToken = dexModule.token2
                total.textToken = dexModule.token1
            }
            else
            {
                price.textValue = dexModule.currentRate
                price.textToken = dexModule.token1
                amount.textToken = dexModule.token1
                total.textToken = dexModule.token2
            }
        }
    }

    function updateForms()
    {
        if(limitType === "LIMIT" || limitType === "MARKET")
        {
            if(limitType === "MARKET") price.textValue = candleChartWorker.currentTokenPrice
            total.textValue = ""
            amount.textValue = ""
            createButton.enabled = setStatusCreateButton(total.textValue, candleChartWorker.currentTokenPrice)
            setPercentButtons(false, false, false, false)
        }
    }

    function show(page, limit_type)
    {
        if(page === "CREATE_ORDER")
        {
            if(limit_type === "LIMIT" || limit_type === "MARKET" || limit_type === "STOP_LIMIT")
            {
                limitType = limit_type
                parentPage = page
            }
            else
            {
                console.log("Unknown limit_type of order:", limit_type)
                return
            }
        }
        else if(page === "BUY_SELL")
        {
            limitType = ""
            parentPage = page
        }
        else
        {
            console.log("Unknown parent page:", page)
            return
        }

        updateTokensField()
        updateForms()
    }

    function setPercentButtons(sel25, sel50, sel75, sel100)
    {
        button25.selected = sel25
        button50.selected = sel50
        button75.selected = sel75
        button100.selected = sel100
    }

    function setStatusCreateButton(total_value, price_value)
    {
        if(price_value === "0.0" || total_value === "0.0" || total_value === "" || price_value === "")
            return false

        var totalValue = sell ? mathWorker.divCoins(mathWorker.coinsToBalance(total_value),
                                                   mathWorker.coinsToBalance(price_value),false):
                                  total_value

        var nameToken = sell ? dexModule.token1 :
                                 dexModule.token2
        var str;

        if(logicStock.currantToken === nameToken)
        {
            str = mathWorker.subCoins(mathWorker.coinsToBalance(balance), mathWorker.coinsToBalance(totalValue), false)

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
}

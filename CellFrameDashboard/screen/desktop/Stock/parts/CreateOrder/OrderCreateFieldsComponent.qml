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
    property alias total: total

    property alias messageText: messageText

    property string parentPage: ""
    property string limitType: ""

    property bool sell: true
    property string balance: ""
    property string logicPrice: ""

    Layout.fillWidth: true
    Layout.topMargin: 16
    spacing: 0

    signal percentButtonClicked(var percent)

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
                var tmpStr = removeZerosAndDots(price.textValue)
                if(tmpStr.length  === 0)
                {
                    return
                }

                if(tmpPriceValue !== textValue)
                {
                    dexModule.setCurrentPrice(textValue)
                }
                tmpPriceValue = ""

                total.textElement.setText(dexModule.divCoins(amount.textValue, price.textValue))

                createButton.enabled = setStatusCreateButton(total.textValue , price.textValue)
            }

            onTextValueChanged:
            {
                if(!textElement.activeFocus) textElement.cursorPosition = 0
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
            text: qsTr("Amount of ") + amount.textToken + (sell ? qsTr(" for sale") : qsTr(" to receive"))
            font: mainFont.dapFont.medium12
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.topMargin: 20
            anchors.bottomMargin: 5
        }

        DapToolTipInfo
        {
            visible: isMToken(amount.textToken)
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            contentText: qsTr("Warning! To unstake you need to have the exact amount of cell in the wallet you staked.")
            text.color: currTheme.textColorYellow
            indicatorSrcNormal: "qrc:/Resources/"+ pathTheme +"/icons/other/ic_info_orange.svg"
            indicatorSrcHover: "qrc:/Resources/"+ pathTheme +"/icons/other/ic_info_orange.svg"
        }
    }

    OrderTextBlock
    {
        property bool percentIsSelected: false
        id: amount
        Layout.fillWidth: true
        Layout.topMargin: 12
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.minimumHeight: 40
        Layout.maximumHeight: 40
        border.color: isMToken(amount.textToken) ? currTheme.textColorYellow : currTheme.input
        onEdited:
        {
            if(amount.percentIsSelected)
                amount.percentIsSelected = false
            else
            {
                setPercentButtons(false, false, false, false)
            }

            var tmpPriceValue = removeZerosAndDots(price.textValue)
            var tmpAmountValue = removeZerosAndDots(textValue)
            if(tmpPriceValue.length  === 0 || tmpAmountValue.length  === 0)
            {
                return
            }

            if(dexModule.isValidValue(price.textValue) && dexModule.isValidValue(textValue))
            {
                total.textElement.setText(dexModule.divCoins(textValue, price.textValue))
            }                

                
            createButton.enabled = setStatusCreateButton(total.textValue, price.textValue)
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
                if(button25.selected)
                {
                    amount.textElement.text = ""
                    total.textElement.text = ""
                    return
                }

                setPercentButtons(true, false, false, false)
                calculatePersent("0.25")
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
                if(button50.selected)
                {
                    amount.textElement.text = ""
                    total.textElement.text = ""
                    return
                }

                setPercentButtons(false, true, false, false)
                calculatePersent("0.5")
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
                if(button75.selected)
                {
                    amount.textElement.text = ""
                    total.textElement.text = ""
                    return
                }

                setPercentButtons(false, false, true, false)
                calculatePersent("0.75")
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
                if(button100.selected)
                {
                    amount.textElement.text = ""
                    total.textElement.text = ""
                    return
                }

                setPercentButtons(false, false, false, true)
                calculatePersent("1.0")
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
            text: qsTr("Total ") + total.textToken + (!sell ? qsTr(" for sale") : qsTr(" to receive"))
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
            if(amount.percentIsSelected)
                amount.percentIsSelected = false
            else
            {
                setPercentButtons(false, false, false, false)
            }

            var tmpPriceValue = removeZerosAndDots(price.textValue)
            var tmpAmountValue = removeZerosAndDots(textValue)
            if(tmpPriceValue.length  === 0 || tmpAmountValue.length  === 0)
            {
                return
            }

            if(dexModule.isValidValue(price.textValue) && dexModule.isValidValue(textValue))
                amount.textElement.setText(dexModule.multCoins(textValue, price.textValue))
            createButton.enabled = setStatusCreateButton(total.textValue , price.textValue)                

        }

        onTextValueChanged: {

            messageText.text = ""
            if(limitType === "LIMIT" || parentPage === "BUY_SELL")
            {
                createButton.enabled = setStatusCreateButton(total.textValue, price.textValue)
            }
            else if(limitType === "MARKET")
            {
                createButton.enabled = setStatusCreateButton(total.textValue, candleChartWorker.currentTokenPrice)
            }
        }
    }

    Text
    {
        id: messageText

        Layout.fillWidth: true
        Layout.topMargin: 12
        Layout.bottomMargin: 12
        Layout.maximumWidth: 281
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

        color: currTheme.neon
        text: ""
        font: mainFont.dapFont.regular12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        visible: true
    }

    // CREATE BUTTON
    DapButton
    {
        id: createButton
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: 12
        implicitHeight: 36
        implicitWidth: 132
        textButton: parentPage === "CREATE_ORDER" ? qsTr("Create") : !sell ? qsTr("Buy") : qsTr("Sell")
        horizontalAligmentText: Text.AlignHCenter
        indentTextRight: 0
        fontButton: mainFont.dapFont.medium14
        enabled: false
        onClicked: onCreateBtnClicked()
    }

    Item {
        Layout.fillHeight: true
    }

    function isMToken(token)
    {
        if(token.substring(0,1)==="m")
        {
            return true
        }
        return false
    }

    function setPercentValue(persent)
    {

    }

    function updateTokensField()
    {
        if(limitType === "LIMIT" || limitType === "MARKET")
        {
            if(!sell)
            {
                price.textValue = dexModule.currentRate
                price.textToken = dexModule.token2

            }
            else
            {
                price.textValue = dexModule.currentRate
                price.textToken = dexModule.token2

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
        }
        createButton.enabled = setStatusCreateButton(total.textValue, candleChartWorker.currentTokenPrice)
        setPercentButtons(false, false, false, false)
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
        if(sel25 || sel50 || sel75 || sel100)
            amount.percentIsSelected = true

        button25.selected = sel25
        button50.selected = sel50
        button75.selected = sel75
        button100.selected = sel100
    }

    function calculatePersent(percent)
    {
        var data = {
        "network"      : dexModule.networkPair,
        "percent"      : percent,
        "send_ticker"  : sell ? amount.textToken : price.textToken,
        "wallet_name"  : walletModule.currentWalletName}

        var res = walletModule.calculatePrecentAmount(data);

        if(sell)
        {
            amount.textElement.text = res
            amount.textElement.cursorPosition = amount.textElement.length
        }
        else
        {
            total.textElement.text = res
            total.textElement.cursorPosition = total.textElement.length
        }
    }

    function setStatusCreateButton(total_value, price_value)
    {
        if(app.getNodeMode() || !modulesController.isNodeWorking)
            return false


        if(price_value === "0.0" || total_value === "0.0" || total_value === "" || price_value === "")
        {
            return false
        }
        return true
    }
    
    function removeZerosAndDots(inputString) 
    {
        return inputString.replace(/[0.]/g, '');
    }

    Connections
    {
        target: dexModule

        function onCurrentRateFirstTime()
        {
            updateTokensField()
        }
    }
}

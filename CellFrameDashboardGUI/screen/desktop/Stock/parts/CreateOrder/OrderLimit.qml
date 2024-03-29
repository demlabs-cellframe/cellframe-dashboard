import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../Chart"

ColumnLayout {
    property string tmpPriceValue: ""

    Layout.fillWidth: true
    Layout.topMargin: 16
    spacing: 0

    Component.onCompleted: 
    {
        updateTokensField()
        updateForms()
    }

    Connections{
        target: createForm
        function onSellBuyChanged(){
            createButton.enabled = setStatusCreateButton(total.textValue , price.textValue)
            updateTokensField()
            updateForms()
        }
    }

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
            Layout.fillWidth: true
            Layout.minimumWidth: 203
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40

            onEdited: {
                if(tmpPriceValue !== textValue)
                {
                    dexModule.setCurrentPrice(textValue)
                }
                tmpPriceValue = ""
                createButton.enabled = setStatusCreateButton(total.textValue , price.textValue)

                if(dexModule.isValidValue(amount.textValue) && dexModule.isValidValue(textValue))
                    total.textElement.setText(mathWorker.multCoins(mathWorker.coinsToBalance(amount.textValue),
                                    mathWorker.coinsToBalance(isSell ? textValue : dexModule.invertValue(textValue)),false))
            }

            Component.onCompleted:
            {
                price.textValue = dexModule.currentRate
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

            DapCustomComboBox
            {
                id: expiresComboBox
                anchors.fill: parent
                anchors.margins: 2
                font: mainFont.dapFont.regular16
                enabled: false
                rightMarginIndicator: 0
                model: expiresModel
                backgroundColorShow: currTheme.secondaryBackground
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

            if(dexModule.isValidValue(price.textValue) && dexModule.isValidValue(textValue))
                total.textElement.setText(mathWorker.multCoins(mathWorker.coinsToBalance(textValue),
                                    mathWorker.coinsToBalance(isSell ? price.textValue : dexModule.invertValue(price.textValue)),false))

            button25.selected = false
            button50.selected = false
            button75.selected = false
            button100.selected = false

            createButton.enabled = setStatusCreateButton(total.textValue, price.textValue)
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
        onEdited:
        {
            button25.selected = false
            button50.selected = false
            button75.selected = false
            button100.selected = false

            if(dexModule.isValidValue(price.textValue) && dexModule.isValidValue(textValue))
                    amount.textElement.setText(mathWorker.divCoins(mathWorker.coinsToBalance(textValue),
                                                           mathWorker.coinsToBalance(isSell ? price.textValue : dexModule.invertValue(price.textValue)),false))
            createButton.enabled = setStatusCreateButton(total.textValue , price.textValue)
        }

        onTextValueChanged: createButton.enabled = setStatusCreateButton(total.textValue, price.textValue)
    }

    DapButton
    {
        id: createButton
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
            var walletResult = walletModule.isCreateOrder(dexModule.networkPair, amount.textValue, amount.textToken)
            console.log("Wallet: " + walletResult)
            if(walletResult == "OK")
            {
                var createOrder = dexModule.tryCreateOrder(isSell, price.textValue, amount.textValue, walletModule.getFee(dexModule.networkPair).validator_fee)
                console.log("Order: " + createOrder)
            }
        }
    }

    Item{
        Layout.fillHeight: true
    }

    Component.onDestruction:
    {
        dexModule.setCurrentPrice("")
    }

    Connections
    {
        target: dexModule

        function onCurrentTokenPairChanged()
        {
            price.textValue = "0.0"
            updateTokensField()
            updateForms()
        }

        function onCurrentTokenPairInfoChanged()
        {
            if(price.textValue === "0.0")
            {
                price.textValue = dexModule.currentRate
            }
        }
    }

    function updateTokensField()
    {
        if(!isSell)
        {
            price.textToken = dexModule.token2
            amount.textToken = dexModule.token2
            total.textToken = dexModule.token1
        }
        else
        {
            price.textToken = dexModule.token2
            amount.textToken = dexModule.token1
            total.textToken = dexModule.token2
        }
    }

    function updateForms()
    {
        total.textValue = ""
        amount.textValue = ""
        createButton.enabled = setStatusCreateButton(total.textValue, dexModule.currentRate)
        button25.selected = false
        button50.selected = false
        button75.selected = false
        button100.selected = false
    }

}

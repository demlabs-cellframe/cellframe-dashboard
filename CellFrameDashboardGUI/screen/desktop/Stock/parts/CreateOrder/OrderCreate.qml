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
    property bool isToken: false
    signal sellBuyChanged()

    Component.onCompleted:
    {
        walletModule.startUpdateFee()
    }

    Component.onDestruction:
    {
        walletModule.stopUpdateFee()
    }

    Connections
    {
        target: dapServiceController

        function onRcvXchangeCreate(rcvData)
        {
            logicStock.resultCreate = rcvData
            goToDoneCreate()
        }

        function onRcvXchangeOrderPurchase(rcvData)
        {
            logicStock.resultCreate = rcvData
            goToDoneCreate()
        }
    }


    Item
    {

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

    ScrollView
    {
        id: scrollView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 50

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        clip: true

        contentData:
            ColumnLayout
        {
            width: scrollView.width
            spacing: 0

            TwoTextBlocks
            {
                id: textBalance
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.topMargin: 10
                label: qsTr("Balance:")
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
                        fields.updateTokensField()
                        fields.updateForms()
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
                    fields.price.textValue = "0.0"
                    fields.updateTokensField()
                    fields.updateForms()
                }

                function onCurrentTokenPairInfoChanged()
                {
                    if(fields.price.textValue === "0.0")
                    {
                        fields.price.textValue = dexModule.currentRate
                    }
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
                        fields.price.textValue = dexModule.currentRate
                        fields.show("CREATE_ORDER", "LIMIT")
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
                        fields.price.textValue = !isSell ? dexModule.invertValue(dexModule.currentRate) : dexModule.currentRate
                        fields.show("CREATE_ORDER", "MARKET")
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
                        fields.price.textToken = logicStock.unselectedTokenNameWallet
                        fields.price.textValue = candleChartWorker.currentTokenPrice
                        fields.amount.textToken = logicStock.selectedTokenNameWallet
                        fields.amount.textValue = ""

                        fields.show("CREATE_ORDER", "STOP_LIMIT")
                        currentOrder = "Stop limit"
                    }
                }
            }

            OrderCreateFieldsComponent
            {
                id: fields
                sell: isSell
                Layout.fillWidth: true
                amount.textToken: isSell ? dexModule.token1 : dexModule.token2
                total.textToken: !isSell ? dexModule.token1 : dexModule.token2

                Component.onCompleted:
                {
                    show("CREATE_ORDER", "LIMIT")
                }

                function onCreateBtnClicked()
                {
                    if(fields.limitType === "LIMIT" || fields.limitType === "MARKET")
                    {
                        var walletResult = walletModule.isCreateOrder(dexModule.networkPair, fields.amount.textValue, fields.amount.textToken)
                        console.log("Wallet: " + walletResult)
                        if(walletResult === "OK")
                        {
                            var createOrder = dexModule.tryCreateOrder(fields.sell, fields.price.textValue, fields.amount.textValue, walletModule.getFee(dexModule.networkPair).validator_fee)
                            console.log("Order: " + createOrder)
                        }
                        else
                        {
                            messageText.text = walletResult
                        }
                    }
                }
                Connections
                {
                    target: fields
                    function onPercentButtonClicked(percent)
                    {
                        var resBalance
                        if(isToken)
                        {
                            var network = walletModule.getFee(dexModule.networkPair).network_fee
                            var validator = walletModule.getFee(dexModule.networkPair).validator_fee
                            resBalance = dexModule.minusCoins(fields.balance, validator)
                            resBalance = dexModule.minusCoins(resBalance, network)
                        }
                        else
                        {
                            resBalance = fields.balance
                        }

                        var result = logicStock.getPercentBalance(resBalance, percent, fields.price.textValue, isSell)
                        fields.amount.textElement.setText(isSell ? result[0] : result[1])
                        fields.total.textElement.setText(isSell ? result[1] : result[0])
                    }
                }
            }
        }
    }
    function setBalanceText(token)
    {
        var value = walletModule.getBalanceDEX(token)
        fields.balance = value
        textBalance.text = value + " " + token
        logicStock.currantBalance = value
        logicStock.currantToken = value
        var tokenFee = walletModule.getFee(dexModule.networkPair).fee_ticker
        isToken = tokenFee === token
    }
}


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

    property string currantRate: ""
    property bool isInvert: false

    property var messageRectColor: currTheme.orange

    onCurrantRateChanged:
    {
        miniRateFieldUpdate()
    }

    ListModel
    {
        id: ordersRateType

        ListElement
        {
            name: qsTr("Limit")
            techName: "Limit"
        }
        ListElement
        {
            name: qsTr("Market")
            techName: "Market"
        }
    }

    Item
    {
        id: whileLoadingNodePanel
        anchors.fill: parent
        anchors.topMargin: tabsView.height
        anchors.bottomMargin: createButton.implicitHeight + 40
        z: parent.z + 10

        DapLoadingPanel
        {
            mainColor: "transparent"
            secondColor: "transparent"
        }
    }

    ColumnLayout
    {
        id: layout
        anchors.fill: parent
        spacing: 12

        ListView
        {
            id: tabsView
            Layout.fillWidth: true

            orientation: ListView.Horizontal
            model: ordersRateType
            interactive: false
            height: 42
            currentIndex: 0
            onCurrentIndexChanged:
            {
                dexModule.orderType = ordersRateType.get(currentIndex).techName

                ordersModule.currentTab = currentIndex
                setCurrentRate(dexModule.currentRate)
                updateBuyField()
                rateRectagleTextUpdate()
            }

            delegate:
                Item{
                property int textWidth: tabName.implicitWidth
                property int spacing: 16
                height: 42
                width: textWidth + spacing * 2

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: tabsView.currentIndex = index
                }

                Text{
                    id: tabName
                    anchors.centerIn: parent
                    height: parent.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    color: tabsView.currentIndex === index ? currTheme.white : currTheme.gray
                    font:  mainFont.dapFont.medium14
                    text: name

                    Behavior on color {ColorAnimation{duration: 200}}
                }
            }

            Rectangle
            {
                anchors.top: parent.bottom
                anchors.topMargin: -3
                width: tabsView.currentItem.width
                height: 2

                radius: 8
                x: tabsView.currentItem.x
                color: currTheme.lime

                Behavior on x {NumberAnimation{duration: 200}}
                Behavior on width {NumberAnimation{duration: 200}}
            }

            Component.onCompleted: {
                tabsView.currentIndex = findIndexByTechName(dexModule.orderType)
            }
        }

        Item
        {
            property int spaceMargin: 12

            id: rectanglesItem
            Layout.fillWidth: parent
            Layout.rightMargin: 15
            Layout.leftMargin: 15
            Layout.topMargin: 8
            height: payRect.height + receiveRect.height + priceRect.height + expiresRect.height + 3 * rectanglesItem.spaceMargin

            // "You pay" field
            Rectangle
            {
                id: payRect
                height: 76
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                color: currTheme.mainBackground
                radius: 4
                border.color: currTheme.input
                border.width: 1

                Item
                {
                    anchors.fill: parent
                    anchors.margins: 12

                    Text
                    {
                        id: youPayText
                        height: 16
                        anchors.left: parent.left
                        anchors.top: parent.top
                        text: qsTr("You pay")
                        font: mainFont.dapFont.regular11
                        color: currTheme.lightGray
                    }

                    DapBalanceComponent
                    {
                        id: textBalance
                        height: 16
                        anchors.left: youPayText.right
                        anchors.top: parent.top
                        anchors.right: maxBtn.left
                        anchors.leftMargin: 4
                        anchors.rightMargin: 4
                        label: qsTr("Balance:")
                        textColor: currTheme.white
                        textFont: mainFont.dapFont.regular11
                        text: dexModule.getBalance(dexModule.token1)
                    }

                    Rectangle
                    {
                        id: maxBtn
                        anchors.right: parent.right
                        anchors.top: parent.top
                        color: maxBtnMouseArea.containsMouse ? currTheme.lightGreen2 : currTheme.darkGreen
                        height: 16
                        width: 32
                        radius: 4

                        Text {
                            anchors.fill: parent
                            text: qsTr("MAX")
                            font: mainFont.dapFont.regular12
                            color: currTheme.lime
                            horizontalAlignment: Qt.AlignHCenter
                        }

                        MouseArea
                        {
                            id: maxBtnMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked:
                            {
                                var network = walletModule.getFee(dexModule.networkPair).network_fee
                                var validator = walletModule.getFee(dexModule.networkPair).validator_fee
                                var resBalance = dexModule.minusCoins(textBalance.text, validator)
                                resBalance = dexModule.minusCoins(resBalance, network)
                                sellText.text = resBalance
                                updateBuyField()
                            }
                        }
                    }

                    Item
                    {
                        id: tokenPay
                        anchors.bottom: parent.bottom
                        anchors.left:  parent.left
                        width: textTokenName.width + imageArrow.width
                        height: 24

                        Text
                        {
                            id: textTokenName
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            font: mainFont.dapFont.medium20
                            text: dexModule.token1
                            color: currTheme.white
                            verticalAlignment: Qt.AlignBottom
                        }
                        Image
                        {
                            id: imageArrow
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 24
                            height: 24
                            source: "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_down_rect.svg"
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                dexModule.setTypeListToken("sell")
                                goToTokensList()
                            }
                        }
                    }

                    DapOrderTextField
                    {
                        id: sellText
                        backgroundColor: currTheme.mainBackground
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.left: tokenPay.right
                        anchors.leftMargin: 4
                        anchors.rightMargin: -8
                        anchors.bottomMargin: -7
                        placeholderText: ""
                        validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                        font: mainFont.dapFont.medium20
                        height: 32
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignBottom
                        selectByMouse: true
                        maximumLength: 70
                        DapContextMenu{}

                        onTextChanged:
                        {
                            dexModule.sellValueField = text
                            isFieldOK()
                        }

                        onEdited:
                        {
                            updateBuyField()
                        }
                    }

                    Component.onCompleted:
                    {
                        sellText.text = dexModule.sellValueField
                    }
                }

                DapLoadingPanel
                {
                    radiusEnabled: true
                    radiusPower: parent.radius * 2
                }
            }

            // arrow between
            Item
            {
                width: 32
                height: 32
                anchors.horizontalCenter: parent.horizontalCenter
                y: payRect.y + payRect.height + 6 - height/2
                z: payRect.z + 1

                Image
                {
                    id: animArrowIcon
                    anchors.fill: parent
                    source: arrowMouseArea.containsMouse ? "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_button_hover.svg" : "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_button.svg"

                    Behavior on rotation {NumberAnimation{duration: 100}}
                }

                MouseArea
                {
                    id: arrowMouseArea
                    width: 24
                    height: 24
                    anchors.centerIn: parent
                    hoverEnabled: true

                    onClicked:
                    {
                        swapPair()
                    }

                    onContainsMouseChanged:
                    {
                        animArrowIcon.rotation = containsMouse ? -180 : 0
                    }

                    Connections{
                        target: stockHome
                        function onRegularPairSwap(){
                            arrowMouseArea.swapPair()
                        }
                    }

                    function swapPair()
                    {
                        setCurrentRate(dexModule.invertValue(currantRate))
                        sellText.setText(buyText.text)
                        dexModule.swapTokens();
                    }
                }
            }

            // "You receive" field
            Rectangle
            {
                id: receiveRect
                height: 76
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: payRect.bottom
                anchors.topMargin: rectanglesItem.spaceMargin
                color: currTheme.mainBackground
                radius: 4
                border.color: currTheme.input
                border.width: 1

                Item
                {
                    anchors.fill: parent
                    anchors.margins: 12

                    Text
                    {
                        id: youReceiveText
                        height: 16
                        anchors.left: parent.left
                        anchors.top: parent.top
                        text: qsTr("You receive")
                        font: mainFont.dapFont.regular11
                        color: currTheme.lightGray
                    }

                    DapBalanceComponent
                    {
                        id: textBalance2
                        height: 16
                        anchors.left: youReceiveText.right
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.leftMargin: 4
                        label: qsTr("Balance:")
                        textColor: currTheme.white
                        textFont: mainFont.dapFont.regular11
                        text: dexModule.getBalance(dexModule.token2)
                    }

                    Item
                    {
                        id: tokenReceive
                        anchors.bottom: parent.bottom
                        anchors.left:  parent.left
                        width: textToken2Name.width + imageArrow2.width
                        height: 24

                        Text
                        {
                            id: textToken2Name
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            font: mainFont.dapFont.medium20
                            text: dexModule.token2
                            color: currTheme.white
                            verticalAlignment: Qt.AlignBottom
                        }
                        Image
                        {
                            id: imageArrow2
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 24
                            height: 24
                            source: "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_down_rect.svg"
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                dexModule.setTypeListToken("buy")
                                goToTokensList()
                            }
                        }
                    }

                    DapOrderTextField
                    {
                        id: buyText
                        backgroundColor: currTheme.mainBackground
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.left: tokenReceive.right
                        anchors.leftMargin: 4
                        anchors.rightMargin: -8
                        anchors.bottomMargin: -7
                        placeholderText: ""
                        validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                        font: mainFont.dapFont.medium20
                        height: 32
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignBottom
                        selectByMouse: true
                        enabled: !dexModule.isMarketType
                        maximumLength: 70

                        DapContextMenu{}

                        onTextChanged:
                        {
                            createButton.enabled = isFieldOK() && modulesController.isNodeWorking
                        }

                        onEdited:
                        {
                            setCurrentRate(dexModule.divCoins(sellText.text, buyText.text))
                            rateRectagleTextUpdate()
                        }
                    }
                }

                DapLoadingPanel
                {
                    radiusEnabled: true
                    radiusPower: parent.radius * 2
                }
            }

            // "Price" field
            Rectangle
            {
                id: priceRect
                visible: !dexModule.isMarketType
                height: dexModule.isMarketType ? 0 : 76
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: receiveRect.bottom
                anchors.topMargin: rectanglesItem.spaceMargin
                color: currTheme.mainBackground
                radius: 4
                border.color: currTheme.input
                border.width: 1

                Item
                {
                    anchors.fill: parent
                    anchors.margins: 12

                    Text
                    {
                        id: rateRectHeader
                        height: 16
                        anchors.left: parent.left
                        anchors.top: parent.top
                        font: mainFont.dapFont.regular11
                        color: currTheme.lightGray
                    }
                    Text
                    {
                        height: 16
                        anchors.right: parent.right
                        anchors.top: parent.top
                        text: qsTr("Set to market")
                        font: mainFont.dapFont.regular11
                        color: currTheme.lime
                        MouseArea
                        {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked:
                            {
                                setCurrentRate(dexModule.currentRate)
                                priceText.setText(dexModule.currentRate)
                                isInvert = false
                                rateRectagleTextUpdate()
                            }
                        }
                    }

                    DapOrderTextField
                    {
                        id: priceText
                        backgroundColor: currTheme.mainBackground
                        anchors.bottom: parent.bottom
                        anchors.left:  parent.left
                        anchors.rightMargin: 4
                        anchors.right: switchButton.left
                        anchors.leftMargin: -8
                        anchors.bottomMargin: -7
                        placeholderText: ""
                        validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                        font: mainFont.dapFont.medium20
                        height: 32
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignBottom
                        selectByMouse: true
                        maximumLength: 70

                        DapContextMenu{}
                        onTextChanged:
                        {
                            updateErrorField(false, getWarning())
                            createButton.enabled = isFieldOK() && modulesController.isNodeWorking
                        }

                        onEdited:
                        {
                            var tmpValue = isInvert ? dexModule.invertValue(priceText.text) : priceText.text
                            var substrings = tmpValue.split('.')
                            var lenghtValue = substrings.length

                            if(tmpValue === "")
                            {
                                tmpValue = "0.0"
                            }
                            else if(lenghtValue === 2)
                            {
                                if(substrings[0] === "" && substrings[1] === "")
                                {
                                    tmpValue = "0.0"
                                }
                                else if(substrings[0] === "")
                                {
                                    tmpValue = "0." + substrings[1]
                                }
                                else if(substrings[1] === "")
                                {
                                    tmpValue = substrings[0] + ".0"
                                }
                            }
                            else if(lenghtValue === 1)
                            {
                                tmpValue = tmpValue = substrings[0] + ".0"
                            }

                            setCurrentRate(tmpValue)
                            updateBuyField()
                        }
                    }
                    Rectangle
                    {
                        id: switchButton
                        width: tokenSwitch.contentWidth + imageArrows.width + 6
                        height: 16
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        color:  priceMouseArea.containsMouse ? currTheme.tokenChangeButtonHover : currTheme.tokenChangeButton
                        radius: 4
                        Text
                        {
                            id: tokenSwitch
                            height: parent.height
                            text: isInvert ? dexModule.token2 : dexModule.token1
                            anchors.left: parent.left
                            anchors.leftMargin: 3
                            font: mainFont.dapFont.medium12
                            color: currTheme.inputActive
                            verticalAlignment: Text.AlignVCenter
                        }
                        Image
                        {
                            id: imageArrows
                            width: 16
                            height: 16
                            anchors.right: parent.right
                            anchors.rightMargin: 3
                            source: "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_left_right.svg"
                        }
                        MouseArea
                        {
                            id: priceMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked:
                            {
                                isInvert = !isInvert
                                rateRectagleTextUpdate()
                                console.log("change tokens clicked")
                            }
                        }
                    }
                }
                Component.onCompleted: {
                    setCurrentRate(dexModule.currentRate)
                    priceText.setText(dexModule.currentRate)
                    isInvert = false
                    rateRectagleTextUpdate()
                }

                DapLoadingPanel
                {
                    radiusEnabled: true
                    radiusPower: parent.radius * 2
                }
            }

            // "Expires" field
            Rectangle
            {
                id: expiresRect
                visible: false
                height: 0//76
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: priceRect.bottom
                anchors.topMargin: rectanglesItem.spaceMargin
                color: currTheme.mainBackground
                radius: 4
                border.color: currTheme.input
                border.width: 1
                opacity: 0.4

                Item
                {
                    anchors.fill: parent
                    anchors.margins: 12
                    Text
                    {
                        id: expiresLabelText
                        height: 16
                        anchors.left: parent.left
                        anchors.top: parent.top
                        text: qsTr("Expires in")
                        font: mainFont.dapFont.regular11
                        color: currTheme.lightGray
                    }
                    Item {
                        width: 16
                        height: 16
                        anchors.left: expiresLabelText.right
                        anchors.leftMargin: 2
                        anchors.top: parent.top

                        Image
                        {
                            id: orderIcon
                            anchors.fill: parent
                            mipmap: true
                            source: "qrc:/Resources/"+ pathTheme +"/icons/other/ic_info_small.svg"
                        }

                        DapCustomToolTip
                        {
                            contentText: qsTr("Come back later")
                            visible: i_tooltipMouseArea.containsMouse
                        }

                        MouseArea
                        {
                            id: i_tooltipMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }

                    Item
                    {
                        height: 24
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        Text
                        {
                            text: qsTr("7 Days")
                            anchors.left: parent.left
                            anchors.right: imageArrow3.left
                            anchors.rightMargin: 4
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            font: mainFont.dapFont.medium20
                            color: currTheme.white
                            horizontalAlignment: Text.AlignLeft
                        }
                        Image
                        {
                            id: imageArrow3
                            width: 24
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            height: 24
                            source: "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_down_rect.svg"
                        }
                        MouseArea
                        {
                            id: expiresMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked:
                            {
                                console.log("select expires clicked")
                            }
                        }
                    }
                }

                DapLoadingPanel
                {
                    radiusEnabled: true
                    radiusPower: parent.radius * 2
                }
            }

            Rectangle
            {
                id: resultPriceRect
                height: 40
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: expiresRect.bottom
                color: currTheme.mainBackground
                radius: 4

                RowLayout
                {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 0

                    Text
                    {
                        id: miniRateText
                        font: mainFont.dapFont.medium18
                        color: currTheme.white
                        verticalAlignment: Qt.AlignVCenter
                    }

                    DapBigText
                    {
                        id: miniRateText2
                        textElement.horizontalAlignment: Text.AlignLeft
                        Layout.fillWidth: true
                        height: 20
                        horizontalAlign: Qt.AlignLeft
                        textFont: mainFont.dapFont.medium18
                    }
                }

                Component.onCompleted: {
                    miniRateFieldUpdate()
                }

                DapLoadingPanel
                {
                    radiusEnabled: true
                    radiusPower: parent.radius * 2
                }
            }

            // Error message
            Item
            {
                id: errorMsgRect
                height: textError.contentHeight + 24
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: resultPriceRect.bottom
                anchors.topMargin: 12
                visible: false
                Rectangle
                {

                    anchors.fill: parent
                    color: "transparent"
                    radius: 4
                    border.width: 1
                    border.color: messageRectColor
                }

                Rectangle
                {
                    anchors.fill: parent
                    color: messageRectColor
                    opacity: 0.12
                    radius: 4
                }

                Text
                {
                    id: textError
                    width: errorMsgRect.width
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 12
                    font: mainFont.dapFont.regular11
                    color: currTheme.orange
                    // text: qsTr("Limit price is 100% lower than the market. You will be selling your USDT exceedingly cheap.")
                    wrapMode: Text.WordWrap
                    lineHeight: 16
                    lineHeightMode: Text.FixedHeight
                    elide: Text.ElideRight
                }

                DapLoadingPanel
                {
                    radiusEnabled: true
                    radiusPower: parent.radius * 2
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        // CREATE BUTTON
        DapButton
        {
            id: createButton
            Layout.alignment: Qt.AlignCenter
            Layout.bottomMargin: 40
            implicitHeight: 36
            implicitWidth: 318
            textButton: qsTr("Create order")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            enabled: modulesController.isNodeWorking
            onClicked:
            {
                var resultAmount = sellText.text
                var resultTokenName = dexModule.token1
                var walletResult = dexModule.isCreateOrder(dexModule.networkPair, resultAmount, resultTokenName)
                console.log("Wallet: " + walletResult)

                if(walletResult.code === 0)
                {
                    var createOrder = dexModule.tryCreateOrderRegular(currantRate, resultAmount, walletModule.getFee(dexModule.networkPair).validator_fee)
                    console.log("Order: " + createOrder)
                }
                else
                {
                    var message = ""
                    switch(walletResult.code) {
                        case 1:
                            message = qsTr("Error, network not found")
                            updateErrorField(true, message)
                            break
                        case 2:
                            message = qsTr(" There are not enough tokens available. Not enough to pay the network usage fee. Fee = %1. Current value = %2")
                            .arg(walletResult.firstValue).arg(walletResult.secondValue)
                            updateErrorField(true, message)
                            break
                        case 3:
                            message = qsTr(" There are not enough tokens available. Not enough to pay the fee. Fee = %1. Current value = %2")
                            .arg(walletResult.firstValue).arg(walletResult.secondValue)
                            updateErrorField(true, message)
                            break
                        case 4:
                            message = qsTr("There are not enough tokens available, taking into account all commissions. Necessary = %1. Available = %2.")
                            .arg(walletResult.firstValue).arg(walletResult.secondValue)
                            updateErrorField(true, message)
                            break
                        default:
                            break
                    }
                }
            }
        }
    }

    function rateRectagleTextUpdate()
    {
        var token = isInvert ? dexModule.token2 : dexModule.token1
        rateRectHeader.text = qsTr("Pay ") + token + qsTr(" at rate")
        tokenSwitch.text = isInvert ? dexModule.token1 : dexModule.token2
        var text = isInvert ? dexModule.invertValue(currantRate) : currantRate
        priceText.setText(text)
        if(!buyText.activeFocus) updateBuyField()
    }

    function miniRateFieldUpdate()
    {
        miniRateText.text = "1 " + dexModule.token1 + " = "
        miniRateText2.fullText = toActualRate(currantRate) + " " + dexModule.token2
    }

    function updateBuyField()
    {
        buyText.setText(dexModule.divCoins(sellText.text, currantRate))
    }

    function findIndexByTechName(techName)
    {
        for (var i = 0; i < ordersRateType.count; i++) {
            if (ordersRateType.get(i).techName === techName) {
                return i;
            }
        }
    }

    function updateErrorField(isErrorCheck, message)
    {
        if(!isErrorCheck)
        {
            if(message !== "")
            {
                messageRectColor = currTheme.orange
                errorMsgRect.visible = true
                textError.text = message
            }
            else
            {
                errorMsgRect.visible = false
            }
        }
        else
        {
            messageRectColor = currTheme.red
            errorMsgRect.visible = true
            textError.text = message
        }
    }

    function getWarning()
    {
        var result = "";
        if(isOKValue(currantRate))
        {
            var percent = dexModule.getDeltaRatePercent(currantRate)
            var isLow = percent.substring(0,1) === "-"
            percent = percent.substring(1)
            var persentInt = parseInt(percent)
            if(persentInt > 20)
            {
                var level = isLow ? qsTr("higher") : qsTr("lower")
                var costStr = isLow ? qsTr("cheap") : qsTr("expensive")

                result = qsTr("Limit price is ")  + percent + "% " + level + qsTr(" than the market. You will be selling your ") + dexModule.token1 + qsTr(" exceedingly ") + costStr
            }
        }

        if(dexModule.token1.substring(0,1)==="m")
        {
            result = qsTr("Warning! To unstake you need to have the exact amount of cell in the wallet you staked.")
        }

        return result;
    }

    function isFieldOK()
    {
        if(isOKValue(priceText.text) && isOKValue(buyText.text) && isOKValue(sellText.text))
        {
            return true
        }
        return false
    }

    function isOKValue(value)
    {
        if(!isNaN(parseFloat(value)))
        {
            if (parseFloat(value) > 0) return true
        }
        return false;
    }

    function toActualRate(rate)
    {
        return isInvert ? rate : dexModule.invertValue(rate)
    }

    function setCurrentRate(rate)
    {
        currantRate = rate
    }

    Connections
    {
        target: dexModule

        function onCurrentTokenPairChanged()
        {
            if(!dexModule.isSwapTokens)
            {
                setCurrentRate(dexModule.currentRate)
                priceText.setText(dexModule.currentRate)
            }
            else
            {
                dexModule.isSwapTokens = false;
            }
            isInvert = false
            rateRectagleTextUpdate()
            miniRateFieldUpdate()
            updateBuyField()

            updateErrorField(false, getWarning())
        }

        function onCurrentRateFirstTime()
        {
            setCurrentRate(dexModule.currentRate)
            rateRectagleTextUpdate()
            miniRateFieldUpdate()
            updateBuyField()
        }
    }
}


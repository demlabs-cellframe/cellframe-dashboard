import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../DapPairComboBox"
import "../../../controls"

Item
{
    id: root
    property real roundValue: 1000000
    property alias tokenPriceText: tokenPriceText

    property alias candleLogic: chartItem.candleLogic

    property real volume24h: 0.0

    Component.onCompleted:
    {
    }

    ListModel {
        id: selectorModel
        ListElement {
            name: qsTr("1m")
        }
        ListElement {
            name: qsTr("2m")
        }
        ListElement {
            name: qsTr("5m")
        }
        ListElement {
            name: qsTr("15m")
        }
        ListElement {
            name: qsTr("30m")
        }
        ListElement {
            name: qsTr("1h")
        }
        ListElement {
            name: qsTr("4h")
        }
        ListElement {
            name: qsTr("12h")
        }
        ListElement {
            name: qsTr("24h")
        }
        ListElement {
            name: qsTr("7D")
        }
        ListElement {
            name: qsTr("14D")
        }
        ListElement {
            name: qsTr("1M")
        }
    }

    ListModel {
        id: typePanelModel
        ListElement {
            name: qsTr("Regular mode")
            workName: "regular"
        }
        ListElement {
            name: qsTr("Advanced mode")
            workName: "advanced"
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 24

            DapCustomComboBox
            {
                id: comboboxNetwork
                width: 100
                implicitHeight: 24
                delegateHeight: 40
                popupWidth: width + leftMarginPopupContain + rightMarginPopupContain
                popupBorderWidth: 0

                anchors.left: parent.left

                leftMarginDisplayText: 0
                rightMarginIndicator: 0
                leftMarginPopupContain: 16
                rightMarginPopupContain: 16

                isHighlightDisplayTextPopup: true
                isSingleColor: true
                backgroundColorShow: currTheme.secondaryBackground
                backgroundColorNormal: currTheme.secondaryBackground

                model: dexNetModel
                mainTextRole: "name"
                font: mainFont.dapFont.medium14

                Component.onCompleted:
                {
                    if(comboboxNetwork.displayText !== dexModule.networkPair)
                    {
                        comboboxNetwork.displayText = dexModule.networkPair
                    }
                }

                onModelChanged:
                {
                    if(count > 0)
                    {
                        var f_network = dexModule.networkFilter
                        for(var i = 0; i < model.count; i++)
                        {
                            if(f_network === model.get(i).name)
                            {
                                setCurrentIndex(i)
                                return
                            }
                        }
                    }
                }

                onCountChanged:
                {
                    if(count > 0 && currentIndex < 0)
                    {
                        if(dexModule.networkPair !== "")
                        {
                            for(var i = 0; i < model.count; i++)
                            {
                                if(dexModule.networkPair=== model.get(i).name)
                                {
                                    setCurrentIndex(i)
                                    return
                                }
                            }
                        }
                        else
                        {
                            setCurrentIndex(0)
                        }
                    }
                }

                onItemSelected:
                {
                    dexModule.networkFilter = displayText
                }

                defaultText: qsTr("Networks")

                Connections
                {
                    target: dexModule

                    function onDexNetListChanged()
                    {
                        comboboxNetwork.model = dexNetModel;
                        var oldNetwork = comboboxNetwork.displayText
                        var isFound = false
                        for(var i=0; i<dexNetModel.count; ++i)
                        {
                            if(dexNetModel.get(i).name === oldNetwork)
                            {
                                isFound = true
                                break
                            }
                        }
                        if(!isFound)
                        {
                            if(dexNetModel.count > 0) comboboxNetwork.setCurrentIndex(0)
                        }
                    }

                    function onNetworkFilterChanged(network)
                    {
                        comboboxNetwork.displayText = network
                        var pair = modelTokenPair.getFirstItem()
                        dexModule.setCurrentTokenPair(pair, comboboxNetwork.displayText)
                    }
                }

                DapLoadingPanel
                {
                    radiusEnabled: true
                }
            }

            DapPairComboBox
            {
                id: pairBox
                width: 137
                implicitHeight: 24
                anchors.left: comboboxNetwork.right
                anchors.leftMargin: 16

                searchVisible: !dexModule.isRegularTypePanel
                model: dexModule.isRegularTypePanel ? modelTokenPairRegular : modelTokenPair

                onCurrentIndexChanged:
                {
                    dexModule.updateBalance()
                }

                Component.onCompleted:
                {
                    dexTokenModel.setNewPairFilter(dexModule.token1, dexModule.token2, dexModule.networkPair)
                    dexModule.updateBalance()
                }

                onPairClicked:
                {
                    if(dexModule.typePanel === "regular")
                    {
                        regularPairSwap()
                    }
                    else
                    {
                        dexModule.setCurrentTokenPair(displayText, network)
                        dexTokenModel.setNewPairFilter(token1, token2, network)
                        dexModule.updateBalance()
                    }

                    pairBox.popup.close()
                }

                DapLoadingPanel
                {
                    radiusEnabled: true
                }
            }

            DapSelector
            {
                id: modeSelector
                height: 24
                anchors.right: parent.right
                textFont: mainFont.dapFont.regular13
                defaultIndex:
                {
                    for(var i = 0; i < typePanelModel.count; i++)
                    {
                        if(typePanelModel.get(i).workName === dexModule.typePanel)
                        {
                            return i
                        }
                    }
                    return 0
                }

                selectorModel: typePanelModel
                selectorListView.interactive: false

                onItemSelected:
                {
                    dexModule.typePanel = typePanelModel.get(modeSelector.currentIndex).workName
                }
            }
        }

        Item
        {
            height: 33
            Layout.topMargin: 16
            Layout.fillWidth: true
            
            Item
            {
                id: rateArea
                width: dexModule.isReadyDataPair ? 240 : 500
                height: 30
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                Text
                {
                    id: textItem
                    height: 30
                    anchors.left: parent.left
                    font: mainFont.dapFont.regular24
                    color: currTheme.white
                    text: dexModule.displayText + ": "
                    verticalAlignment: Qt.AlignVCenter
                }

                DapBigText
                {
                    id: tokenPriceText
                    height: 30
                    anchors.left: textItem.right
                    anchors.right: parent.right
                    textFont: mainFont.dapFont.regular24
                    textColor: currTheme.green
                    textElement.elide: Text.ElideRight
                    fullText: dexModule.isReadyDataPair ? dexModule.currentRate
                                                        : "Preparing data..."
                }
            }

            Item
            {
                id: hightArea
                width: 55
                height: 33
                anchors.left: rateArea.right
                anchors.leftMargin: 37
                visible: dexModule.isReadyDataPair

                Text
                {
                    font: mainFont.dapFont.regular12
                    color: currTheme.gray
                    text: qsTr("24h Hight")
                    anchors.left: parent.left
                    anchors.top: parent.top
                }

                DapBigText
                {
                    id: max24hText
                    height: textElement.contentHeight
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    textElement.elide: Text.ElideRight
                    textFont: mainFont.dapFont.regular13
                    fullText: candleChartWorker.maximum24h
                }
            }

            Item
            {
                id: lowArea
                width: 55
                height: 33
                anchors.left: hightArea.right
                anchors.leftMargin: 40
                visible: dexModule.isReadyDataPair

                Text
                {
                    font: mainFont.dapFont.regular12
                    color: currTheme.gray
                    text: qsTr("24h Low")
                    anchors.left: parent.left
                    anchors.top: parent.top
                }

                DapBigText
                {
                    id: min24hText
                    height: textElement.contentHeight
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    textElement.elide: Text.ElideRight
                    textFont: mainFont.dapFont.regular13
                    fullText: candleChartWorker.minimum24h
                }
            }

            Item
            {
                id: volumeArea
                width: 60
                height: 33
                visible: false
                anchors.left: lowArea.right
                anchors.leftMargin: 40

                Text
                {
                    font: mainFont.dapFont.medium12
                    color: currTheme.gray
                    text: qsTr("24h Volume")
                    anchors.left: parent.left
                    anchors.top: parent.top
                }

                DapBigText
                {
                    height: textElement.contentHeight
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    textElement.elide: Text.ElideRight
                    textFont: mainFont.dapFont.regular13
                    fullText: volume24h.toFixed(4) + " " + tokenPairsWorker.tokenBuy
                }
            }

            Item
            {
                width: 60
                height: 33
                visible: false
                id: changeArea
                anchors.left: volumeArea.right
                anchors.leftMargin: 40

                Text
                {
                    font: mainFont.dapFont.medium12
                    color: currTheme.gray
                    text: qsTr("24h Change")
                    anchors.left: parent.left
                    anchors.top: parent.top
                }

                DapBigText
                {
                    height: textElement.contentHeight
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    textElement.elide: Text.ElideRight
                    textFont: mainFont.dapFont.regular13
                    textColor: fullText.indexOf("+") >= 0 ? currTheme.green : fullText.indexOf("-") >= 0 ? currTheme.red : currTheme.white
                    fullText: "+4.32%"
                }
            }

            DapLoadingPanel
            {
                radiusEnabled: true
            }
        }

        DapSelector
        {
            Layout.topMargin: 16
            height: 32
            defaultIndex: dexModule.stepChart
            selectorModel: selectorModel
            selectorListView.interactive: false
            textFont: mainFont.dapFont.regular14

            onItemSelected:
            {
                chartItem.setCandleSize(currentIndex)
                dexModule.setStepChart(currentIndex)
            }

            Component.onCompleted:
            {
                chartItem.setCandleSize(currentIndex)
            }
        }

        CandleChart
        {
            id: chartItem
            Layout.topMargin: 5
            Layout.fillWidth: true
            Layout.fillHeight: true

            candleLogic.onChandleSelected:
            {
                var date = new Date(timeValue)

                textDate.text = date.toLocaleString(Qt.locale("en_EN"), "yyyy/MM/dd hh:mm")
                openValue !== undefined ? textOpen.text = openValue : textOpen.text = "0.0"//.toFixed(roundPower)
                openValue !== highValue ? textHigh.text = highValue : textHigh.text = "0.0"//.toFixed(roundPower)
                openValue !== lowValue ? textLow.text = lowValue : textLow.text = "0.0"//.toFixed(roundPower)
                openValue !== closeValue ? textClose.text = closeValue : textClose.text = "0.0"//.toFixed(roundPower)

                if (openValue > 0.0000000000000000001)
                {
                    var change = closeValue/openValue*100 - 100
                    if (change > -0.000001 && change < 0.000001)
                        textChange.text = "0%"
                    else
                    if (change > -0.00001 && change < 0.00001)
                        textChange.text = change.toFixed(8) + "%"
                    else
                    if (change > -0.001 && change < 0.001)
                        textChange.text = change.toFixed(6) + "%"
                    else
                    if (change > -0.1 && change < 0.1)
                        textChange.text = change.toFixed(4) + "%"
                    else
                        textChange.text = change.toFixed(2) + "%"
                }
                else
                    textChange.text = "0%"

                if (openValue > closeValue)
                {
                    textOpen.textColor = currTheme.red
                    textHigh.textColor = currTheme.red
                    textLow.textColor = currTheme.red
                    textClose.textColor = currTheme.red
                    textChange.textColor = currTheme.red
                }
                else
                {
                    textOpen.textColor = currTheme.green
                    textHigh.textColor = currTheme.green
                    textLow.textColor = currTheme.green
                    textClose.textColor = currTheme.green
                    textChange.textColor = currTheme.green
                }
            }

            DapLoadingPanel
            {
                visible: !dexModule.isReadyDataPair
                spinerEnabled:  app.getNodeMode() === 0 ? cellframeNodeWrapper.nodeRunning : false
            }
        }
    }

    Rectangle
    {
        parent: chartItem
        x: 0
        y: 16
        width: childrenRect.width
        height: childrenRect.height
        color: "#a0363A42"

        Component.onCompleted:
        {
            candleLogic.topInfoTextField = y
            candleLogic.bottomInfoTextField = y + 16
        }

        Item
        {
            anchors.fill: parent
            z: parent.z + 1

            ChartTextBlock
            {
                id: textDate
                width: 110
                anchors.left: parent.left
                labelVisible: false
                textFont: mainFont.dapFont.regular13
                text: "-"
                textColor: currTheme.gray
            }
            ChartBigTextBlock
            {
                id: textOpen
                width: 80
                anchors.left: textDate.right
                anchors.leftMargin: 16
                label: qsTr("Open: ")
                text: "-"
                fontComponent: mainFont.dapFont.regular13
            }
            ChartBigTextBlock
            {
                id: textHigh
                width: 80
                anchors.left: textOpen.right
                anchors.leftMargin: 16
                label: qsTr("High: ")
                text: "-"
                fontComponent: mainFont.dapFont.regular13
            }
            ChartBigTextBlock
            {
                id: textLow
                width: 80
                anchors.left: textHigh.right
                anchors.leftMargin: 16
                label: qsTr("Low: ")
                text: "-"
                fontComponent: mainFont.dapFont.regular13
            }
            ChartBigTextBlock
            {
                id: textClose
                width: 80
                anchors.left: textLow.right
                anchors.leftMargin: 16
                label: qsTr("Close: ")
                text: "-"
                fontComponent: mainFont.dapFont.regular13
            }
            ChartTextBlock
            {
                id: textChange
                width: 80
                anchors.left: textClose.right
                anchors.leftMargin: 16
                label: qsTr("Change: ")
                text: "-"
                textFont: mainFont.dapFont.regular13
            }
        }
        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered:
            {
                chartItem.areaCanvas.hoverEnabled = false
            }
            onExited:
            {
                chartItem.areaCanvas.hoverEnabled = true
            }
        }
    }

    Connections
    {
        target: candleChartWorker

        function onChartInfoChanged()
        {
            candleLogic.updateChart()
        }

        // function onCurrentTokenPairChanged()
        // {
        //     updateChart()
        // }
    }

    function updateTokenPrice()
    {
        if (candleChartWorker.currentTokenPrice <
                candleChartWorker.previousTokenPrice)
            tokenPriceText.textColor = currTheme.red
        else
            tokenPriceText.textColor = currTheme.green
    }

}

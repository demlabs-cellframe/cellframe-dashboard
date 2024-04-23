import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "qrc:/widgets"
//import ".."
import "../DapPairComboBox"

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
        anchors.margins: 10
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 0

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 20

            DapCustomComboBox
            {
                id: comboboxNetwork
                Layout.minimumWidth: 100
                leftMarginDisplayText: 0

                height: 32
                popupWidth: 200
                isHighlightDisplayTextPopup: true
                backgroundColorShow: currTheme.secondaryBackground
                backgroundColorNormal: currTheme.secondaryBackground

                isSingleColor: true
                popupBorderWidth: 0

                model: dexNetModel
                mainTextRole: "name"
                font: mainFont.dapFont.medium14

                onModelChanged:
                {
                    if(count > 0) {
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
                    if(count > 0 && currentIndex < 0) setCurrentIndex(0)
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
                        if(!isFound) comboboxNetwork.displayText = "All"
                    }

                    function onNetworkFilterChanged(network)
                    {
                        comboboxNetwork.displayText = network
                        var pair = modelTokenPair.getFirstItem()
                        dexModule.setCurrentTokenPair(pair, comboboxNetwork.displayText)
                    }
                }
            }

            DapPairComboBox
            {
                id: pairBox

                Layout.minimumWidth: 117
                height: 32
                model:modelTokenPair

                onCurrentIndexChanged: {
                    walletModule.updateBalanceDEX()
                }

                Component.onCompleted:
                {
                    dexTokenModel.setNewPairFilter(dexModule.token1, dexModule.token2, dexModule.networkPair)
                    walletModule.updateBalanceDEX()

                }
            }

            RowLayout
            {
                Layout.fillWidth: true
                Text
                {
                    font: mainFont.dapFont.regular13
                    color: currTheme.gray
                    text: qsTr("Total: ")
                }

                Text
                {
                    font: mainFont.dapFont.regular13
                    color: currTheme.white
                    text: "100500" + qsTr(" pairs")
                }
            }


            DapSelector
            {
                Layout.alignment: Qt.AlignRight
                height: 24
                textFont: mainFont.dapFont.regular16
                selectorModel: typePanelModel
                selectorListView.interactive: false
                width: 240
                onItemSelected:
                {
                }

                Component.onCompleted:
                {
                }
            }
        }

        RowLayout
        {
            Layout.topMargin: 16
            Layout.bottomMargin: 8
            spacing: 10
            
            Item
            {
                Layout.alignment: Qt.AlignVCenter
                height: 30
                width: 240
                Text
                {
                    id: textItem
                    height: 30
                    font: mainFont.dapFont.medium24
                    color: currTheme.white
                    text: dexModule.displayText + ":"
                    verticalAlignment: Qt.AlignVCenter
                    
                    topPadding: OS_WIN_FLAG ? 5 : 0
                }

                DapBigNumberText
                {
                    id: tokenPriceText
                    anchors.left: textItem.right
                    // Layout.fillWidth: true
                    height: 30
                    textFont: mainFont.dapFont.medium24
                    textColor: currTheme.green
                    outSymbols: 9
                    fullNumber: dexModule.currentRate
                    copyButtonVisible: false
                }
            }



            /*            Text
            {
                id: tokenPriceText
                font: mainFont.dapFont.medium24
                color: currTheme.textColorGreen
                text: stockDataWorker.currentTokenPrice.
                    toFixed(roundPower)
            }*/
            ColumnLayout
            {
                height: 35

                Text
                {
                    font: mainFont.dapFont.regular12
                    color: currTheme.gray
                    text: qsTr("24h Hight")
                }

                Text
                {
                    id: max24hText
                    font: mainFont.dapFont.regular12
                    color: currTheme.white
                    text: candleChartWorker.maximum24h.toFixed(roundPower)
                }
            }

            ColumnLayout
            {
                height: 35

                Text
                {
                    font: mainFont.dapFont.regular12
                    color: currTheme.gray

                    text: qsTr("24h Low")
                }

                Text
                {
                    id: min24hText
                    font: mainFont.dapFont.regular12
                    color: currTheme.white

                    text: candleChartWorker.minimum24h.toFixed(roundPower)
                }
            }

            ColumnLayout
            {
                height: 35
                visible: false

                Text
                {
                    font: mainFont.dapFont.medium12
                    color: currTheme.gray

                    text: qsTr("24h Volume")
                }

                Text
                {
                    font: mainFont.dapFont.regular12
                    color: currTheme.white

                    text: volume24h.toFixed(2) + " " + tokenPairsWorker.tokenBuy
                }
            }
        }

        DapSelector
        {
            Layout.topMargin: 16
            height: 35
            defaultIndex: dexModule.stepChart
            selectorModel: selectorModel
            selectorListView.interactive: false

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
            Layout.topMargin: 8
            Layout.fillWidth: true
            Layout.fillHeight: true

            candleLogic.onChandleSelected:
            {
                var date = new Date(timeValue)

                textDate.text = date.toLocaleString(Qt.locale("en_EN"), "yyyy/MM/dd hh:mm")
                textOpen.text = openValue//.toFixed(roundPower)
                textHigh.text = highValue//.toFixed(roundPower)
                textLow.text = lowValue//.toFixed(roundPower)
                textClose.text = closeValue//.toFixed(roundPower)

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
        }
    }

    Rectangle
    {
        parent: chartItem
        x: 0
        y: 0
        width: childrenRect.width
        height: childrenRect.height

        color: "#a0363A42"

        RowLayout
        {
            spacing: 10

            ChartTextBlock
            {
                id: textDate
                Layout.preferredWidth: 100
                Layout.fillWidth: true
                labelVisible: false
                text: "-"
                textColor: currTheme.gray
            }

            ChartBigTextBlock
            {
                id: textOpen
                Layout.preferredWidth: 100
                Layout.fillWidth: true
                label: qsTr("Open:")
                text: "-"
            }

            ChartBigTextBlock
            {
                id: textHigh
                Layout.preferredWidth: 95
                Layout.fillWidth: true
                label: qsTr("High:")
                text: "-"
            }
            ChartBigTextBlock
            {
                id: textLow
                Layout.preferredWidth: 90
                Layout.fillWidth: true
                label: qsTr("Low:")
                text: "-"
            }
            ChartBigTextBlock
            {
                id: textClose
                Layout.preferredWidth: 100
                Layout.fillWidth: true
                label: qsTr("Close:")
                text: "-"
            }
            ChartTextBlock
            {
                id: textChange
                Layout.preferredWidth: 100
                Layout.fillWidth: true
                label: qsTr("Change:")
                text: "-"
            }

            MouseArea
            {
                Layout.fillHeight: parent
                Layout.fillWidth: parent
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

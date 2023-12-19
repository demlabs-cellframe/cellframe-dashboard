import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "qrc:/widgets"
//import ".."
import "../DapPairComboBox"

Item
{
    property real roundValue: 1000000
    property alias tokenPriceText: tokenPriceText

    property alias candleLogic: chartItem.candleLogic

    property real volume24h: 0.0

    Component.onCompleted:
    {
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

            DapPairComboBox
            {
                id: pairBox
//                property bool isInit: false
//                property var globalIndex

                Layout.minimumWidth: 184
                height: 32
                model:modelTokenPair

//                onInitModelIsCompleted: {
//                    isInit = true
//                    currentIndex = tokenPairsWorker.currentPairIndex
//                    globalIndex = currentIndex
//                    displayElement = dapPairModel[globalIndex]
//                    updateInfo(globalIndex)
//                }

//                Component.onCompleted:
//                {
//                    logic.setModel(dapPairModel)

//                }
                onCurrentIndexChanged: {

//                    if(isInit)
//                    {
//                        for(var i = 0; i < dapPairModel.length; i++)
//                        {
//                            if(dapPairModel[i].tokenBuy === pairBox.displayElement.tokenBuy &&
//                               dapPairModel[i].tokenSell === pairBox.displayElement.tokenSell)
//                            {
//                                globalIndex = i
//                            }
//                        }

//                        if(globalIndex !== -1)
//                            updateInfo(globalIndex)
//                    }
                }

                function updateInfo(currentIndex)
                {
//                    tokenPairsWorker.currentPairIndex = currentIndex

//                    tokenPairsWorker.setCurrentPairIndex(currentIndex)

//                    // console.log("updateInfo",
//                    //             tokenPairsWorker.currentPairIndex,
//                    //             dapPairModel.length,
//                    //             dapPairModel[currentIndex].tokenBuy,
//                    //             dapPairModel[currentIndex].tokenSell,
//                    //             tokenPairsWorker.tokenBuy,
//                    //             tokenPairsWorker.tokenSell)

//                    candleChartWorker.currentTokenPrice = tokenPairsWorker.tokenPrice
//                    candleChartWorker.currentTokenPriceText = tokenPairsWorker.tokenPriceText
////                    candleChartWorker.currentTokenPrice = dapPairModel[currentIndex].price
////                    candleChartWorker.currentTokenPriceText = dapPairModel[currentIndex].priceText

//                    tokenPairChanged()
                }

                Connections
                {
                    target: tokenPairsWorker
                    // function onPairModelUpdated(dapPairModel)
                    // {
                    //     if(!pairBox.count)
                    //         pairBox.logic.setModel(dapPairModel)
                    //     else
                    //     {
                    //         pairBox.currentIndex = tokenPairsWorker.currentPairIndex
                    //         pairBox.displayElement = dapPairModel[tokenPairsWorker.currentPairIndex]
                    //     }
                    // }
                }
                Component.onCompleted:
                {
                    dexTokenModel.setTokenFilter(dexModule.token1, dexModule.token2)
                    dexTokenModel.setNetworkFilter(dexModule.networkPair)
                }
            }

            ColumnLayout
            {
                height: 35

                Text
                {
                    font: mainFont.dapFont.medium12
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
                    font: mainFont.dapFont.medium12
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

        DapSelector
        {
            Layout.topMargin: 16
            height: 35

            selectorModel: selectorModel
            selectorListView.interactive: false

            onItemSelected:
            {
//                print("onItemSelected", "currentIndex", currentIndex)
                chartItem.setCandleSize(currentIndex)
            }
        }

        RowLayout
        {
            Layout.topMargin: 16
            Layout.bottomMargin: 8
            spacing: 10

            Text
            {
                id: textItem
                height: 30
                font: mainFont.dapFont.medium24
                color: currTheme.white
                text: dexModule.displayText + ":"
                verticalAlignment: Qt.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                topPadding: OS_WIN_FLAG ? 5 : 0
            }

            DapBigNumberText
            {
                id: tokenPriceText
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                height: 30
                textFont: mainFont.dapFont.medium24
                textColor: currTheme.green
                outSymbols: 15
                fullNumber: candleChartWorker.currentTokenPriceText
                copyButtonVisible: true
            }

/*            Text
            {
                id: tokenPriceText
                font: mainFont.dapFont.medium24
                color: currTheme.textColorGreen
                text: stockDataWorker.currentTokenPrice.
                    toFixed(roundPower)
            }*/
        }

        CandleChart
        {
            id: chartItem
            Layout.topMargin: 8
            Layout.fillWidth: true
            Layout.fillHeight: true

            candleLogic.onChandleSelected:
            {
//                print("onChandleSelected",
//                      openValue, highValue, lowValue, closeValue)

                var date = new Date(timeValue)

                textDate.text = date.toLocaleString(Qt.locale("en_EN"), "yyyy/MM/dd hh:mm")
                textOpen.text = openValue.toFixed(roundPower)
                textHigh.text = highValue.toFixed(roundPower)
                textLow.text = lowValue.toFixed(roundPower)
                textClose.text = closeValue.toFixed(roundPower)

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

//                    print("onChandleSelected",
//                          openValue, closeValue, change, textChange.text)
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

            ChartTextBlock
            {
                id: textOpen
                Layout.preferredWidth: 100
                Layout.fillWidth: true
                label: qsTr("Open:")
                text: "-"
            }

            ChartTextBlock
            {
                id: textHigh
                Layout.preferredWidth: 95
                Layout.fillWidth: true
                label: qsTr("High:")
                text: "-"
            }
            ChartTextBlock
            {
                id: textLow
                Layout.preferredWidth: 90
                Layout.fillWidth: true
                label: qsTr("Low:")
                text: "-"
            }
            ChartTextBlock
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
        }
    }

    function updateChart()
    {
        updateTokenPrice()

        candleChartWorker.updateAllModels()

        candleLogic.dataAnalysis()

        chartItem.chartCanvas.requestPaint()
    }

    Connections
    {
        target: dexModule

        function onCurrentTokenPairInfoChanged()
        {
            updateChart()
        }

        function onCurrentTokenPairChanged()
        {
            updateChart()
        }
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

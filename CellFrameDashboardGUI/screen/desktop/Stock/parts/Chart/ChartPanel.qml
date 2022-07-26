import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.4
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
        print("stockDataWorker.maximum24h", stockDataWorker.maximum24h)
        print("stockDataWorker.currentTokenPrice", stockDataWorker.currentTokenPrice)
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 0

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 20

            DapPairComboBox
            {
                property bool isInit: false
                id: pairBox
                Layout.minimumWidth: 190
                height: 32

                onInitModelIsCompleted: {
                    isInit = true
                    currentIndex = logicMainApp.currentIndexPair
                    displayElement = dapPairModel.get(currentIndex)
                }

                Component.onCompleted:
                {
                    logic.setModel(dapPairModel)

                }
                onCurrentIndexChanged: {
                    if(currentIndex !== -1 && isInit)
                        updateInfo(currentIndex)
                }

                function updateInfo(currentIndex)
                {
                    logicMainApp.currentIndexPair = currentIndex
                    logicMainApp.token1Name = dapPairModel.get(currentIndex).token1
                    logicMainApp.token2Name = dapPairModel.get(currentIndex).token2
                    logicMainApp.tokenNetwork = dapPairModel.get(currentIndex).network
                    logicMainApp.tokenPrice = dapPairModel.get(currentIndex).rate
                    logicStock.tokenChange = dapPairModel.get(currentIndex).change

                    stockDataWorker.setTokenPair(logicMainApp.token1Name,
                        logicMainApp.token2Name, logicMainApp.tokenNetwork)

                    tokenPairChanged()
                }

                Connections
                {
                    target: dapMainWindow
                    onModelPairsUpdated:
                    {
                        if(!pairBox.count)
                            pairBox.logic.setModel(dapPairModel)
                        else
                        {
                            pairBox.currentIndex = logicMainApp.currentIndexPair
                            displayElement = dapPairModel.get(logicMainApp.currentIndexPair)
                        }
                    }
                }
            }

            ColumnLayout
            {
                height: 35

                Text
                {
                    font: mainFont.dapFont.medium12
                    color: currTheme.textColorGray
                    text: qsTr("24h Hight")
                }

                Text
                {
                    id: max24hText
                    font: mainFont.dapFont.regular12
                    color: currTheme.textColor
                    text: stockDataWorker.maximum24h.toFixed(roundPower)
                }
            }

            ColumnLayout
            {
                height: 35

                Text
                {
                    font: mainFont.dapFont.medium12
                    color: currTheme.textColorGray

                    text: qsTr("24h Low")
                }

                Text
                {
                    id: min24hText
                    font: mainFont.dapFont.regular12
                    color: currTheme.textColor

                    text: stockDataWorker.minimum24h.toFixed(roundPower)
                }
            }

            ColumnLayout
            {
                height: 35

                Text
                {
                    font: mainFont.dapFont.medium12
                    color: currTheme.textColorGray

                    text: qsTr("24h Volume")
                }

                Text
                {
                    font: mainFont.dapFont.regular12
                    color: currTheme.textColor

                    text: volume24h.toFixed(2) + " " + logicMainApp.token1Name
                }
            }

        }

        ListModel {
            id: selectorModel
            ListElement {
                name: "1m"
            }
            ListElement {
                name: "2m"
            }
            ListElement {
                name: "5m"
            }
            ListElement {
                name: "15m"
            }
            ListElement {
                name: "30m"
            }
            ListElement {
                name: "1h"
            }
            ListElement {
                name: "4h"
            }
            ListElement {
                name: "12h"
            }
            ListElement {
                name: "1D"
            }
            ListElement {
                name: "3D"
            }
            ListElement {
                name: "7D"
            }
            ListElement {
                name: "14D"
            }
            ListElement {
                name: "1M"
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
                font: mainFont.dapFont.medium24
                color: currTheme.textColor
                text: pairBox.displayElement.token1 + "/" + pairBox.displayElement.token2 + ":"
            }

            Text
            {
                id: tokenPriceText
                font: mainFont.dapFont.medium24
                color: currTheme.textColorGreen
                text: stockDataWorker.currentTokenPrice.
                    toFixed(roundPower)
            }
        }

        CandleChart
        {
            id: chartItem
            Layout.topMargin: 9
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
                    textChange.text = (closeValue/openValue*100 - 100).toFixed(4) + "%"
                else
                    textChange.text = "0%"

                if (openValue > closeValue)
                {
                    textOpen.textColor = currTheme.textColorRed
                    textHigh.textColor = currTheme.textColorRed
                    textLow.textColor = currTheme.textColorRed
                    textClose.textColor = currTheme.textColorRed
                    textChange.textColor = currTheme.textColorRed
                }
                else
                {
                    textOpen.textColor = currTheme.textColorGreen
                    textHigh.textColor = currTheme.textColorGreen
                    textLow.textColor = currTheme.textColorGreen
                    textClose.textColor = currTheme.textColorGreen
                    textChange.textColor = currTheme.textColorGreen
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
//        color: "transparent"

        RowLayout
        {
            ChartTextBlock
            {
                id: textDate
                Layout.minimumWidth: 120
                labelVisible: false
                text: "-"
                textColor: currTheme.textColorGray
            }

            ChartTextBlock
            {
                id: textOpen
                Layout.minimumWidth: 100
                label: qsTr("Open:")
                text: "-"
            }

            ChartTextBlock
            {
                id: textHigh
                Layout.minimumWidth: 95
                label: qsTr("High:")
                text: "-"
            }
            ChartTextBlock
            {
                id: textLow
                Layout.minimumWidth: 90
                label: qsTr("Low:")
                text: "-"
            }
            ChartTextBlock
            {
                id: textClose
                Layout.minimumWidth: 100
                label: qsTr("Close:")
                text: "-"
            }
            ChartTextBlock
            {
                id: textChange
                Layout.minimumWidth: 100
                label: qsTr("Change:")
                text: "-"
            }
        }
    }

    Timer
    {
        id: generateTimer
        repeat: true
        interval: 1000
        onTriggered:
        {
            interval = 500 + Math.round(Math.random()*3000)

            stockDataWorker.generateNewPrice()

            stockDataWorker.getMinimumMaximum24h()

            updateTokenPrice()

            stockDataWorker.updateAllModels()

//            stockDataWorker.getCandleModel()

//            stockDataWorker.getAveragedModel()

            candleLogic.dataAnalysis()

            chartItem.chartCanvas.requestPaint()

            volume24h += Math.random()*10
        }
    }

    Connections
    {
        target: stockTab

        onTokenPriceChanged:
        {
            updateTokenPrice()

            stockDataWorker.updateAllModels()

            candleLogic.dataAnalysis()

            chartItem.chartCanvas.requestPaint()

//            volume24h += Math.random()*10
        }
    }


    function updateTokenPrice()
    {
        if (stockDataWorker.currentTokenPrice < stockDataWorker.previousTokenPrice)
            tokenPriceText.color = currTheme.textColorRed
        else
            tokenPriceText.color = currTheme.textColorGreen
    }

}

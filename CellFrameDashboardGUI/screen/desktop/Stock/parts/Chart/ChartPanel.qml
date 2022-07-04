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

    property real volume24h: 923673750.32

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
                id: pairBox
                Layout.minimumWidth: 190
                height: 32
                Component.onCompleted:
                {
                    logicStock.initPairModel()
                    logic.setModel(pairModel)
                    print("pairModel.count", pairModel.count)
                }
                onCurrentIndexChanged: {
                    logicStock.indexPair = currentIndex
                    logicStock.nameTokenPair = pairModel.get(currentIndex).pair.split("/")[1]
                    logicStock.tokenPrice = pairModel.get(currentIndex).price
                    logicStock.tokenChange = pairModel.get(currentIndex).change
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
                    text: dataWorker.maximum24h.toFixed(6)
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

                    text: dataWorker.minimum24h.toFixed(6)
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

                    text: volume24h.toFixed(2) + " " + logicStock.nameTokenPair
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
                print("onItemSelected", "currentIndex", currentIndex)
                chartItem.setCandleSize(currentIndex)
            }
        }

        RowLayout
        {
            Layout.topMargin: 16
            spacing: 10

            Text
            {
                font: mainFont.dapFont.medium24
                color: currTheme.textColor
                text: pairBox.displayElement.pair + ":"
            }

            Text
            {
                id: tokenPriceText
                font: mainFont.dapFont.medium24
                color: currTheme.textColorGreen
                text: dataWorker.currentTokenPrice.
                    toFixed(roundPower)
            }
        }

        RowLayout
        {
            Layout.topMargin: 4
            spacing: 10

            Text
            {
                Layout.fillWidth: true
                font: mainFont.dapFont.medium14
                color: currTheme.textColorGray

//                text: qsTr("May 30, 08:30 AM")
                text: logicStock.getCurrentDate("MMM dd, hh:mm AP")
            }

            Text
            {
                font: mainFont.dapFont.medium14
                color: currTheme.textColorGray

                text: qsTr("AVG Price:")
            }

            Text
            {
                font: mainFont.dapFont.medium14
                color: currTheme.textColor

                text: qsTr("0.24265")
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
                textChange.text = (closeValue/openValue*100 - 100).toFixed(3) + "%"

                if (openValue < closeValue)
                {
                    textOpen.textColor = currTheme.textColorGreen
                    textHigh.textColor = currTheme.textColorGreen
                    textLow.textColor = currTheme.textColorGreen
                    textClose.textColor = currTheme.textColorGreen
                    textChange.textColor = currTheme.textColorGreen
                }
                else
                {
                    textOpen.textColor = currTheme.textColorRed
                    textHigh.textColor = currTheme.textColorRed
                    textLow.textColor = currTheme.textColorRed
                    textClose.textColor = currTheme.textColorRed
                    textChange.textColor = currTheme.textColorRed
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

            dataWorker.generateNewPrice()

            dataWorker.getMinimumMaximum24h()

            updateTokenPrice()

            dataWorker.getCandleModel()

//            logic.resetRightTime()

            candleLogic.dataAnalysis()

            chartItem.chartCanvas.requestPaint()

            volume24h += Math.random()*10
        }
    }

    function updateTokenPrice()
    {
        logicStock.tokenPriceRounded =
                dataWorker.currentTokenPrice.toFixed(roundPower)

        logicStock.tokenPrice = dataWorker.currentTokenPrice
        logicStock.tokenPrevPrice = dataWorker.previousTokenPrice

        if (dataWorker.currentTokenPrice < dataWorker.previousTokenPrice)
            tokenPriceText.color = currTheme.textColorRed
        else
            tokenPriceText.color = currTheme.textColorGreen
    }

}

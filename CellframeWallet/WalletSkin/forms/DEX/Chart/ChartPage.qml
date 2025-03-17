import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import "qrc:/widgets"
import "../../controls"
import "../CreateOrder"
import ".."

Rectangle
{
    color: currTheme.mainBackground

    property real volume24h: 0.0

    ListModel {
        id: selectorModel

        Component.onCompleted:
        {
            initSelectorModel()
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        TokenPanel
        {
            Layout.fillWidth: true
        }

        DapSquareSelector
        {
            Layout.fillWidth: true
            height: 35

            selectorModel: selectorModel

            onItemSelected:
            {
                console.log("onItemSelected",
                    "currentIndex", currentIndex,
                    "width", selectorModel.get(currentIndex).width)
                chartItem.setCandleSize(
                    selectorModel.get(currentIndex).width)
            }
        }

        CandleChart
        {
            id: chartItem
            Layout.fillWidth: true
            Layout.fillHeight: true

//            Component.onCompleted:
//            {
//                setCandleSize(chartItem.candleLogic.minute)

////                candleChartWorker.updateAllModels()

////                candleLogic.dataAnalysis()

////                chartCanvas.requestPaint()
//            }

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

        ButtonPanel
        {
            Layout.fillWidth: true
        }

    }

    Rectangle
    {
        parent: chartItem
        x: 0
        y: 0
        width: parent.width
        height: childrenRect.height

        color: "#a0363A42"

        ColumnLayout
        {
            x: 10
            width: row1.width > row2.width ? row1.width : row2.width
            spacing: -2

            RowLayout
            {
                id: row1

                spacing: 10

                ChartTextBlock
                {
                    id: textDate
                    Layout.preferredWidth: 110
                    Layout.fillWidth: true
                    labelVisible: false
                    text: "-"
                    textColor: currTheme.gray
                }

                ChartTextBlock
                {
                    id: textOpen
                    Layout.preferredWidth: 110
                    Layout.fillWidth: true
                    label: qsTr("Open:")
                    text: "-"
                }

                ChartTextBlock
                {
                    id: textHigh
                    Layout.preferredWidth: 105
                    Layout.fillWidth: true
                    label: qsTr("High:")
                    text: "-"
                }
            }

            RowLayout
            {
                id: row2

                spacing: 10

                ChartTextBlock
                {
                    id: textLow
                    Layout.preferredWidth: 100
                    Layout.fillWidth: true
                    label: qsTr("Low:")
                    text: "-"
                }
                ChartTextBlock
                {
                    id: textClose
                    Layout.preferredWidth: 110
                    Layout.fillWidth: true
                    label: qsTr("Close:")
                    text: "-"
                }
                ChartTextBlock
                {
                    id: textChange
                    Layout.preferredWidth: 110
                    Layout.fillWidth: true
                    label: qsTr("Change:")
                    text: "-"
                }
            }
        }

    }

    Connections{
        target: candleChartWorker
        onCurrentTokenPriceChanged:
        {
//            console.log("candleChartWorker", "onCurrentTokenPriceChanged",
//                        candleChartWorker.currentTokenPriceText)

            chartItem.candleLogic.dataAnalysis()

            chartItem.chartCanvas.requestPaint()
        }
    }

    function initSelectorModel()
    {
        selectorModel.append(
                    { name : qsTr("15s"),
                      width : chartItem.candleLogic.second*15 })
        selectorModel.append(
                    { name : qsTr("1m"),
                      width : chartItem.candleLogic.minute })
        selectorModel.append(
                    { name : qsTr("2m"),
                      width : chartItem.candleLogic.minute*2 })
        selectorModel.append(
                    { name : qsTr("5m"),
                      width : chartItem.candleLogic.minute*5 })
        selectorModel.append(
                    { name : qsTr("15m"),
                      width : chartItem.candleLogic.minute*15 })
        selectorModel.append(
                    { name : qsTr("30m"),
                      width : chartItem.candleLogic.minute*30 })
        selectorModel.append(
                    { name : qsTr("1h"),
                      width : chartItem.candleLogic.hour })
        selectorModel.append(
                    { name : qsTr("2h"),
                      width : chartItem.candleLogic.hour*2 })
        selectorModel.append(
                    { name : qsTr("4h"),
                      width : chartItem.candleLogic.hour*4 })
        selectorModel.append(
                    { name : qsTr("12h"),
                      width : chartItem.candleLogic.hour*12 })
        selectorModel.append(
                    { name : qsTr("24h"),
                      width : chartItem.candleLogic.day })
        selectorModel.append(
                    { name : qsTr("3D"),
                      width : chartItem.candleLogic.day*3 })
        selectorModel.append(
                    { name : qsTr("7D"),
                      width : chartItem.candleLogic.day*7 })
        selectorModel.append(
                    { name : qsTr("14D"),
                      width : chartItem.candleLogic.day*14 })
        selectorModel.append(
                    { name : qsTr("1M"),
                      width : chartItem.candleLogic.day*30 })

        chartItem.setCandleSize(selectorModel.get(0).width)
    }

}

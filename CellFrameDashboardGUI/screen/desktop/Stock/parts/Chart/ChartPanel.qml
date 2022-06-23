import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../DapPairComboBox"

Item
{
    property real roundValue: 1000000

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
                Component.onCompleted: logic.setModel(pairModel)
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
                    font: mainFont.dapFont.regular12
                    color: currTheme.textColor
                    text: qsTr("0.2509")
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
                    font: mainFont.dapFont.regular12
                    color: currTheme.textColor

                    text: qsTr("0.2344")
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

                    text: qsTr("923673.75" + " " + logicStock.nameTokenPair)
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
                font: mainFont.dapFont.medium24
                color: currTheme.textColorGreen
                text: pairBox.displayElement.price
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
                textOpen.text = Math.round(openValue*roundValue)/roundValue
                textHigh.text = Math.round(highValue*roundValue)/roundValue
                textLow.text = Math.round(lowValue*roundValue)/roundValue
                textClose.text = Math.round(closeValue*roundValue)/roundValue
                textChange.text = Math.round(
                    (closeValue/openValue*100 - 100)*10000)/10000 + "%"
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
            spacing: 16

            ChartTextBlock
            {
                id: textDate
                labelVisible: false
                text: qsTr("-")
            }

            ChartTextBlock
            {
                id: textOpen
                label: qsTr("Open:")
                text: qsTr("-")
            }

            ChartTextBlock
            {
                id: textHigh
                label: qsTr("High:")
                text: qsTr("-")
            }
            ChartTextBlock
            {
                id: textLow
                label: qsTr("Low:")
                text: qsTr("-")
            }
            ChartTextBlock
            {
                id: textClose
                label: qsTr("Close:")
                text: qsTr("-")
            }
            ChartTextBlock
            {
                id: textChange
                label: qsTr("Change:")
                text: qsTr("-")
            }
        }
    }
}

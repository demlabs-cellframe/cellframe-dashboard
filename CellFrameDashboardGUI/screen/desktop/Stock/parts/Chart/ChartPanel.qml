import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../DapPairComboBox"

Item
{
    property string tokenName: pairBox.displayElement.pair.split("/")[1]

    ListModel
    {
        id: pairModel
        ListElement
        {
            pair: "CELL/USDT"
            price: "1.6"
            change: "-4.1 %"
        }
        ListElement
        {
            pair: "CELL/BNB"
            price: "9.6"
            change: "+1.86 %"
        }
        ListElement
        {
            pair: "CELL/ETH"
            price: "12.547986"
            change: "+7.44 %"
        }
        ListElement
        {
            pair: "CELL/DAI"
            price: "1.12"
            change: "+2.25 %"
        }
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
                id: pairBox
                Layout.minimumWidth: 190
                height: 32
                Component.onCompleted: logic.setModel(pairModel)
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
                    text: qsTr("6132.2349123")
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

                    text: qsTr("3403.2349123")
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

                    text: qsTr("5694321987.2349123" + " " + tokenName)
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

                text: qsTr("May 30, 08:30 AM")
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

                text: qsTr("3403.2349123")
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

                var roundValue = 100000

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

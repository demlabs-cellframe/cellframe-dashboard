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
                name: "24h"
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
            ListElement {
                name: "3M"
            }
            ListElement {
                name: "1Y"
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

        }
    }

    Rectangle
    {
        parent: chartItem
        x: 0
        y: 0
        width: childrenRect.width
        height: childrenRect.height

        color: "#a0404040"

        RowLayout
        {
            spacing: 5

            ChartTextBlock
            {
                text1.text: qsTr("2022/05/30")
                text2.visible: false
            }

            Text
            {
                font: mainFont.dapFont.regular13
                color: currTheme.textColorGray

                text: qsTr("2022/05/30")
            }

            Text
            {
                Layout.leftMargin: 20
                font: mainFont.dapFont.medium13
                color: currTheme.textColorGray

                text: qsTr("Open:")
            }

            Text
            {
                font: mainFont.dapFont.medium13
                color: currTheme.textColorGreen

                text: qsTr("58.1421")
            }

            Text
            {
                Layout.leftMargin: 20
                font: mainFont.dapFont.medium13
                color: currTheme.textColorGray

                text: qsTr("High:")
            }

            Text
            {
                font: mainFont.dapFont.medium13
                color: currTheme.textColorGreen

                text: qsTr("59.1421")
            }

            Text
            {
                Layout.leftMargin: 20
                font: mainFont.dapFont.medium13
                color: currTheme.textColorGray

                text: qsTr("Low:")
            }

            Text
            {
                font: mainFont.dapFont.medium13
                color: currTheme.textColorGreen

                text: qsTr("57.1421")
            }

            Text
            {
                Layout.leftMargin: 20
                font: mainFont.dapFont.medium13
                color: currTheme.textColorGray

                text: qsTr("Close:")
            }

            Text
            {
                font: mainFont.dapFont.medium13
                color: currTheme.textColorGreen

                text: qsTr("57.1421")
            }

            Text
            {
                Layout.leftMargin: 20
                font: mainFont.dapFont.medium13
                color: currTheme.textColorGray

                text: qsTr("Change:")
            }

            Text
            {
                font: mainFont.dapFont.medium13
                color: currTheme.textColorGreen

                text: qsTr("2.97%")
            }

        }

    }

}

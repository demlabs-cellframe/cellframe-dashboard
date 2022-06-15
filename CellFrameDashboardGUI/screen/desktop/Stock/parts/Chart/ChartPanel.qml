import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../DapPairComboBox"

Rectangle
{
    color: "#404040"

    property string tokenName: "ETH"

/*    ListModel {
        id: pairModel
        ListElement {
            name: "CELL/ETH"
        }
        ListElement {
            name: "CELL/DAI"
        }
        ListElement {
            name: "CELL/USDT"
        }
    }*/

    ListModel
    {
        id: pairModel

        ListElement
        {
            pair: "CELL/KELL"
            price: "1.12"
            change: "+2.25 %"
        }
        ListElement
        {
            pair: "CELL/USDT"
            price: "4.24"
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
            price: "12.547986"
            change: "-5.69 %"
        }
        ListElement
        {
            pair: "CELL/DAI"
            price: "12.547986"
            change: "-5.69 %"
        }
        ListElement
        {
            pair: "CELL/DAI"
            price: "12.547986"
            change: "-5.69 %"
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 20

/*            DapComboBox
            {
                Layout.minimumWidth: 120
                height: 35
                font.pointSize: 10

                model: pairModel
            }*/

            DapPairComboBox
            {
                Layout.minimumWidth: 220
                height: 35
//                anchors.leftMargin: 50
//                anchors.topMargin: 50
//                anchors.left: parent.left
//                anchors.top: parent.top
//                width: 220
//                height: 32
                Component.onCompleted: logic.setModel(pairModel)
            }

            ColumnLayout
            {
                height: 35

                Text
                {
                    font.pointSize: 10
                    color: "gray"

                    text: qsTr("24h Hight")
                }

                Text
                {
                    font.pointSize: 10
                    color: "white"

                    text: qsTr("6132.2349123")
                }
            }

            ColumnLayout
            {
                height: 35

                Text
                {
                    font.pointSize: 10
                    color: "gray"

                    text: qsTr("24h Low")
                }

                Text
                {
                    font.pointSize: 10
                    color: "white"

                    text: qsTr("3403.2349123")
                }
            }

            ColumnLayout
            {
                height: 35

                Text
                {
                    font.pointSize: 10
                    color: "gray"

                    text: qsTr("24h Volume")
                }

                Text
                {
                    font.pointSize: 10
                    color: "white"

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
            height: 35

            selectorModel: selectorModel

            onItemSelected:
            {
                print("onItemSelected", "currentIndex", currentIndex)
            }
        }

        RowLayout
        {
            spacing: 10

            Text
            {
                font.pointSize: 18
                color: "white"

                text: qsTr("CELL/ETH:")
            }

            Text
            {
                font.pointSize: 18
                color: "green"

                text: qsTr("3403.2349123")
            }
        }

        RowLayout
        {
            spacing: 10

            Text
            {
                Layout.fillWidth: true
                font.pointSize: 10
                color: "gray"

                text: qsTr("May 30, 08:30 AM")
            }

            Text
            {
                font.pointSize: 10
                color: "gray"

                text: qsTr("AVG Price:")
            }

            Text
            {
                font.pointSize: 10
                color: "white"

                text: qsTr("3403.2349123")
            }
        }

        CandleChart
        {
            id: chartItem
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

            Text
            {
                font.pointSize: 10
                color: "gray"

                text: qsTr("2022/05/30")
            }

            Text
            {
                Layout.leftMargin: 20
                font.pointSize: 10
                color: "gray"

                text: qsTr("Open:")
            }

            Text
            {
                font.pointSize: 10
                color: "green"

                text: qsTr("58.1421")
            }

            Text
            {
                Layout.leftMargin: 20
                font.pointSize: 10
                color: "gray"

                text: qsTr("High:")
            }

            Text
            {
                font.pointSize: 10
                color: "green"

                text: qsTr("59.1421")
            }

            Text
            {
                Layout.leftMargin: 20
                font.pointSize: 10
                color: "gray"

                text: qsTr("Low:")
            }

            Text
            {
                font.pointSize: 10
                color: "green"

                text: qsTr("57.1421")
            }

            Text
            {
                Layout.leftMargin: 20
                font.pointSize: 10
                color: "gray"

                text: qsTr("Close:")
            }

            Text
            {
                font.pointSize: 10
                color: "green"

                text: qsTr("57.1421")
            }

            Text
            {
                Layout.leftMargin: 20
                font.pointSize: 10
                color: "gray"

                text: qsTr("Change:")
            }

            Text
            {
                font.pointSize: 10
                color: "green"

                text: qsTr("2.97%")
            }

        }

    }

}

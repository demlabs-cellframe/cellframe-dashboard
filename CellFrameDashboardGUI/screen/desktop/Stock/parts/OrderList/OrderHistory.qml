import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    property var layoutCoeff:
        ( new Map([
            ["date", 0.145],
            ["pair", 0.08],
            ["type", 0.08],
            ["side", 0.04],
            ["price", 0.08],
            ["amount", 0.08],
            ["filled", 0.06],
            ["total", 0.08],
            ["triggerCondition", 0.12],
            ["expiresIn", 0.07]
    ]))

    ListModel {
        id: openOrdersModel
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Stop limit"
            side: "Sell"
            price: "11,2241"
            amount: "204,241"
            filled: "100%"
            total: "1000.11"
            triggerCondition: ">=12,214"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Limit"
            side: "Buy"
            price: "11,2241"
            amount: "204,241"
            filled: "92%"
            total: "1000.11"
            triggerCondition: "-"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Stop limit"
            side: "Sell"
            price: "11,2241"
            amount: "204,241"
            filled: "100%"
            total: "1000.11"
            triggerCondition: ">=12,214"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Limit"
            side: "Buy"
            price: "11,2241"
            amount: "204,241"
            filled: "92%"
            total: "1000.11"
            triggerCondition: "-"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Stop limit"
            side: "Sell"
            price: "11,2241"
            amount: "204,241"
            filled: "100%"
            total: "1000.11"
            triggerCondition: ">=12,214"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Limit"
            side: "Buy"
            price: "11,2241"
            amount: "204,241"
            filled: "92%"
            total: "1000.11"
            triggerCondition: "-"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Stop limit"
            side: "Sell"
            price: "11,2241"
            amount: "204,241"
            filled: "100%"
            total: "1000.11"
            triggerCondition: ">=12,214"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Limit"
            side: "Buy"
            price: "11,2241"
            amount: "204,241"
            filled: "92%"
            total: "1000.11"
            triggerCondition: "-"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Stop limit"
            side: "Sell"
            price: "11,2241"
            amount: "204,241"
            filled: "100%"
            total: "1000.11"
            triggerCondition: ">=12,214"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Limit"
            side: "Buy"
            price: "11,2241"
            amount: "204,241"
            filled: "92%"
            total: "1000.11"
            triggerCondition: "-"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Stop limit"
            side: "Sell"
            price: "11,2241"
            amount: "204,241"
            filled: "100%"
            total: "1000.11"
            triggerCondition: ">=12,214"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Limit"
            side: "Buy"
            price: "11,2241"
            amount: "204,241"
            filled: "92%"
            total: "1000.11"
            triggerCondition: "-"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Stop limit"
            side: "Sell"
            price: "11,2241"
            amount: "204,241"
            filled: "100%"
            total: "1000.11"
            triggerCondition: ">=12,214"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Limit"
            side: "Buy"
            price: "11,2241"
            amount: "204,241"
            filled: "92%"
            total: "1000.11"
            triggerCondition: "-"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Stop limit"
            side: "Sell"
            price: "11,2241"
            amount: "204,241"
            filled: "100%"
            total: "1000.11"
            triggerCondition: ">=12,214"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Limit"
            side: "Buy"
            price: "11,2241"
            amount: "204,241"
            filled: "92%"
            total: "1000.11"
            triggerCondition: "-"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Stop limit"
            side: "Sell"
            price: "11,2241"
            amount: "204,241"
            filled: "100%"
            total: "1000.11"
            triggerCondition: ">=12,214"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Limit"
            side: "Buy"
            price: "11,2241"
            amount: "204,241"
            filled: "92%"
            total: "1000.11"
            triggerCondition: "-"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Stop limit"
            side: "Sell"
            price: "11,2241"
            amount: "204,241"
            filled: "100%"
            total: "1000.11"
            triggerCondition: ">=12,214"
            expiresIn: "3 days"
        }
        ListElement {
            date: "2022-12-15 18:40"
            pair: "CELL/ETH"
            type: "Limit"
            side: "Buy"
            price: "11,2241"
            amount: "204,241"
            filled: "92%"
            total: "1000.11"
            triggerCondition: "-"
            expiresIn: "3 days"
        }
    }

    ListModel {
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
    }

    ListModel {
        id: modeModel
        ListElement {
            name: "Buy"
        }
        ListElement {
            name: "Sell"
        }
        ListElement {
            name: "All"
        }
    }

    color: "#404040"

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        RowLayout
        {
            Layout.fillWidth: true
            Layout.margins: 10
            spacing: 10

            ListModel {
                id: selectorModel
                ListElement {
                    name: "1 Day"
                }
                ListElement {
                    name: "1 Week"
                }
                ListElement {
                    name: "1 Month"
                }
                ListElement {
                    name: "3 Month"
                }
                ListElement {
                    name: "All"
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

            DapComboBox
            {
                Layout.minimumWidth: 150
                Layout.maximumHeight: 35
//                height: 30
                font.pointSize: 10

                model: pairModel
            }

            DapComboBox
            {
                Layout.minimumWidth: 120
                Layout.maximumHeight: 35
//                height: 30
                font.pointSize: 10

                model: modeModel
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 25

            color: "#202020"

            RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                Text
                {
                    Layout.preferredWidth: parent.width *
                                           layoutCoeff.get("date")
                    color: "white"
                    font.pointSize: 9
                    text: qsTr("Date")
                }

                Text
                {
                    Layout.preferredWidth: parent.width *
                                           layoutCoeff.get("pair")
                    color: "white"
                    font.pointSize: 9
                    text: qsTr("Pair")
                }

                Text
                {
                    Layout.preferredWidth: parent.width *
                                           layoutCoeff.get("type")
                    color: "white"
                    font.pointSize: 9
                    text: qsTr("Type")
                }

                Text
                {
                    Layout.preferredWidth: parent.width *
                                           layoutCoeff.get("side")
                    color: "white"
                    font.pointSize: 9
                    text: qsTr("Side")
                }

                Text
                {
                    Layout.preferredWidth: parent.width *
                                           layoutCoeff.get("price")
                    color: "white"
                    font.pointSize: 9
                    text: qsTr("Price")
                }

                Text
                {
                    Layout.preferredWidth: parent.width *
                                           layoutCoeff.get("amount")
                    color: "white"
                    font.pointSize: 9
                    text: qsTr("Amount")
                }

                Text
                {
                    Layout.preferredWidth: parent.width *
                                           layoutCoeff.get("filled")
                    color: "white"
                    font.pointSize: 9
                    text: qsTr("Filled")
                }

                Text
                {
                    Layout.preferredWidth: parent.width *
                                           layoutCoeff.get("total")
                    color: "white"
                    font.pointSize: 9
                    text: qsTr("Total")
                }

                Text
                {
                    Layout.preferredWidth: parent.width *
                                           layoutCoeff.get("triggerCondition")
                    color: "white"
                    font.pointSize: 9
                    text: qsTr("Trigger condition")
                }

                Text
                {
                    Layout.preferredWidth: parent.width *
                                           layoutCoeff.get("expiresIn")
                    color: "white"
                    font.pointSize: 9
                    text: qsTr("Expires in")
                }

            }
        }

        ListView
        {
            id: openOrdersView

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            model: openOrdersModel

            delegate:
                ColumnLayout
                {
                    width: parent.width

                    RowLayout
                    {
                        Layout.minimumWidth:
                            parent.width - Layout.leftMargin
                            - Layout.rightMargin
                        Layout.topMargin: 5
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10

                        Text
                        {
                            Layout.preferredWidth: parent.width *
                                                   layoutCoeff.get("date")
                            color: "white"
                            font.pointSize: 9
                            text: date
                        }

                        Text
                        {
                            Layout.preferredWidth: parent.width *
                                                   layoutCoeff.get("pair")
                            color: "white"
                            font.pointSize: 9
                            text: pair
                        }

                        Text
                        {
                            Layout.preferredWidth: parent.width *
                                                   layoutCoeff.get("type")
                            color: "white"
                            font.pointSize: 9
                            text: type
                        }

                        Text
                        {
                            Layout.preferredWidth: parent.width *
                                                   layoutCoeff.get("side")
                            color: side === "Sell" ? "red" : "green"
                            font.pointSize: 9
                            text: side
                        }

                        Text
                        {
                            Layout.preferredWidth: parent.width *
                                                   layoutCoeff.get("price")
                            color: "white"
                            font.pointSize: 9
                            text: price
                        }

                        Text
                        {
                            Layout.preferredWidth: parent.width *
                                                   layoutCoeff.get("amount")
                            color: "white"
                            font.pointSize: 9
                            text: amount
                        }

                        Text
                        {
                            Layout.preferredWidth: parent.width *
                                                   layoutCoeff.get("filled")
                            color: "white"
                            font.pointSize: 9
                            text: filled
                        }

                        Text
                        {
                            Layout.preferredWidth: parent.width *
                                                   layoutCoeff.get("total")
                            color: "white"
                            font.pointSize: 9
                            text: total
                        }

                        Text
                        {
                            Layout.preferredWidth: parent.width *
                                                   layoutCoeff.get("triggerCondition")
                            color: "white"
                            font.pointSize: 9
                            text: triggerCondition
                        }

                        Text
                        {
                            Layout.preferredWidth: parent.width *
                                                   layoutCoeff.get("expiresIn")
                            color: "white"
                            font.pointSize: 9
                            text: expiresIn
                        }
                    }

                    Rectangle
                    {
                        Layout.fillWidth: true
                        height: 1
                        visible: index <
                                 parent.ListView.view.model.count-1

                        color: "black"
                    }
                }
        }

    }
}

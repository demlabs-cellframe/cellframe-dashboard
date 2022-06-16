import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    property var layoutCoeff:
        ( new Map([
            ["date", 145],
            ["pair", 80],
            ["type", 80],
            ["side", 40],
            ["price", 80],
            ["amount", 80],
            ["filled", 60],
            ["total", 80],
            ["triggerCondition", 120],
            ["expiresIn", 70],
            ["cancel", 60]
    ]))

//        ( new Map([
//            ["date", 0.145],
//            ["pair", 0.08],
//            ["type", 0.08],
//            ["side", 0.04],
//            ["price", 0.08],
//            ["amount", 0.08],
//            ["filled", 0.06],
//            ["total", 0.08],
//            ["triggerCondition", 0.12],
//            ["expiresIn", 0.07],
//            ["cancel", 0.06]
//    ]))

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

    color: currTheme.backgroundElements

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Rectangle
        {
            Layout.fillWidth: true
            height: 25

            color: currTheme.backgroundMainScreen

            RowOpenOrder
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 10
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
                    height: 50

                    RowOpenOrder
                    {
                        Layout.minimumWidth:
                            parent.width - Layout.leftMargin
                            - Layout.rightMargin
                        Layout.topMargin: 5
                        Layout.leftMargin: 16
                        Layout.rightMargin: 10
                        isHeader: false
                    }

                    Rectangle
                    {
                        Layout.fillWidth: true
                        height: 1
                        visible: index <
                                 parent.ListView.view.model.count-1

                        color: currTheme.lineSeparatorColor
                    }
                }
        }

    }
}

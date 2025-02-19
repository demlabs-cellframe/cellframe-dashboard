import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import "qrc:/widgets"
import "../../controls"
//import "../CreateOrder"
//import ".."

Rectangle
{
    color: currTheme.mainBackground
//    color: "red"

    property string filterSide: "Both"

    OpenOrderItem
    {
        id: orderItem
        visible: false
    }

//    signal setFilterSide(var side)

    ListModel {
        id: sideModel
        ListElement {
            name: qsTr("Buy")
            color: "#84BE00"
        }
        ListElement {
            name: qsTr("Sell")
            color: "#FF5F5F"
        }
        ListElement {
            name: qsTr("Both")
            color: "#A361FF"
        }
    }

    ListModel
    {
        id: orderModel

        ListElement {
            side: "Buy"
            token1: "TKN1"
            token2: "TNK2"
            price: "12.345678"
            type: "Limit"
            amount: 456.78
            total: 76.543
            condition: ">= 456.78"
            expires: "2d:4h:32m:24s"
            filled: 94
            date: "2022-12-13 21:22"
        }
        ListElement {
            side: "Sell"
            token1: "TKN1"
            token2: "TNK2"
            price: "12.345678"
            type: "Limit"
            amount: 456.78
            total: 76.543
            condition: ">= 456.78"
            expires: "2d:4h:32m:24s"
            filled: 94
            date: "2022-12-13 21:22"
        }
        ListElement {
            side: "Buy"
            token1: "TKN1"
            token2: "TNK2"
            price: "12.345678"
            type: "Limit"
            amount: 456.78
            total: 76.543
            condition: ">= 456.78"
            expires: "2d:4h:32m:24s"
            filled: 94
            date: "2022-12-13 21:22"
        }
        ListElement {
            side: "Sell"
            token1: "TKN1"
            token2: "TNK2"
            price: "12.345678"
            type: "Limit"
            amount: 456.78
            total: 76.543
            condition: ">= 456.78"
            expires: "2d:4h:32m:24s"
            filled: 94
            date: "2022-12-13 21:22"
        }
        ListElement {
            side: "Buy"
            token1: "TKN1"
            token2: "TNK2"
            price: "12.345678"
            type: "Limit"
            amount: 456.78
            total: 76.543
            condition: ">= 456.78"
            expires: "2d:4h:32m:24s"
            filled: 94
            date: "2022-12-13 21:22"
        }
        ListElement {
            side: "Sell"
            token1: "TKN1"
            token2: "TNK2"
            price: "12.345678"
            type: "Limit"
            amount: 456.78
            total: 76.543
            condition: ">= 456.78"
            expires: "2d:4h:32m:24s"
            filled: 94
            date: "2022-12-13 21:22"
        }
        ListElement {
            side: "Buy"
            token1: "TKN1"
            token2: "TNK2"
            price: "12.345678"
            type: "Limit"
            amount: 456.78
            total: 76.543
            condition: ">= 456.78"
            expires: "2d:4h:32m:24s"
            filled: 94
            date: "2022-12-13 21:22"
        }
        ListElement {
            side: "Sell"
            token1: "TKN1"
            token2: "TNK2"
            price: "12.345678"
            type: "Limit"
            amount: 456.78
            total: 76.543
            condition: ">= 456.78"
            expires: "2d:4h:32m:24s"
            filled: 94
            date: "2022-12-13 21:22"
        }
        ListElement {
            side: "Buy"
            token1: "TKN1"
            token2: "TNK2"
            price: "12.345678"
            type: "Limit"
            amount: 456.78
            total: 76.543
            condition: ">= 456.78"
            expires: "2d:4h:32m:24s"
            filled: 94
            date: "2022-12-13 21:22"
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 16

        DapSelector
        {
            id: buysellbothSelector
            Layout.topMargin: 10
            height: 35
            itemHorisontalBorder: 43
            defaultIndex: 2

            selectorModel: sideModel

            onItemSelected:
            {
                if (currentIndex === 0)
                {
                    filterSide = "Buy"
//                    setFilterSide("Buy")
                }
                if (currentIndex === 1)
                {
                    filterSide = "Sell"
//                    setFilterSide("Sell")
                }
                if (currentIndex === 2)
                {
                    filterSide = "Both"
//                    setFilterSide("Both")
                }
            }

        }

        ListView {
            id: orderView

            property int tokenIndex: -1
//            property int heightDelegate: 60

            Layout.fillWidth: true
            Layout.fillHeight: true
//            Layout.preferredHeight: getHeight(model, 240, tokenView)

            model: orderModel

            interactive: true
            clip: true
            ScrollBar.vertical: ScrollBar{
                active: true
                visible: true
            }

            spacing: 0

            delegate:
                OrderDelegate{}

            Behavior on Layout.preferredHeight {
                NumberAnimation{duration: 200}
            }
        }

//        Item
//        {
//            Layout.fillHeight: true
//        }

    }

}

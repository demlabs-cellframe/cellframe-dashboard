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

    property date today: new Date()
    property var currentTime: today.getTime()
    property var minTime: 0

    Component.onCompleted:
    {
//        time = today.getTime()
        console.log("OrderHistoryPage onCompleted", "today", today)
        console.log("OrderHistoryPage onCompleted", "time", currentTime)

        for (var i = 0; i < orderModel.count; ++i)
        {
//            console.log("orderModel", i, orderModel.get(i).date)

            orderModel.setProperty(i, "time", currentTime - (i*200000000))

            var date = new Date(orderModel.get(i).time)

            orderModel.setProperty(i, "date", date.
                                   toLocaleString(Qt.locale("en_EN"),
                                                  "yyyy-MM-dd hh:mm:ss"))
            console.log("orderModel", i,
                        orderModel.get(i).time,
                        date.
                            toLocaleString(Qt.locale("en_EN"),
                                           "yy/MM/dd hh:mm:ss"))
        }
    }

    OrderHistoryItem
    {
        id: orderItem
        visible: false
    }

//    signal setFilterSide(var side)

    ListModel {
        id: timeModel

        Component.onCompleted:
        {
            initTimeModel()
        }
    }

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
            time: 0
            status: "Filled"
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
            time: 0
            status: "Filled"
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
            time: 0
            status: "Canceled"
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
            time: 0
            status: "Canceled"
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
            time: 0
            status: "Filled"
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
            time: 0
            status: "Filled"
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
            time: 0
            status: "Canceled"
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
            time: 0
            status: "Canceled"
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
            time: 0
            status: "Filled"
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 16

        RowLayout
        {
            Layout.fillWidth: true

            DapSelector
            {
                id: timeSelector
                Layout.topMargin: 10
                height: 35
                itemHorisontalBorder: 10

                selectorModel: timeModel

//                onSelectorModelChanged:
//                {
//                    defaultIndex = selectorModel.count-1
//                }

                onItemSelected:
                {
                    minTime = timeModel.get(currentIndex).time
//                    if (currentIndex === 0)
//                    {
//                        filterSide = "Buy"
//    //                    setFilterSide("Buy")
//                    }
//                    if (currentIndex === 1)
//                    {
//                        filterSide = "Sell"
//    //                    setFilterSide("Sell")
//                    }
//                    if (currentIndex === 2)
//                    {
//                        filterSide = "Both"
//    //                    setFilterSide("Both")
//                    }
                }

            }

            DapCustomComboBox
            {
                id: buysellbothComboBox
                Layout.fillWidth: true
                Layout.minimumWidth: 60
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                font: mainFont.dapFont.regular16
                bgRadius: 4

                backgroundColor: currTheme.mainBackground

                Component.onCompleted:
                {
                    setCurrentIndex(2)
                }

    //                enabled: false
                rightMarginIndicator: 0
                model: sideModel

                onItemSelected:
                {
                    if (currentIndex === 0)
                    {
                        filterSide = "Buy"
                    }
                    if (currentIndex === 1)
                    {
                        filterSide = "Sell"
                    }
                    if (currentIndex === 2)
                    {
                        filterSide = "Both"
                    }

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

//    readonly property var day: 86400000
//    readonly property int week: day*7
//    readonly property int month: day*30

    function initTimeModel()
    {
        timeModel.append(
                    { name : "1D",
                      time : 86400000 })
//        timeModel.append(
//                    { name : "3D",
//                      time : day*3 })
        timeModel.append(
                    { name : "1W",
                      time : 86400000*7 })
        timeModel.append(
                    { name : "1M",
                      time : 86400000*30 })
        timeModel.append(
                    { name : "3M",
                      time : 86400000*30*3 })
        timeModel.append(
                    { name : "6M",
                      time : 86400000*30*6 })
        timeModel.append(
                    { name : "All",
                      time : 0 })

        timeSelector.defaultIndex = timeModel.count-1
    }
}

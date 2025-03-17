import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import "qrc:/widgets"

Item
{
    id: control
    property var visibleCount
    property string sellHistogramColor: "#1aff6060"
    property string buyHistogramColor: "#1300ff00"

    property int delegateHeight: 25
    property real viewerHeight: control.height - rowHeader.height - 30

    property bool twoColums: sellColunm.visible && buyColunm.visible

    Component.onCompleted:
    {
        getBookVisibleCount()

        var tempIndex = logicMainApp.currentRoundPowerIndex

//        console.log("logicMainApp.currentRoundPowerIndex",
//              logicMainApp.currentRoundPowerIndex)

        setBookRoundPowerMinimum(orderBookWorker.bookRoundPowerMinimum)

        roundPowerComboBox.setCurrentIndex(tempIndex)
        orderBookWorker.setBookRoundPower(roundPowerComboBox.displayText)

//        console.log("OrderBook.onCompleted",
//              "bookRoundPowerMinimum", orderBookWorker.bookRoundPowerMinimum,
//              "roundPowerComboBox.defaultText", roundPowerComboBox.displayText,
//              "tempIndex", tempIndex)
    }

//    onHeightChanged:
//    {
//        console.log("OrderBook",
//              height)

//        getBookVisibleCount()
//    }

    ListModel {
        id: accuracyModel
        ListElement {
            value: "0.00001"
        }
        ListElement {
            value: "0.0001"
        }
        ListElement {
            value: "0.001"
        }
        ListElement {
            value: "0.01"
        }
        ListElement {
            value: "0.1"
        }
        ListElement {
            value: "1.0"
        }
    }

    Connections{
        target: orderBookWorker
        onSetNewBookRoundPowerMinimum:
        {
            setBookRoundPowerMinimum(power)
        }
    }

    function setBookRoundPowerMinimum(power)
    {
        console.log("onSetNewBookRoundPowerMinimum", power)

        var tempValue = Math.pow(10, -power)

        console.log("tempValue",
              tempValue)

        accuracyModel.clear()

        addPowerToModel(power)
        addPowerToModel(power-1)
        addPowerToModel(power-2)
        addPowerToModel(power-3)
        addPowerToModel(power-4)
        addPowerToModel(power-5)

        var tempIndex = logicMainApp.currentRoundPowerIndex

        roundPowerComboBox.setCurrentIndex(tempIndex)
        orderBookWorker.setBookRoundPower(roundPowerComboBox.displayText)
    }

    function addPowerToModel(power)
    {
        var tempValue = Math.pow(10, -power)

        if (power >= 0)
            accuracyModel.append({"value": tempValue.toFixed(power)})
        else
            accuracyModel.append({"value": tempValue.toString()})
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        RowLayout
        {
            id: rowHeader
            Layout.fillWidth: true
            height: 42

            signal setActive(var ind)

            spacing: 0

            BookSellBuyImg
            {
                id: sellBuy
                Layout.leftMargin: 16
                index: 0
                isActive: true
                source: "icons/sellBuy_icon.png"
                onSelected: {
                    sellColunm.visible = true
                    buyColunm.visible = true
                    rowHeader.setActive(index)
                }
            }

            BookSellBuyImg
            {
                id: buy
                Layout.leftMargin: 8
                index: 1
                source: "icons/buyIcon.png"
                onSelected: {
                    sellColunm.visible = false
                    buyColunm.visible = true
                    rowHeader.setActive(index)
                }
            }

            BookSellBuyImg
            {
                id: sell
                Layout.leftMargin: 8
                index: 2
                source: "icons/sellIcon.png"
                onSelected: {
                    sellColunm.visible = true
                    buyColunm.visible = false
                    rowHeader.setActive(index)
                }
            }


            Item {
                Layout.fillWidth: true
            }

            DapCustomComboBox
            {
                id: roundPowerComboBox
                Layout.minimumWidth: 150
                height: 35
                font: mainFont.dapFont.regular13
                mainTextRole: "value"
                enabled: true

                backgroundColor: currTheme.mainBackground

                model: accuracyModel

                onCurrentIndexChanged: /* no call*/
                {
                    orderBookWorker.setBookRoundPower(currentText)
                }

                onItemSelected:
                {
                    logicMainApp.currentRoundPowerIndex = index

                    console.log("logicMainApp.currentRoundPowerIndex",
                          logicMainApp.currentRoundPowerIndex)
                }
            }
        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            spacing: 16

            ColumnLayout
            {
                id: sellColunm

                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                Rectangle
                {
                    Layout.fillWidth: true
                    color: currTheme.mainBackground
                    height: 30

                    RowLayout
                    {
                        anchors.fill: parent
//                        anchors.leftMargin: 16
//                        anchors.rightMargin: 16

                        Text
                        {
                            Layout.minimumWidth: 100
                            color: currTheme.white
                            font: mainFont.dapFont.medium12
                            text: twoColums ? qsTr("Amount") : qsTr("Price")
                        }

                        Text
                        {
                            Layout.fillWidth: true
                            color: currTheme.white
                            font: mainFont.dapFont.medium12
                            horizontalAlignment: twoColums ?
                                Qt.AlignRight : Qt.AlignLeft
                            text: twoColums ? qsTr("Price") : qsTr("Amount")
                        }

                        Text
                        {
                            visible: !twoColums
                            horizontalAlignment: Qt.AlignRight
                            color: currTheme.white
                            font: mainFont.dapFont.medium12
                            text: qsTr("Total")
                        }
                    }
                }

                ListView
                {
                    id: sellView

                    Layout.fillWidth: true
//                    Layout.fillHeight: true
                    Layout.minimumHeight:
                            visibleCount <= sellModel.length ?
                                twoColums ? (visibleCount+1)*delegateHeight
                                          : viewerHeight
//                                viewerHeight
                                : sellModel.length*delegateHeight
//                    Layout.maximumHeight:
//                        twoColums ? visibleCount*delegateHeight
//                                  : viewerHeight

                    clip: true
                    interactive: buyColunm.visible ? false: true
                    verticalLayoutDirection: ListView.BottomToTop

                    ScrollBar.vertical: ScrollBar{
                        active: true
                        visible: sellView.interactive
                        onVisibleChanged: setPosition(sellView.positionViewAtBeginning())
                    }

                    model: sellModel

                    delegate: OrderBookDelegate
                    {
                        shortView: twoColums
                        visible: buyColunm.visible ?
                                     index > visibleCount || index > sellModel.length ? false : true : true
                    }
                }

//                Item {
//                    Layout.fillHeight: visibleCount > sellModel.length
//                }
                Item {
                    Layout.fillHeight: true
                }
            }

            ColumnLayout
            {
                id: buyColunm

                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                Rectangle
                {
                    Layout.fillWidth: true
                    color: currTheme.mainBackground
                    height: 30

                    RowLayout
                    {
                        anchors.fill: parent
//                        anchors.leftMargin: 16
//                        anchors.rightMargin: 16

                        Text
                        {
                            Layout.minimumWidth: 100
                            color: currTheme.white
                            font: mainFont.dapFont.medium12
                            text: qsTr("Price")
                        }

                        Text
                        {
                            Layout.fillWidth: true
                            color: currTheme.white
                            font: mainFont.dapFont.medium12
                            horizontalAlignment: twoColums ?
                                Qt.AlignRight : Qt.AlignLeft
                            text: qsTr("Amount")
                        }

                        Text
                        {
                            visible: !twoColums
                            horizontalAlignment: Qt.AlignRight
                            color: currTheme.white
                            font: mainFont.dapFont.medium12
                            text: qsTr("Total")
                        }
                    }
                }

                ListView
                {
                    id: buyView

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight:
                        twoColums ? visibleCount*delegateHeight
                                  : viewerHeight
//                    Layout.maximumHeight:
//                        twoColums ? visibleCount*delegateHeight
//                                  : viewerHeight

                    clip: true
                    interactive: sellColunm.visible ? false: true
        //            verticalLayoutDirection: ListView.BottomToTop

                    ScrollBar.vertical: ScrollBar{
                        active: true
                        visible: buyView.interactive
                        onVisibleChanged: setPosition(buyView.positionViewAtBeginning())
                    }

                    model: buyModel

                    delegate: OrderBookDelegate
                    {
                        isSell: false
                        shortView: twoColums
                        visible: sellColunm.visible ?
                                     index > visibleCount ? false : true : true
                    }
                }

//                Item {
//                    Layout.fillHeight: true
//                }
            }
        }
    }

    function getBookVisibleCount()
    {
        visibleCount = Math.floor(viewerHeight/delegateHeight - 1)

//        console.log("getBookVisibleCount", delegateHeight, viewerHeight, visibleCount)
    }
}

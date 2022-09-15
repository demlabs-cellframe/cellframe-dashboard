import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Page
{
    id: control
    property var visibleCount
    property string sellHistogramColor: "#1aff6060"
    property string buyHistogramColor: "#1300ff00"

    Component.onCompleted:
    {
        visibleCount = logicStock.getBookVisibleCount(
            control.height - rowHeader.height - 30)

        var tempIndex = logicMainApp.currentRoundPowerIndex

        print("logicMainApp.currentRoundPowerIndex",
              logicMainApp.currentRoundPowerIndex)

        setBookRoundPowerMinimum(stockDataWorker.bookRoundPowerMinimum)

        roundPowerComboBox.setCurrentIndex(tempIndex)
        stockDataWorker.setBookRoundPower(roundPowerComboBox.displayText)

        print("OrderBook.onCompleted",
              "bookRoundPowerMinimum", stockDataWorker.bookRoundPowerMinimum,
              "roundPowerComboBox.defaultText", roundPowerComboBox.displayText,
              "tempIndex", tempIndex)
    }
    onHeightChanged:
    {
        visibleCount = logicStock.getBookVisibleCount(
            control.height - rowHeader.height - 30)
    }

    background: Rectangle {
        color: "transparent"
    }

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
        target: stockDataWorker
        onSetNewBookRoundPowerMinimum:
        {
            setBookRoundPowerMinimum(power)
        }
    }

    function setBookRoundPowerMinimum(power)
    {
        print("onSetNewBookRoundPowerMinimum", power)

        var tempValue = Math.pow(10, -power)

        print("tempValue",
              tempValue)

        accuracyModel.clear()

        addPowerToModel(power)
        addPowerToModel(power-1)
        addPowerToModel(power-2)
        addPowerToModel(power-3)
        addPowerToModel(power-4)
        addPowerToModel(power-5)
//            addPowerToModel(power-6)
//            addPowerToModel(power-7)

//            tempValue = Math.pow(10, -power)
//            accuracyModel.append({"value": tempValue.toFixed(power)})
//            tempValue = Math.pow(10, -power+1)
//            accuracyModel.append({"value": tempValue.toFixed(power-1)})
//            tempValue = Math.pow(10, -power+2)
//            accuracyModel.append({"value": tempValue.toFixed(power-2)})
//            tempValue = Math.pow(10, -power+3)
//            accuracyModel.append({"value": tempValue.toFixed(power-3)})

        roundPowerComboBox.currentIndex = 0

//            accuracyModel.clear();
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
            Layout.leftMargin: 14
            height: 42

            signal setActive(var ind)

            spacing: 0

            Text {
                font: mainFont.dapFont.bold14
                color: currTheme.textColor

                text: qsTr("Orders")
            }

            BookSellByuImg
            {
                id: sellBuy
                Layout.leftMargin: 16
                index: 0
                isActive: true
                source: "../../icons/sellBuy_icon.png"
                onClicked: {
                    sellView.visible = true
                    buyView.visible = true
                    rowHeader.setActive(index)
                }
            }

            BookSellByuImg
            {
                id: buy
                Layout.leftMargin: 8
                index: 1
                source: "../../icons/buyIcon.png"
                onClicked: {
                    sellView.visible = false
                    buyView.visible = true
                    rowHeader.setActive(index)
                }
            }

            BookSellByuImg
            {
                id: sell
                Layout.leftMargin: 8
                index: 2
                source: "../../icons/sellIcon.png"
                onClicked: {
                    sellView.visible = true
                    buyView.visible = false
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

                model: accuracyModel

                onCurrentIndexChanged:
                {
                    stockDataWorker.setBookRoundPower(currentText)
                }

                onItemSelected:
                {
                    logicMainApp.currentRoundPowerIndex = index

                    print("logicMainApp.currentRoundPowerIndex",
                          logicMainApp.currentRoundPowerIndex)
                }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            color: currTheme.backgroundMainScreen
            height: 30

            RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16

                Text
                {
                    Layout.minimumWidth: 100
                    color: currTheme.textColor
                    font: mainFont.dapFont.medium12
                    text: "Price("+logicMainApp.token2Name+")"
                }

                Text
                {
                    Layout.fillWidth: true
                    color: currTheme.textColor
                    font: mainFont.dapFont.medium12
                    text: "Amount("+logicMainApp.token1Name+")"
                }

                Text
                {
                    horizontalAlignment: Qt.AlignRight
                    color: currTheme.textColor
                    font: mainFont.dapFont.medium12
                    text: "Total"
                }
            }
        }

        ListView
        {
            id: sellView


            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            interactive: buyView.visible ? false: true
            verticalLayoutDirection: ListView.BottomToTop

            ScrollBar.vertical: ScrollBar{
                active: true
                visible: sellView.interactive
                onVisibleChanged: setPosition(sellView.positionViewAtBeginning())
            }

            model: sellModel

            delegate: OrderBookDelegate
            {
                visible: buyView.visible ?
                             index > visibleCount ? false : true : true
            }
        }

        ColumnLayout
        {
            Layout.fillWidth: true
            spacing: 0
            height: 42

            Rectangle
            {
                Layout.fillWidth: true
                height: 1
                color: currTheme.lineSeparatorColor
            }

            Text
            {
                Layout.fillWidth: true
                Layout.topMargin: 12
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                color: currTheme.textColor
                font: mainFont.dapFont.medium14

                text: stockDataWorker.currentTokenPrice.toFixed(roundPower)
            }

            Rectangle
            {
                Layout.fillWidth: true
                Layout.topMargin: 12
                height: 1
                color: currTheme.lineSeparatorColor
            }
        }

        ListView
        {
            id: buyView

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            interactive: sellView.visible ? false: true
//            verticalLayoutDirection: ListView.BottomToTop

            ScrollBar.vertical: ScrollBar{
                active: true
                visible: buyView.interactive
                onVisibleChanged: setPosition(buyView.positionViewAtBegining())
            }

            model: buyModel

            delegate: OrderBookDelegate
            {
                isSell: false
                visible: sellView.visible ?
                             index > visibleCount ? false : true : true
            }
        }
    }
}

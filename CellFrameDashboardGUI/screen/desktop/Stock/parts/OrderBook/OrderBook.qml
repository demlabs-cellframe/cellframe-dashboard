import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Page
{
    id: control
    property var visibleCount

    Component.onCompleted: visibleCount = logicStock.getBookVisibleCount(control.height - rowHeader.height - 30)
    onHeightChanged: visibleCount = logicStock.getBookVisibleCount(control.height - rowHeader.height - 30)

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

            DapComboBox
            {
                Layout.minimumWidth: 128
                height: 35
                font: mainFont.dapFont.regular13
                mainTextRole: "value"

                model: accuracyModel
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
                    text: "Price(ETH)"
                }

                Text
                {
                    Layout.fillWidth: true
                    color: currTheme.textColor
                    font: mainFont.dapFont.medium12
                    text: "Amount(CELL)"
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

            model: sellBookModel

            delegate: OrderBookDelegate{visible: buyView.visible ? index > visibleCount ? false : true : true}
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

                text: logicStock.tokenPriceRounded
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

            ScrollBar.vertical: ScrollBar{
                active: true
                visible: buyView.interactive
                onVisibleChanged: setPosition(buyView.positionViewAtBeginning())
            }

            model: buyBookModel

            delegate: OrderBookDelegate{isSell: false; visible: sellView.visible ? index > visibleCount ? false : true : true}
        }
    }
}

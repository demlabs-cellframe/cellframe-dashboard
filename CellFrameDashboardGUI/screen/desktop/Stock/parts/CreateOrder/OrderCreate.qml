import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../Chart"

Page
{
    background: Rectangle {
        color: "transparent"
    }

    property string balanceValue: fakeWallet.get(0).tokens.get(1).balance_without_zeros
    property string balanceCellValue: fakeWallet.get(0).tokens.get(0).balance_without_zeros
    property string tokenName: logicStock.nameTokenPair
    property string currentOrder: "Limit"

    ListModel {
        id: expiresModel
        ListElement {
            name: qsTr("Not")
        }
        ListElement {
            name: qsTr("1 day")
        }
        ListElement {
            name: qsTr("2 days")
        }
        ListElement {
            name: qsTr("3 days")
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 38 * pt
            DapButton
            {
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 7 * pt
                anchors.leftMargin: 24 * pt
                anchors.rightMargin: 13 * pt

                id: itemButtonClose
                height: 20 * pt
                width: 20 * pt
                heightImageButton: 10 * pt
                widthImageButton: 10 * pt
                activeFrame: false
                normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
                hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"

                onClicked: goToRightHome()
            }

            Text
            {
                id: textHeader
                text: qsTr("Create order")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 52 * pt

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }
        }

        ChartTextBlock
        {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.topMargin: 10
            text1.text: qsTr("Balance:")
            text2.text: balanceValue + " " + tokenName
            text2.color: currTheme.textColor
            text1.font: mainFont.dapFont.regular14
            text2.font: mainFont.dapFont.regular14

        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.topMargin: 12
            spacing: 10

            DapSwitch
            {
                id: sellBuySwitch
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.preferredHeight: 26
                Layout.preferredWidth: 46
//                Layout.rightMargin: 15

                backgroundColor: currTheme.backgroundMainScreen
                borderColor: currTheme.reflectionLight
                shadowColor: currTheme.shadowColor

                onToggled:
                {
                    if (checked)
                    {
                        textBye.color = currTheme.textColorGray
                        textSell.color = currTheme.textColor

                        textMode.text = qsTr("Sell CELL")
                    }
                    else
                    {
                        textBye.color = currTheme.textColor
                        textSell.color = currTheme.textColorGray

                        textMode.text = qsTr("Buy CELL")
                    }
                }
            }

            Text
            {
                id: textBye
                font: mainFont.dapFont.medium14
                color: currTheme.textColor

                text: qsTr("Buy")
            }
            Text
            {
                font: mainFont.dapFont.medium14
                color: currTheme.textColor

                text: qsTr("/")
            }
            Text
            {
                id: textSell
                font: mainFont.dapFont.medium14
                color: currTheme.textColorGray

                text: qsTr("Sell")
            }
        }

        Text
        {
            id: textMode
            Layout.leftMargin: 16
            Layout.topMargin: 18
            font: mainFont.dapFont.medium14
            color: currTheme.textColor

            text: qsTr("Buy CELL")
        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 5
            Layout.topMargin: 7
            Layout.rightMargin: 16
            spacing: 36

            DapRadioButton
            {
                Layout.fillWidth: true

                indicatorInnerSize: 46
                spaceIndicatorText: -5
                fontRadioButton: mainFont.dapFont.regular14
                implicitHeight: 35

                nameRadioButton: qsTr("Limit")
                checked: true

                onClicked: {
                    limit.visible = true
                    market.visible = false
                    stopLimit.visible = false
                    currentOrder = "Limit"
                }
            }

            DapRadioButton
            {
                Layout.fillWidth: true

                indicatorInnerSize: 46
                spaceIndicatorText: -5
                fontRadioButton: mainFont.dapFont.regular14
                implicitHeight: 35

                nameRadioButton: qsTr("Market")
                checked: false

                onClicked: {
                    limit.visible = false
                    market.visible = true
                    stopLimit.visible = false
                    currentOrder = "Market"
                }
            }

            DapRadioButton
            {
                Layout.fillWidth: true

                indicatorInnerSize: 46
                spaceIndicatorText: -5
                fontRadioButton: mainFont.dapFont.regular14
                implicitHeight: 35

                nameRadioButton: qsTr("Stop limit")
                checked: false

                onClicked: {
                    limit.visible = false
                    market.visible = false
                    stopLimit.visible = true
                    currentOrder = "Stop limit"
                }
            }
        }

        OrderLimit
        {
            id: limit
            Layout.fillWidth: true
        }

        OrderMarket
        {
            id: market
            Layout.fillWidth: true
            visible: false
        }

        OrderStopLimit
        {
            id: stopLimit
            Layout.fillWidth: true
            visible: false
        }
    }
}


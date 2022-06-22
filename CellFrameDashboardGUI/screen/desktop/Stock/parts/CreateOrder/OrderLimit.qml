import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../Chart"

ColumnLayout {
    Layout.fillWidth: true
    Layout.topMargin: 16
    spacing: 0

    Rectangle
    {
        Layout.fillWidth: true
        color: currTheme.backgroundMainScreen
        height: 30 * pt
        Text
        {
            color: currTheme.textColor
            text: qsTr("Price")
            font: mainFont.dapFont.medium12
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 20 * pt
            anchors.bottomMargin: 5 * pt
        }
        Text
        {
            color: currTheme.textColor
            text: qsTr("Expires in")
            font: mainFont.dapFont.medium12
            horizontalAlignment: Text.AlignRight
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 57 * pt
            anchors.topMargin: 20 * pt
            anchors.bottomMargin: 5 * pt

        }
    }

    RowLayout
    {
        Layout.fillWidth: true
        Layout.topMargin: 12
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        spacing: 8

        OrderTextBlock
        {
            id: price
            Layout.fillWidth: true
            Layout.minimumWidth: 215
            Layout.minimumHeight: 40 * pt
            Layout.maximumHeight: 40 * pt
            textToken: tokenName
            textValue: logicStock.tokenPrice
        }

        Rectangle
        {
            id: expiresRect
            Layout.fillWidth: true
            Layout.minimumWidth: 95
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40

            border.color: currTheme.borderColor
            color: "transparent"
            radius: 4

            DapComboBox
            {
                id: expiresComboBox
                anchors.fill: parent
                anchors.margins: 2
                font: mainFont.dapFont.regular16

                model: expiresModel
            }
        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        Layout.topMargin: 12
        color: currTheme.backgroundMainScreen
        height: 30 * pt
        Text
        {
            color: currTheme.textColor
            text: qsTr("Amount")
            font: mainFont.dapFont.medium12
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 20 * pt
            anchors.bottomMargin: 5 * pt
        }
    }

    OrderTextBlock
    {
        id: amount
        Layout.fillWidth: true
        Layout.topMargin: 12
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.minimumHeight: 40
        Layout.maximumHeight: 40
        textToken: "CELL"
        textValue: "0"
    }

    RowLayout
    {
        Layout.fillWidth: true
        Layout.topMargin: 12
        Layout.leftMargin: 16
        Layout.rightMargin: 16

        DapButton
        {
            id: button25
            Layout.fillWidth: true
            implicitHeight: 25
            textButton: qsTr("25%")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular12
            selected: false
            onClicked:
            {          
                button25.selected = true
                button50.selected = false
                button75.selected = false
                button100.selected = false

                amount.textValue = (balanceValue / logicStock.tokenPrice )*0.25
            }
        }

        DapButton
        {
            id: button50
            Layout.fillWidth: true
            implicitHeight: 25
            textButton: qsTr("50%")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular12
            selected: false
            onClicked:
            {
                button25.selected = false
                button50.selected = true
                button75.selected = false
                button100.selected = false

                amount.textValue = (balanceValue / logicStock.tokenPrice )*0.5
            }
        }

        DapButton
        {
            id: button75
            Layout.fillWidth: true
            implicitHeight: 25
            textButton: qsTr("75%")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular12
            selected: false
            onClicked:
            {
                button25.selected = false
                button50.selected = false
                button75.selected = true
                button100.selected = false

                amount.textValue = (balanceValue / logicStock.tokenPrice )*0.75
            }
        }

        DapButton
        {
            id: button100
            Layout.fillWidth: true
            implicitHeight: 25
            textButton: qsTr("100%")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular12
            selected: false
            onClicked:
            {
                button25.selected = false
                button50.selected = false
                button75.selected = false
                button100.selected = true

                amount.textValue = (balanceValue / logicStock.tokenPrice )
            }
        }
    }

    DapButton
    {
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: 22
//            Layout.leftMargin: 16
//            Layout.rightMargin: 16
        implicitHeight: 36 * pt
        implicitWidth: 132 * pt
        textButton: qsTr("Create")
        horizontalAligmentText: Text.AlignHCenter
        indentTextRight: 0
        fontButton: mainFont.dapFont.medium14

        onClicked:
        {
            var date = new Date()

            logicStock.addNewOrder(
                date.toLocaleString(Qt.locale("en_EN"),
                "yyyy-MM-dd hh:mm:ss"),
                "CELL/"+logicStock.nameTokenPair,
                currentOrder, sellBuySwitch.checked? "Sell": "Buy",
                logicStock.tokenPrice, amount.textValue,
                expiresModel.get(expiresComboBox.currentIndex).name)
        }
    }

    Item{
        Layout.fillHeight: true
    }
}

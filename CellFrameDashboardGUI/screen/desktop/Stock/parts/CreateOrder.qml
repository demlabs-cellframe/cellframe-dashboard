import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Rectangle
{
    color: "#404040"

    property string balanceValue: "123.45678901234"
    property string tokenName: "ETH"

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

    Component.onCompleted:
    {
        blockStop.visible = false
        blockPriceMarket.visible = false
        blockPrice.visible = true
        blockLimit.visible = false
        blockTotal.visible = false
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 10

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 10
//            Layout.rightMargin: 10

            spacing: 10

            DapButton
            {
                id: itemButtonClose
                height: 20
                width: 20
                heightImageButton: 10
                widthImageButton: 10
                activeFrame: false
                normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
                hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"

                onClicked:
                {
                    goToRightHome()
                }
            }

            Text
            {
                font.pointSize: 12
                font.bold: true
                color: "white"

                text: qsTr("Create order")
            }
        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 10

            Text
            {
                font.pointSize: 10
                color: "Gray"

                text: qsTr("Balance: ")
            }

            Text
            {
                font.pointSize: 10
                color: "white"

                text: balanceValue + " " + tokenName
            }
        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            spacing: 10

            DapSwitch
            {
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
                        textBye.color = "gray"
                        textSell.color = "white"

                        textMode.text = qsTr("Sell CELL")
                    }
                    else
                    {
                        textBye.color = "white"
                        textSell.color = "gray"

                        textMode.text = qsTr("Buy CELL")
                    }
                }
            }

            Text
            {
                id: textBye
                font.pointSize: 10
                font.bold: true
                color: "white"

                text: qsTr("Buy")
            }
            Text
            {
                font.pointSize: 10
                font.bold: true
                color: "white"

                text: qsTr("/")
            }
            Text
            {
                id: textSell
                font.pointSize: 10
                font.bold: true
                color: "gray"

                text: qsTr("Sell")
            }
        }

        Text
        {
            id: textMode
            Layout.leftMargin: 10

            font.pointSize: 10
            font.bold: true
            color: "white"

            text: qsTr("Buy CELL")
        }

        RowLayout
        {
            Layout.fillWidth: true
//            Layout.leftMargin: 10
            spacing: 10

            DapRadioButton
            {
                Layout.fillWidth: true

                indicatorInnerSize: 46
                spaceIndicatorText: -5
//                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: 35

                nameRadioButton: qsTr("Limit")
                checked: true

                onClicked: {
                    print("Limit")

                    blockStop.visible = false
                    blockPriceMarket.visible = false
                    blockPrice.visible = true
                    blockLimit.visible = false
                    blockTotal.visible = false
                }
            }

            DapRadioButton
            {
                Layout.fillWidth: true

                indicatorInnerSize: 46
                spaceIndicatorText: -5
//                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: 35

                nameRadioButton: qsTr("Market")
                checked: false

                onClicked: {
                    print("Market")

                    blockStop.visible = false
                    blockPriceMarket.visible = true
                    blockPrice.visible = false
                    blockLimit.visible = false
                    blockTotal.visible = true
                }
            }

            DapRadioButton
            {
                Layout.fillWidth: true

                indicatorInnerSize: 46
                spaceIndicatorText: -5
//                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: 35

                nameRadioButton: qsTr("Stop limit")
                checked: false

                onClicked: {
                    print("Stop limit")

                    blockStop.visible = true
                    blockPriceMarket.visible = false
                    blockPrice.visible = false
                    blockLimit.visible = true
                    blockTotal.visible = false
                }
            }
        }

        ColumnLayout
        {
            id: blockStop
            Layout.fillWidth: true

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
                        color: "white"
                        font.pointSize: 10
                        text: qsTr("Stop")
                    }
                }
            }

            Rectangle
            {
                Layout.fillWidth: true
                Layout.minimumHeight: 35
                Layout.leftMargin: 10
                Layout.rightMargin: 10

                border.color: "white"
                color: "transparent"
                radius: 4

                RowLayout
                {
                    anchors.fill: parent

                    TextField {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        horizontalAlignment: Text.AlignLeft

                        placeholderText: "0.0"
                        color: "white"
                        font.pointSize: 10
    //                    font: mainFont.dapFont.medium14

                        background: Rectangle{color:"transparent"}
                    }

                    Text
                    {
    //                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.rightMargin: 10
                        verticalAlignment: Qt.AlignVCenter
                        color: "white"
                        font.pointSize: 10
                        text: tokenName
                    }
                }
            }
        }

        ColumnLayout
        {
            id: blockPriceMarket
            Layout.fillWidth: true

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
                        color: "white"
                        font.pointSize: 10
                        text: qsTr("Price")
                    }
                }
            }

            Rectangle
            {
                enabled: false
                Layout.fillWidth: true
                Layout.minimumHeight: 35
                Layout.leftMargin: 10
                Layout.rightMargin: 10

                border.color: "#808080"
                color: "transparent"
                radius: 4

                RowLayout
                {
                    anchors.fill: parent

                    TextField {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        horizontalAlignment: Text.AlignLeft

                        placeholderText: "0.0"
                        color: "#808080"
                        font.pointSize: 10
    //                    font: mainFont.dapFont.medium14

                        background: Rectangle{color:"transparent"}
                    }

                    Text
                    {
    //                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.rightMargin: 10
                        verticalAlignment: Qt.AlignVCenter
                        color: "#808080"
                        font.pointSize: 10
                        text: qsTr("Market")
                    }
                }
            }
        }

        ColumnLayout
        {
            id: blockPrice
            Layout.fillWidth: true

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
                        Layout.fillWidth: true
                        color: "white"
                        font.pointSize: 10
                        text: qsTr("Price")
                    }

                    Text
                    {
                        Layout.minimumWidth:
                            expiresRect.Layout.minimumWidth
                        color: "white"
                        font.pointSize: 10
                        text: qsTr("Expires in")
                    }
                }
            }

            RowLayout
            {
                Layout.fillWidth: true
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                spacing: 8

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 35

                    border.color: "white"
                    color: "transparent"
                    radius: 4

                    RowLayout
                    {
                        anchors.fill: parent

                        TextField {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            horizontalAlignment: Text.AlignLeft

                            placeholderText: "0.0"
                            color: "white"
                            font.pointSize: 10
        //                    font: mainFont.dapFont.medium14

                            background: Rectangle{color:"transparent"}
                        }

                        Text
                        {
    //                        Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.rightMargin: 10
                            verticalAlignment: Qt.AlignVCenter
                            color: "white"
                            font.pointSize: 10
                            text: tokenName
                        }
                    }
                }

                Rectangle
                {
                    id: expiresRect
                    Layout.minimumWidth: 100
                    Layout.minimumHeight: 35

                    border.color: "white"
                    color: "transparent"
                    radius: 4

                    DapComboBox
                    {
                        anchors.fill: parent
                        anchors.margins: 2
    //                    width: 150
    //                    height: 35
                        font.pointSize: 10

                        model: expiresModel
                    }

                }
            }

        }

        ColumnLayout
        {
            id: blockLimit
            Layout.fillWidth: true

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
                        Layout.fillWidth: true
                        color: "white"
                        font.pointSize: 10
                        text: qsTr("Limit")
                    }

                    Text
                    {
                        Layout.minimumWidth:
                            expiresLimitRect.Layout.minimumWidth
                        color: "white"
                        font.pointSize: 10
                        text: qsTr("Expires in")
                    }
                }
            }

            RowLayout
            {
                Layout.fillWidth: true
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                spacing: 8

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 35

                    border.color: "white"
                    color: "transparent"
                    radius: 4

                    RowLayout
                    {
                        anchors.fill: parent

                        TextField {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            horizontalAlignment: Text.AlignLeft

                            placeholderText: "0.0"
                            color: "white"
                            font.pointSize: 10
        //                    font: mainFont.dapFont.medium14

                            background: Rectangle{color:"transparent"}
                        }

                        Text
                        {
    //                        Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.rightMargin: 10
                            verticalAlignment: Qt.AlignVCenter
                            color: "white"
                            font.pointSize: 10
                            text: tokenName
                        }
                    }
                }

                Rectangle
                {
                    id: expiresLimitRect
                    Layout.minimumWidth: 100
                    Layout.minimumHeight: 35

                    border.color: "white"
                    color: "transparent"
                    radius: 4

                    DapComboBox
                    {
                        anchors.fill: parent
                        anchors.margins: 2
    //                    width: 150
    //                    height: 35
                        font.pointSize: 10

                        model: expiresModel
                    }

                }
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
                    color: "white"
                    font.pointSize: 10
                    text: qsTr("Amount")
                }
            }
        }

        ColumnLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12

            Rectangle
            {
                Layout.fillWidth: true
                Layout.minimumHeight: 35

                border.color: "white"
                color: "transparent"
                radius: 4

                RowLayout
                {
                    anchors.fill: parent

                    TextField {
                        id: textAmount
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        horizontalAlignment: Text.AlignLeft

                        placeholderText: "0"
                        color: "white"
                        font.pointSize: 10
    //                    font: mainFont.dapFont.medium14

                        background: Rectangle{color:"transparent"}
                    }

                    Text
                    {
//                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.rightMargin: 10
                        verticalAlignment: Qt.AlignVCenter
                        color: "white"
                        font.pointSize: 10
                        text: qsTr("CELL")
                    }
                }
            }

            RowLayout
            {
                Layout.fillWidth: true

                DapButton
                {
                    id: button25
                    Layout.fillWidth: true
                    implicitHeight: 25
                    textButton: qsTr("25%")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
    //                fontButton: mainFont.dapFont.regular16
                    selected: false
                    onClicked:
                    {
                        button25.selected = true
                        button50.selected = false
                        button75.selected = false
                        button100.selected = false

                        textAmount.text = balanceValue*0.25
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
    //                fontButton: mainFont.dapFont.regular16
                    selected: false
                    onClicked:
                    {
                        button25.selected = false
                        button50.selected = true
                        button75.selected = false
                        button100.selected = false

                        textAmount.text = balanceValue*0.5
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
    //                fontButton: mainFont.dapFont.regular16
                    selected: false
                    onClicked:
                    {
                        button25.selected = false
                        button50.selected = false
                        button75.selected = true
                        button100.selected = false

                        textAmount.text = balanceValue*0.75
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
    //                fontButton: mainFont.dapFont.regular16
                    selected: false
                    onClicked:
                    {
                        button25.selected = false
                        button50.selected = false
                        button75.selected = false
                        button100.selected = true

                        textAmount.text = balanceValue
                    }
                }
            }

        }

        ColumnLayout
        {
            id: blockTotal
            Layout.fillWidth: true

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
                        color: "white"
                        font.pointSize: 10
                        text: qsTr("Total")
                    }
                }
            }

            Rectangle
            {
                Layout.fillWidth: true
                Layout.minimumHeight: 35
                Layout.leftMargin: 10
                Layout.rightMargin: 10

                border.color: "white"
                color: "transparent"
                radius: 4

                RowLayout
                {
                    anchors.fill: parent

                    TextField {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        horizontalAlignment: Text.AlignLeft

                        placeholderText: "0.0"
                        color: "white"
                        font.pointSize: 10
    //                    font: mainFont.dapFont.medium14

                        background: Rectangle{color:"transparent"}
                    }

                    Text
                    {
    //                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.rightMargin: 10
                        verticalAlignment: Qt.AlignVCenter
                        color: "white"
                        font.pointSize: 10
                        text: tokenName
                    }
                }
            }

        }

        DapButton
        {
            Layout.fillWidth: true
            Layout.topMargin: 5
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            implicitHeight: 36
            textButton: qsTr("Create order")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
//                fontButton: mainFont.dapFont.regular16

            onClicked:
            {
                var date = new Date()

                logicStock.addNewOrder(
                    date.toLocaleString(Qt.locale("en_EN"),
                    "yyyy-MM-dd hh:mm:ss"),
                    "CELL/USDT", "Market", "Sell",
                    "1234.4356", "674221.23", "1 day")
            }
        }

        Item
        {
            Layout.fillHeight: true

        }
    }

}


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
    }

    Rectangle
    {
        enabled: false
        Layout.fillWidth: true
        Layout.minimumHeight: 40 * pt
        Layout.maximumHeight: 40 * pt
        Layout.topMargin: 12
        Layout.leftMargin: 16
        Layout.rightMargin: 16

        border.color: currTheme.borderColor
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
                color: currTheme.textColorGray
                font: mainFont.dapFont.regular16

                background: Rectangle{color:"transparent"}
            }

            Text
            {
                Layout.fillHeight: true
                Layout.rightMargin: 10
                verticalAlignment: Qt.AlignVCenter
                color: currTheme.textColorGray
                font: mainFont.dapFont.regular16
                text: qsTr("Market")
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

    Rectangle
    {
        Layout.fillWidth: true
        Layout.topMargin: 12
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.minimumHeight: 40 * pt
        Layout.maximumHeight: 40 * pt

        border.color: currTheme.borderColor
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

                placeholderText: "0.0"
                color: currTheme.textColor
                font: mainFont.dapFont.regular16

                background: Rectangle{color:"transparent"}
            }

            Text
            {
                Layout.fillHeight: true
                Layout.rightMargin: 10
                verticalAlignment: Qt.AlignVCenter
                color: currTheme.textColor
                font: mainFont.dapFont.regular16
                text: qsTr("CELL")
            }
        }
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
            fontButton: mainFont.dapFont.regular12
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
            fontButton: mainFont.dapFont.regular12
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
            fontButton: mainFont.dapFont.regular12
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

    Rectangle
    {
        Layout.fillWidth: true
        Layout.topMargin: 12
        color: currTheme.backgroundMainScreen
        height: 30 * pt
        Text
        {
            color: currTheme.textColor
            text: qsTr("Total")
            font: mainFont.dapFont.medium12
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 20 * pt
            anchors.bottomMargin: 5 * pt
        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        Layout.topMargin: 12
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.minimumHeight: 40 * pt
        Layout.maximumHeight: 40 * pt

        border.color: currTheme.borderColor
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
                color: currTheme.textColor
                font: mainFont.dapFont.regular16

                background: Rectangle{color:"transparent"}
            }

            Text
            {
                Layout.fillHeight: true
                Layout.rightMargin: 10
                verticalAlignment: Qt.AlignVCenter
                color: currTheme.textColor
                font: mainFont.dapFont.regular16
                text: tokenName
            }
        }
    }
}

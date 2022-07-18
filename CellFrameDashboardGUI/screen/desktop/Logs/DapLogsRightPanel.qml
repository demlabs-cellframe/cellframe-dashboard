import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"


Page {

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 * pt

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16 * pt
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt
                font: mainFont.dapFont.medium14
                color: currTheme.textColor
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Requests logs")
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            color: currTheme.backgroundMainScreen
            height: 30 * pt
            Text
            {
                color: currTheme.textColor
                text: qsTr("Requests to work with a wallet")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        ListView
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: dapMessageLogBuffer
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            delegate:
                ColumnLayout{
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Text
                    {
                        Layout.fillWidth: true
                        Layout.topMargin: 16
                        Layout.leftMargin: 16
                        Layout.rightMargin: 16
                        text: infoText
                        color: currTheme.textColor
                        font: mainFont.dapFont.regular13
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WordWrap
                    }

                    RowLayout{
                        Layout.fillWidth: true
                        Layout.leftMargin: 16
                        Layout.rightMargin: 16
                        Layout.topMargin: 12
                        spacing: 0

                        Text{
                            Layout.alignment: Qt.AlignLeft
                            text: reply
                            color: reply === "Denied" ? currTheme.textColorRed : currTheme.textColorLightGreen
                            font: mainFont.dapFont.regular13
                            horizontalAlignment: Text.AlignLeft

                        }

                        Item{Layout.fillWidth: true}
                        Text{
                            Layout.alignment: Qt.AlignRight
                            text: date
                            color: currTheme.textColorGrayThree
                            font: mainFont.dapFont.regular13
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                    Rectangle
                    {
                        Layout.topMargin: 12
                        Layout.fillWidth: true
                        height: 1 * pt
                        color: currTheme.lineSeparatorColor
                    }
                }
            }

    }
}

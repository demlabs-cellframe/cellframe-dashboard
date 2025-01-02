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
            height: 42 

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter

                font: mainFont.dapFont.bold14
                color: currTheme.white
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Requests logs")
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            color: currTheme.mainBackground
            height: 30 
            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter

                font: mainFont.dapFont.medium12
                color: currTheme.white
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Requests to work with a wallet")
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
                        Layout.topMargin: 14
                        Layout.leftMargin: 16
                        Layout.rightMargin: 16
                        text: infoText
                        color: currTheme.white
                        font: mainFont.dapFont.regular14
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WordWrap
                    }

                    RowLayout{
                        Layout.fillWidth: true
                        Layout.leftMargin: 16
                        Layout.rightMargin: 16
                        Layout.topMargin: 8
                        spacing: 0

                        Text{
                            Layout.alignment: Qt.AlignLeft
                            text: reply
                            color: reply === "Denied" ? currTheme.red : currTheme.lightGreen
                            font: mainFont.dapFont.regular14
                            horizontalAlignment: Text.AlignLeft

                        }

                        Item{Layout.fillWidth: true}

                        Text{
                            Layout.alignment: Qt.AlignRight
                            text: date
                            color: currTheme.gray
                            font: mainFont.dapFont.regular13
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                    Rectangle
                    {
                        Layout.topMargin: 13
                        Layout.fillWidth: true
                        height: 1 
                        color: currTheme.mainBackground
                    }
                }
            }

    }
}

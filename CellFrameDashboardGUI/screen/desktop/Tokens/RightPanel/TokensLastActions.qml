import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"

Page
{
    id: control

    background: Rectangle {
        color: "transparent"
    }


    property var modelLastActions:
        [
            {
                network: "network1",
                status: "Local",
                sign: "+",
                amount: "412.8",
                name: "token1",
                date: "Today"
            },
            {
                network: "network1",
                status: "Mempool (X Confirms)",
                sign: "+",
                amount: "103",
                name: "token4",
                date: "July, 22"
            },
            {
                network: "network3",
                status: "Canceled",
                sign: "-",
                amount: "22.345",
                name: "token1",
                date: "December, 21"
            },
            {
                network: "network1",
                status: "Successful (X Confirms)",
                sign: "+",
                amount: "264.11",
                name: "token4",
                date: "December, 20"
            },
            {
                network: "network4",
                status: "Local",
                sign: "-",
                amount: "666.666",
                name: "token1",
                date: "November, 14"
            },
            {
                network: "network4",
                status: "Successful (X Confirms)",
                sign: "-",
                amount: "932.16",
                name: "token1",
                date: "November, 11"
            }
        ]

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 38 * pt

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 14 * pt
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt
                font: mainFont.dapFont.bold14
                color: currTheme.textColor
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Last actions")
            }
        }



        ListView
        {
            id: lastActionsView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: modelLastActions
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate:
                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 16 * pt
                    anchors.rightMargin: 16 * pt
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignLeft
                    color: currTheme.textColor
                    text: model[index].date//logicExplorer.getDateString(payDate)
                    font: mainFont.dapFont.medium12
                }

            delegate: Item {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5 * pt
                anchors.rightMargin: 5 * pt
                width: lastActionsView.width
                height: 50 * pt

                RowLayout
                {
                    anchors.fill: parent
                    anchors.rightMargin: 20 * pt
                    anchors.leftMargin: 16 * pt

                    ColumnLayout
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: 2 * pt

                        Text
                        {
                            Layout.fillWidth: true
                            text: modelData.network
                            color: currTheme.textColor
                            font: mainFont.dapFont.regular11
                            elide: Text.ElideRight
                        }

                        Text
                        {
                            Layout.fillWidth: true
                            text: modelData.status
                            color: currTheme.textColorGrayTwo
                            font: mainFont.dapFont.regular12
                        }
                    }

                    Text
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignRight
                        verticalAlignment: Qt.AlignVCenter
                        color: currTheme.textColor
                        text: modelData.sign + modelData.amount + " " + modelData.name
                        font: mainFont.dapFont.regular14
                    }
                }

                Rectangle
                {
                    width: parent.width
                    height: 1 * pt
                    color: currTheme.lineSeparatorColor
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
}

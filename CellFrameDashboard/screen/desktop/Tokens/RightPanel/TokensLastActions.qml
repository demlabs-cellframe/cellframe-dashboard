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
            model: logicTokens.modelLastActions
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

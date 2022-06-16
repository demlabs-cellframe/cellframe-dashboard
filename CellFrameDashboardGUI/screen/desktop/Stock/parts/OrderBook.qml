import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Rectangle
{
    ListModel {
        id: accuracyModel
        ListElement {
            value: 0.0001
        }
        ListElement {
            value: 0.001
        }
        ListElement {
            value: 0.01
        }
        ListElement {
            value: 0.1
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 10
//            Layout.rightMargin: 10

            spacing: 10

            Text {
                font.pointSize: 12
                font.bold: true
                color: "white"

                text: qsTr("Orders")
            }

            Item {
                Layout.minimumWidth: 10
            }

            Image {
                source: "qrc:/screen/desktop/Stock/icons/icon1.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        sellView.visible = true
                        buyView.visible = true
                    }
                }
            }

            Image {
                source: "qrc:/screen/desktop/Stock/icons/icon2.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        sellView.visible = false
                        buyView.visible = true
                    }
                }
            }

            Image {
                source: "qrc:/screen/desktop/Stock/icons/icon3.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        sellView.visible = true
                        buyView.visible = false
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            DapComboBox
            {
                Layout.minimumWidth: 120
                height: 35
                font.pointSize: 10
                mainTextRole: "value"

                model: accuracyModel
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 25

            color: currTheme.backgroundMainScreen

            RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                Text
                {
                    Layout.minimumWidth: 100
                    color: "white"
                    font.pointSize: 10
                    text: "Price(ETH)"
                }

                Text
                {
                    Layout.fillWidth: true
                    color: "white"
                    font.pointSize: 10
                    text: "Amount(CELL)"
                }

                Text
                {
                    horizontalAlignment: Qt.AlignRight
                    color: "white"
                    font.pointSize: 10
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
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            model: sellBookModel

            delegate:
                ColumnLayout
                {
                    height: 32
                    width: parent.width

                    RowLayout
                    {
                        Layout.fillWidth: true
                        Layout.topMargin: 5
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10

                        Text
                        {
                            Layout.minimumWidth: 100
                            color: currTheme.textColorRed
                            font.pointSize: 10
                            text: price
                        }

                        Text
                        {
                            Layout.fillWidth: true
                            color: "white"
                            font.pointSize: 10
                            text: amount
                        }

                        Text
                        {
                            horizontalAlignment: Qt.AlignRight
                            color: "white"
                            font.pointSize: 10
                            text: total
                        }
                    }

                    Rectangle
                    {
                        Layout.fillWidth: true
                        height: 1
                        visible: index <
                                 parent.ListView.view.model.count-1

                        color: currTheme.lineSeparatorColor
                    }
                }
            Layout.bottomMargin: 12
        }

        ColumnLayout
        {
            Layout.fillWidth: true
            spacing: 0

            Rectangle
            {
                Layout.fillWidth: true
                height: 1
                color: currTheme.lineSeparatorColor
            }

            Text
            {
                Layout.fillWidth: true
                Layout.topMargin: 10
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.bottomMargin: 10

                color: currTheme.textColorRed
                font.pointSize: 10
                font.bold: true

                text: "0.2911"
            }

            Rectangle
            {
                Layout.fillWidth: true
                height: 1
                color: currTheme.lineSeparatorColor
            }
        }

        ListView
        {
            id: buyView

            Layout.topMargin: 12
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            model: buyBookModel

            delegate:
                ColumnLayout
                {
                    height: 32
                    width: parent.width

                    RowLayout
                    {
                        Layout.fillWidth: true
                        Layout.topMargin: 5
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10

                        Text
                        {
                            Layout.minimumWidth: 100
                            color: currTheme.textColorGreen
                            font.pointSize: 10
                            text: price
                        }

                        Text
                        {
                            Layout.fillWidth: true
                            color: "white"
                            font.pointSize: 10
                            text: amount
                        }

                        Text
                        {
                            horizontalAlignment: Qt.AlignRight
                            color: "white"
                            font.pointSize: 10
                            text: total
                        }
                    }

                    Rectangle
                    {
                        Layout.fillWidth: true
                        height: 1
                        visible: index <
                                 parent.ListView.view.model.count-1

                        color: currTheme.lineSeparatorColor
                    }
                }
        }

    }


    color: currTheme.backgroundElements
}

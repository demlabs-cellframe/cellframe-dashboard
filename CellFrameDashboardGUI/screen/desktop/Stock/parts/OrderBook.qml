import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Rectangle
{

    ListModel {
        id: sellModel
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
    }
    ListModel {
        id: buyModel
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
        ListElement {
            price: 0.2911
            amount: 23452.23
            total: 573.45677
        }
    }

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
                source: "qrc:/icon1.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        sellView.visible = true
                        buyView.visible = true
                    }
                }
            }

            Image {
                source: "qrc:/icon2.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        sellView.visible = false
                        buyView.visible = true
                    }
                }
            }

            Image {
                source: "qrc:/icon3.png"

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

            color: "#202020"

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

            model: sellModel

            delegate:
                ColumnLayout
                {
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
                            color: "red"
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

                        color: "black"
                    }
                }
        }

        ColumnLayout
        {
            Layout.fillWidth: true
            spacing: 0

            Rectangle
            {
                Layout.fillWidth: true
                height: 1
                color: "black"
            }

            Text
            {
                Layout.fillWidth: true
                Layout.topMargin: 10
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.bottomMargin: 10

                color: "red"
                font.pointSize: 10
                font.bold: true

                text: "0.2911"
            }

            Rectangle
            {
                Layout.fillWidth: true
                height: 1
                color: "black"
            }
        }

        ListView
        {
            id: buyView

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            model: buyModel

            delegate:
                ColumnLayout
                {
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
                            color: "green"
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

                        color: "black"
                    }
                }
        }

//        Item {
//            Layout.fillHeight: true
//        }
    }


    color: "#404040"
}

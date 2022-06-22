import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Rectangle
{
    property var layoutCoeff:
        ( new Map([
            ["date", 110],
            ["closedDate", 110],
            ["pair", 80],
            ["type", 80],
            ["side", 40],
            ["averagePrice", 70],
            ["price", 70],
            ["filled", 60],
            ["amount", 80],
            ["total", 70],
            ["triggerCondition", 110],
            ["status", 60]
    ]))

    ListModel {
        id: pairModel
        ListElement {
            name: "All"
        }
        ListElement {
            name: "CELL/ETH"
        }
        ListElement {
            name: "CELL/DAI"
        }
        ListElement {
            name: "CELL/USDT"
        }
    }

    ListModel {
        id: modeModel
        ListElement {
            name: "All"
        }
        ListElement {
            name: "Buy"
        }
        ListElement {
            name: "Sell"
        }
    }

    color: currTheme.backgroundElements

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        RowLayout
        {
            Layout.fillWidth: true
//            Layout.margins: 10
            Layout.leftMargin: 16
            Layout.bottomMargin: 12
            spacing: 20

            ListModel {
                id: selectorModel
                ListElement {
                    name: "All"
                }
                ListElement {
                    name: "1 Day"
                }
                ListElement {
                    name: "1 Week"
                }
                ListElement {
                    name: "1 Month"
                }
                ListElement {
                    name: "3 Month"
                }

            }

            DapSelector
            {
                height: 35

                selectorModel: selectorModel
                selectorListView.interactive: false

                onItemSelected:
                {
                    print("onItemSelected", "currentIndex", currentIndex)
                }
            }
            RowLayout{
                spacing: 0
                Layout.leftMargin: 10

                Text{
                    text: "Pair: "
                    color: currTheme.textColor
                    font: mainFont.dapFont.regular16
                }

                DapComboBox
                {
                    Layout.minimumWidth: 150
                    font: mainFont.dapFont.regular16

                    model: pairModel
                }

            }

            RowLayout{
                spacing: 0

                Text{
                    text: "Side: "
                    color: currTheme.textColor
                    font: mainFont.dapFont.regular16
                }


                DapComboBox
                {
                    Layout.minimumWidth: 120
                    font: mainFont.dapFont.regular16

                    model: modeModel
                }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 25

            color: currTheme.backgroundMainScreen

            RowOrderHistory
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 10
            }
        }

        ListView
        {
            id: openOrdersView

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            model: orderHistoryModel

            delegate:
                ColumnLayout
                {
                    width: parent.width
                    height: 50

                    RowOrderHistory
                    {
                        Layout.minimumWidth:
                            parent.width - Layout.leftMargin
                            - Layout.rightMargin
                        Layout.topMargin: 5
                        Layout.leftMargin: 16
                        Layout.rightMargin: 10

                        isHeader: false
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
}

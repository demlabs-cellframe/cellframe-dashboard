import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    property var layoutCoeff:
        ( new Map([
            ["date", 145],
            ["pair", 80],
            ["type", 80],
            ["side", 40],
            ["price", 80],
            ["amount", 80],
            ["filled", 60],
            ["total", 80],
            ["triggerCondition", 120],
            ["expiresIn", 70],
            ["cancel", 60]
    ]))


    color: currTheme.backgroundElements


    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Rectangle
        {
            Layout.fillWidth: true
            height: 25

            color: currTheme.backgroundMainScreen

            RowOpenOrder
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

            model: openOrdersModel

            delegate:
                ColumnLayout
                {
                    width: parent.width
                    height: 50

                    RowOpenOrder
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

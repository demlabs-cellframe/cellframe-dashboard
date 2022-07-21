import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import Qt.labs.platform 1.0
import "qrc:/widgets"

Item
{
    id: defaultRightPanel

    ListModel
    {
        id: periodModel
        ListElement { name: "All time" }
        ListElement { name: "Today" }
        ListElement { name: "Yesterday" }
        ListElement { name: "Last week" }
        ListElement { name: "This month" }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 3
        spacing: 0

        Text {
            Layout.minimumHeight: 35
            Layout.maximumHeight: 35
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            text: qsTr("Orders")
        }

        ColumnLayout
        {
            Layout.leftMargin: -13
            Layout.topMargin: 3
            spacing: 0

            DapRadioButton
            {
                id: butOpenOrders
                Layout.fillWidth: true
                nameRadioButton: qsTr("Open orders")
                indicatorInnerSize: 46
                spaceIndicatorText: 3
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                checked: true
                onClicked: {
                    setCurrentMainScreen(openOrders)
                }
            }

            DapRadioButton
            {
                id: butOrdersHistory
                Layout.topMargin: -5
                Layout.fillWidth: true
                nameRadioButton: qsTr("Orders History")
                indicatorInnerSize: 46
                spaceIndicatorText: 3
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    setCurrentMainScreen(ordersHistory)
                }
            }
        }

        Text {
            Layout.topMargin: 24
            Layout.minimumHeight: 35
            Layout.maximumHeight: 35
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            text: qsTr("Pair")
        }

        DapComboBox
        {
            id: comboboxPair
            Layout.topMargin: 16
            Layout.fillWidth: true
            height: 42
            font: mainFont.dapFont.regular16
            defaultText: qsTr("All pairs")
            mainTextRole: "pair"
            onCurrentIndexChanged: setFilterPair(model.get(currentIndex).pair)
        }

        Text {
            Layout.topMargin: 24
            Layout.minimumHeight: 35
            Layout.maximumHeight: 35
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            text: qsTr("Period")
        }

        DapComboBox
        {
            id: comboboxPeriod
            Layout.topMargin: 16
            Layout.fillWidth: true
            height: 42
            font: mainFont.dapFont.regular16
            defaultText: qsTr("All time")
            model: periodModel
            mainTextRole: "name"
            onCurrentIndexChanged: setFilterPeriod(periodModel.get(currentIndex).name)
        }

        Text {
            Layout.topMargin: 24
            Layout.minimumHeight: 35
            Layout.maximumHeight: 35
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            text: qsTr("Side")
        }

        ColumnLayout
        {
            Layout.leftMargin: -13
            Layout.topMargin: 3
            spacing: 0

            DapRadioButton
            {
                id: buttonSelectionAllStatuses
                Layout.fillWidth: true
                nameRadioButton: qsTr("Both")
                indicatorInnerSize: 46
                spaceIndicatorText: 3
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                checked: true
                onClicked: {
                    setFilterSide("Both")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionBuy
                Layout.fillWidth: true
                Layout.topMargin: -5
                nameRadioButton: qsTr("Buy")
                indicatorInnerSize: 46
                spaceIndicatorText: 3
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    setFilterSide("Buy")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionSell
                Layout.fillWidth: true
                Layout.topMargin: -5
                nameRadioButton: qsTr("Sell")
                indicatorInnerSize: 46
                spaceIndicatorText: 3
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    setFilterSide("Sell")
                }
            }
        }

        Rectangle
        {
            id: frameBottom
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
        }
    }

    Connections{
        target: myOrdersTab
        onInitCompleted: comboboxPair.model = pairModelFilter
    }
}

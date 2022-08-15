import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import Qt.labs.platform 1.0
import "qrc:/widgets"

Item
{
    id: defaultRightPanel

/*    ListModel
    {
        id: periodModel
        ListElement { name: "All time" }
        ListElement { name: "Today" }
        ListElement { name: "Yesterday" }
        ListElement { name: "Last week" }
        ListElement { name: "This month" }
    }*/

    Component.onCompleted:
    {
        setCurrentMainScreen(openOrders)
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


        DapSelectorSwitch
        {
            height: 35
            Layout.topMargin: 10
            firstName: qsTr("Open orders")
            secondName: qsTr("Orders History")
            itemHorisontalBorder: 16

            onToggled:
            {
                if (firstSelected)
                {
                    setCurrentMainScreen(openOrders)
                    textPeriod.visible = false
                    layoutPeriod1.visible = false
                    layoutPeriod2.visible = false
                    setFilterPeriod("All time")
                }
                else
                {
                    setCurrentMainScreen(ordersHistory)
                    textPeriod.visible = true
                    layoutPeriod1.visible = true
                    layoutPeriod2.visible = true

                    if (button1Day.selected)
                        setFilterPeriod("1 Day")
                    if (button1Week.selected)
                        setFilterPeriod("1 Week")
                    if (button1Month.selected)
                        setFilterPeriod("1 Month")
                    if (button3Month.selected)
                        setFilterPeriod("3 Month")
                    if (button6Month.selected)
                        setFilterPeriod("6 Month")
                    if (button1Year.selected)
                        setFilterPeriod("1 Year")
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

        Text
        {
            id: textPeriod
            visible: false

            Layout.topMargin: 24
            Layout.minimumHeight: 35
            Layout.maximumHeight: 35
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            text: qsTr("Period")
        }

        RowLayout
        {
            id: layoutPeriod1
            visible: false

            Layout.fillWidth: true
            Layout.topMargin: 12

            DapButton
            {
                id: button1Day
                Layout.fillWidth: true
                implicitHeight: 25
                textButton: qsTr("1 Day")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: true
                onClicked:
                {
                    button1Day.selected = true
                    button1Week.selected = false
                    button1Month.selected = false
                    button3Month.selected = false
                    button6Month.selected = false
                    button1Year.selected = false

                    setFilterPeriod("1 Day")
                }
            }

            DapButton
            {
                id: button1Week
                Layout.fillWidth: true
                implicitHeight: 25
                textButton: qsTr("1 Week")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button1Day.selected = false
                    button1Week.selected = true
                    button1Month.selected = false
                    button3Month.selected = false
                    button6Month.selected = false
                    button1Year.selected = false

                    setFilterPeriod("1 Week")
                }
            }

            DapButton
            {
                id: button1Month
                Layout.fillWidth: true
                implicitHeight: 25
                textButton: qsTr("1 Month")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button1Day.selected = false
                    button1Week.selected = false
                    button1Month.selected = true
                    button3Month.selected = false
                    button6Month.selected = false
                    button1Year.selected = false

                    setFilterPeriod("1 Month")
                }
            }

        }

        RowLayout
        {
            id: layoutPeriod2
            visible: false

            Layout.fillWidth: true
            Layout.topMargin: 12

            DapButton
            {
                id: button3Month
                Layout.fillWidth: true
                implicitHeight: 25
                textButton: qsTr("3 Month")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button1Day.selected = false
                    button1Week.selected = false
                    button1Month.selected = false
                    button3Month.selected = true
                    button6Month.selected = false
                    button1Year.selected = false

                    setFilterPeriod("3 Month")
                }
            }

            DapButton
            {
                id: button6Month
                Layout.fillWidth: true
                implicitHeight: 25
                textButton: qsTr("6 Month")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button1Day.selected = false
                    button1Week.selected = false
                    button1Month.selected = false
                    button3Month.selected = false
                    button6Month.selected = true
                    button1Year.selected = false

                    setFilterPeriod("6 Month")
                }
            }

            DapButton
            {
                id: button1Year
                Layout.fillWidth: true
                implicitHeight: 25
                textButton: qsTr("1 Year")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button1Day.selected = false
                    button1Week.selected = false
                    button1Month.selected = false
                    button3Month.selected = false
                    button6Month.selected = false
                    button1Year.selected = true

                    setFilterPeriod("1 Year")
                }
            }

        }

/*        DapComboBox
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
        }*/

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
            Layout.topMargin: 10
            spacing: 10

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

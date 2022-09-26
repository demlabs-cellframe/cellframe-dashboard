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
        setFilterSide("buy")
        setCurrentMainScreen(allOrders)
        buysellbothSelector.selectorListView.currentIndex = 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        spacing: 0

        Text {
            Layout.minimumHeight: 35
            Layout.maximumHeight: 35
//            Layout.leftMargin: 16
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            text: qsTr("Orders")
        }

        ListModel {
            id: selectorModel
            ListElement {
                name: qsTr("Orders")
            }
            ListElement {
                name: qsTr("My orders")
            }
            ListElement {
                name: qsTr("Order history")
            }
        }

        DapSelector
        {
            height: 35
//            Layout.fillWidth: true
            Layout.topMargin: 10
            itemHorisontalBorder: 20

            selectorModel: selectorModel

            onItemSelected:
            {
//                print("onItemSelected", "currentIndex", currentIndex)

                if (currentIndex === 0)
                {
                    setFilterSide("buy")
                    setCurrentMainScreen(allOrders)

                    buysellSelector.setSelected("first")
                    buysellText.visible = true
                    buysellSelector.visible = true
                    buysellbothSelector.visible = false
                    textPair.visible = false
                    comboboxPair.visible = false
                    textSide.visible = false
                    buttonsSide.visible = false
                    textPeriod.visible = false
                    layoutPeriod1.visible = false
                    layoutPeriod2.visible = false
                }
                if (currentIndex === 1)
                {
                    setFilterSide("Both")
                    setCurrentMainScreen(myOrders)

                    buysellbothSelector.selectorListView.currentIndex = 2
                    buysellText.visible = true
                    buysellSelector.visible = false
                    buysellbothSelector.visible = true
                    textPair.visible = true
                    comboboxPair.visible = true
                    textSide.visible = true
                    buttonsSide.visible = true
                    textPeriod.visible = false
                    layoutPeriod1.visible = false
                    layoutPeriod2.visible = false
                    setFilterPeriod("All time")
                }
                if (currentIndex === 2)
                {
                    setFilterSide("Both")
                    setCurrentMainScreen(ordersHistory)

                    buysellbothSelector.selectorListView.currentIndex = 2
                    buysellText.visible = true
                    buysellSelector.visible = false
                    buysellbothSelector.visible = true
                    textPair.visible = true
                    comboboxPair.visible = true
                    textSide.visible = true
                    buttonsSide.visible = true
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
            id: buysellText
            visible: true

            Layout.topMargin: 24
            Layout.minimumHeight: 35
            Layout.maximumHeight: 35
//            Layout.leftMargin: 16
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            text: qsTr("Side")
        }

        ListModel {
            id: sideModel
            ListElement {
                name: qsTr("Buy")
                color: "#84BE00"
            }
            ListElement {
                name: qsTr("Sell")
                color: "#FF5F5F"
            }
            ListElement {
                name: qsTr("Both")
                color: "#A361FF"
            }
        }

        DapSelector
        {
            id: buysellbothSelector
            visible: false
            Layout.topMargin: 10
            height: 35
            itemHorisontalBorder: 41

            selectorModel: sideModel

            onItemSelected:
            {
                if (currentIndex === 0)
                {
                    setFilterSide("Buy")
                }
                if (currentIndex === 1)
                {
                    setFilterSide("Sell")
                }
                if (currentIndex === 2)
                {
                    setFilterSide("Both")
                }
            }

        }

        DapSelectorSwitch
        {
            id: buysellSelector
            visible: true

            Layout.topMargin: 10
            height: 35
            firstName: qsTr("Buy")
            secondName: qsTr("Sell")
            firstColor: currTheme.textColorGreen
            secondColor: currTheme.textColorRed
            itemHorisontalBorder: 68

            onToggled:
            {
                if (secondSelected)
                    setFilterSide("sell")
                else
                    setFilterSide("buy")
//                isSell = secondSelected
//                if (isSell)
//                {
//                    textMode.text = qsTr("Sell ") + logicMainApp.token1Name
//                }
//                else
//                {
//                    textMode.text = qsTr("Buy ") + logicMainApp.token1Name

//                }
//                sellBuyChanged()
            }
        }

        Text
        {
            id: textPair
            visible: false

            Layout.topMargin: 24
            Layout.minimumHeight: 35
            Layout.maximumHeight: 35
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            text: qsTr("Pair")
        }

        DapCustomComboBox
        {
            id: comboboxPair
            visible: false

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

/*        Text {
            id: textSide
            visible: false

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
            id: buttonsSide
            visible: false

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
        }*/

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

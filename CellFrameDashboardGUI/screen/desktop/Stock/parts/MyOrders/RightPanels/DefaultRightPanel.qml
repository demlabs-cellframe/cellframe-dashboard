import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import Qt.labs.platform 1.0
import "qrc:/widgets"

Item
{
    id: defaultRightPanel

    Component.onCompleted:
    {
        ordersModel.setOrderFilter("Buy", "All", "OPENED")
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
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.white
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
            Layout.topMargin: 10
            itemHorisontalBorder: 20

            selectorModel: selectorModel

            onItemSelected:
            {

                if (currentIndex === 0)
                {
                    ordersModel.setOrderFilter("Buy", "All", "OPENED")
                    setCurrentMainScreen(allOrders)

                    buysellSelector.setSelected("first")
                    buysellText.visible = true
                    buysellSelector.visible = true
                    buysellbothSelector.visible = false
                    textPair.visible = false
                    comboboxPair.visible = false
                    comboboxPair.displayText = "All pairs"
//                    textSide.visible = false
//                    buttonsSide.visible = false
                    textPeriod.visible = false
                    layoutPeriod1.visible = false
                    layoutPeriod2.visible = false
                }
                if (currentIndex === 1)
                {
                    ordersModel.setOrderFilter("Both", "My_orders")
                    //setFilterSide("Both")
                    setCurrentMainScreen(myOrders)

                    buysellbothSelector.selectorListView.currentIndex = 2
                    buysellText.visible = true
                    buysellSelector.visible = false
                    buysellbothSelector.visible = true
                    textPair.visible = true
                    comboboxPair.visible = true
                    comboboxPair.displayText = "All pairs"
//                    textSide.visible = true
//                    buttonsSide.visible = true
                    textPeriod.visible = false
                    layoutPeriod1.visible = false
                    layoutPeriod2.visible = false
                    setFilterPeriod("All time")
                }
                if (currentIndex === 2)
                {
                    ordersModel.setOrderFilter("Both", "All", "CLOSED")
                    //setFilterSide("Both")
                    setCurrentMainScreen(ordersHistory)

                    buysellbothSelector.selectorListView.currentIndex = 2
                    buysellText.visible = true
                    buysellSelector.visible = false
                    buysellbothSelector.visible = true
                    textPair.visible = true
                    comboboxPair.visible = true
                    comboboxPair.displayText = "All pairs"
//                    textSide.visible = true
//                    buttonsSide.visible = true
                    textPeriod.visible = true
                    layoutPeriod1.visible = true
                    layoutPeriod2.visible = true

                    if (button1Day.selected)
                        ordersModel.setPeriodOrderFilter("Day")
                    if (button1Week.selected)
                        ordersModel.setPeriodOrderFilter("Week")
                    if (button1Month.selected)
                        ordersModel.setPeriodOrderFilter("Month")
                    if (button3Month.selected)
                        ordersModel.setPeriodOrderFilter("3 Month")
                    if (button6Month.selected)
                        ordersModel.setPeriodOrderFilter("6 Month")
                    if (button1Year.selected)
                        ordersModel.setPeriodOrderFilter("All")
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
            color: currTheme.white
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
            itemHorisontalBorder: 40

            radius: 30

            selectorModel: sideModel

            onItemSelected:
            {
                if (currentIndex === 0)
                {
                    ordersModel.setFilterSide("Buy")
                }
                if (currentIndex === 1)
                {
                    ordersModel.setFilterSide("Sell")
                }
                if (currentIndex === 2)
                {
                    ordersModel.setFilterSide("Both")
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
            firstColor: currTheme.green
            secondColor: currTheme.red
            itemHorisontalBorder: 68

            onToggled:
            {
                if (secondSelected)
                    {
                        ordersModel.setFilterSide("Sell")
                    }
                    //setFilterSide("sell")
                else
                {
                    ordersModel.setFilterSide("Buy")
                }
                   // setFilterSide("buy")
//                isSell = secondSelected
//                if (isSell)
//                {
//                    textMode.text = qsTr("Sell ") + tokenPairsWorker.tokenBuy
//                }
//                else
//                {
//                    textMode.text = qsTr("Buy ") + tokenPairsWorker.tokenBuy

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
            color: currTheme.white
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
            //TODO: These parameters have been fixed so far and we are not touching them from here yet
            //onCurrentIndexChanged: ordersModel.setPairOrderFilter(model.get(currentIndex).name)
            model: dexRightPairModel
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
            color: currTheme.white
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
                    resetButtons()
                    selected = true
                    ordersModel.setPeriodOrderFilter("Day")
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
                    resetButtons()
                    selected = true
                    ordersModel.setPeriodOrderFilter("Week")
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
                    resetButtons()
                    selected = true
                    ordersModel.setPeriodOrderFilter("Month")
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
                    resetButtons()
                    selected = true
                    ordersModel.setPeriodOrderFilter("3 Month")
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
                    resetButtons()
                    selected = true
                    ordersModel.setPeriodOrderFilter("6 Month")
                }
            }

            DapButton
            {
                id: button1Year
                Layout.fillWidth: true
                implicitHeight: 25
                textButton: qsTr("All time")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    resetButtons()
                    selected = true
                    ordersModel.setPeriodOrderFilter("All")
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

    function resetButtons(){
        button1Day  .focus = false
        button1Week .focus = false
        button1Month.focus = false
        button3Month.focus = false
        button6Month.focus = false
        button1Year .focus = false

        button1Day.selected = false
        button1Week.selected = false
        button1Month.selected = false
        button3Month.selected = false
        button6Month.selected = false
        button1Year.selected = false

    }

    Connections{
        target: myOrdersTab
        //function onInitCompleted(){ comboboxPair.model = pairModelFilter}
    }
}

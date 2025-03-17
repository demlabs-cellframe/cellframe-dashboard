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
        if(!dexModule.isRegularTypePanel)
        {
            ordersModel.setOrderFilter("Sell", "Other", "OPENED")
            setCurrentMainScreen(allOrders)
            buysellbothSelector.selectorListView.currentIndex = 2
        }
        else
        {
            ordersModel.setOrderFilter("Sell", "My_orders", "OPENED")
            setCurrentMainScreen(myOrders)
            buysellText.visible = false
            buysellSelector.visible = false
            buysellbothSelector.visible = false
            textPair.visible = false
            comboboxPair.visible = false
            textPeriod.visible = false
            layoutPeriod1.visible = false
            layoutPeriod2.visible = false
        }

        updateOrderSelectorModel()

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
        }

        DapSelector
        {
            height: 35
            Layout.topMargin: 10
            itemHorisontalBorder: 20

            selectorModel: selectorModel

            onItemSelected:
            {
                if(!dexModule.isRegularTypePanel)
                {
                    if (currentIndex === 0)
                    {
                        ordersModel.setOrderFilter("Sell", "Other", "OPENED")
                        setCurrentMainScreen(allOrders)

                        buysellSelector.setSelected("first")
                        buysellText.visible = true
                        buysellSelector.visible = true
                        buysellbothSelector.visible = false
                        textPair.visible = false
                        comboboxPair.visible = false
                        textPeriod.visible = false
                        layoutPeriod1.visible = false
                        layoutPeriod2.visible = false
                    }
                    else if (currentIndex === 1)
                    {
                        ordersModel.setOrderFilter("Both", "My_orders", "OPENED")
                        setCurrentMainScreen(myOrders)

                        buysellbothSelector.selectorListView.currentIndex = 2
                        buysellText.visible = true
                        buysellSelector.visible = false
                        buysellbothSelector.visible = true
                        textPair.visible = false
                        comboboxPair.visible = false
                        textPeriod.visible = false
                        layoutPeriod1.visible = false
                        layoutPeriod2.visible = false
                        setFilterPeriod("All time")
                    }
                    else if (currentIndex === 2)
                    {
                        ordersModel.setOrderFilter("Both", "All", "CLOSED")
                        setCurrentMainScreen(ordersHistory)

                        buysellbothSelector.selectorListView.currentIndex = 2
                        buysellText.visible = true
                        buysellSelector.visible = false
                        buysellbothSelector.visible = true
                        textPair.visible = false
                        comboboxPair.visible = false
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
                else
                {
                    if (currentIndex === 0)
                    {
                        ordersModel.setOrderFilter("Sell", "My_orders", "OPENED")
                        setCurrentMainScreen(myOrders)

                        buysellbothSelector.selectorListView.currentIndex = 2
                        buysellText.visible = false
                        buysellSelector.visible = false
                        buysellbothSelector.visible = false
                        textPair.visible = false
                        comboboxPair.visible = false
                        textPeriod.visible = false
                        layoutPeriod1.visible = false
                        layoutPeriod2.visible = false
                        setFilterPeriod("All time")
                    }
                    else if (currentIndex === 1)
                    {
                        ordersModel.setOrderFilter("Sell", "My_orders", "CLOSED")
                        setCurrentMainScreen(ordersHistory)

                        buysellbothSelector.selectorListView.currentIndex = 2
                        buysellText.visible = false
                        buysellSelector.visible = false
                        buysellbothSelector.visible = false
                        textPair.visible = false
                        comboboxPair.visible = false
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
                // !!!!!!!!!!!!
                // TODO Here it is necessary to be careful, inverting the data is done for the logic of buying orders.
                if (secondSelected)
                    {
                        ordersModel.setFilterSide("Buy")
                    }
                else
                {
                    ordersModel.setFilterSide("Sell")
                }
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

    function updateOrderSelectorModel()
    {
        selectorModel.clear()
        if(!dexModule.isRegularTypePanel)
        {
            selectorModel.append({name: qsTr("Orders")})
        }
        selectorModel.append({name: qsTr("My orders")})
        selectorModel.append({name: qsTr("Order history")})
    }

    Connections{
        target: myOrdersTab
        //function onInitCompleted(){ comboboxPair.model = pairModelFilter}
    }
}

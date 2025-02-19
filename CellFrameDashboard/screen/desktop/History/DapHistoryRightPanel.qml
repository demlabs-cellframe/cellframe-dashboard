import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import "qrc:/widgets"

Item
{
    id: historyRightPanel

    signal currentStatusSelected(string status)

    signal currentPeriodSelected(string period, bool isRange)

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Text {
            Layout.minimumHeight: 35
            Layout.maximumHeight: 35
            Layout.leftMargin: 16
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.white
            text: qsTr("Status")
        }

        ColumnLayout
        {
//            Layout.margins: 3
            Layout.leftMargin: 3
            Layout.topMargin: 5
            spacing: 6

            DapRadioButton
            {
                id: buttonSelectionAllStatuses
                Layout.fillWidth: true
                nameRadioButton: qsTr("All statuses")
                checked: true
                indicatorInnerSize: 46
                spaceIndicatorText: 3
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
//                    historyWorker.setCurrentStatus("All statuses")
                    currentStatusSelected("All statuses")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionPending
                Layout.fillWidth: true
                nameRadioButton: qsTr("Pending")
                indicatorInnerSize: 46
                spaceIndicatorText: 3
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
//                    historyWorker.setCurrentStatus("Pending")
                    currentStatusSelected("Pending")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionSent
                Layout.fillWidth: true
                nameRadioButton: qsTr("Sent")
                indicatorInnerSize: 46
                spaceIndicatorText: 3
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
//                    historyWorker.setCurrentStatus("Sent")
                    currentStatusSelected("Sent")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionReceived
                Layout.fillWidth: true
                nameRadioButton: qsTr("Received")
                indicatorInnerSize: 46
                spaceIndicatorText: 3
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Received")
//                    historyWorker.setCurrentStatus("Received")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionError
                Layout.fillWidth: true
                nameRadioButton: qsTr("Declined")
                indicatorInnerSize: 46
                spaceIndicatorText: 3
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Declined")
//                    historyWorker.setCurrentStatus("Declined")
                }
            }
        }

        Text {
            Layout.topMargin: 27
            Layout.leftMargin: 16
            Layout.minimumHeight: 18
            Layout.maximumHeight: 18
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.white
            text: qsTr("Period")
        }

        // Period selection combo box
        Rectangle
        {
            id: frameComboBoxPeriod
            Layout.topMargin: 10
            implicitHeight: 60
            Layout.maximumHeight: 60
            Layout.fillWidth: true
            color: "transparent"

            ListModel
            {
                id: periodModel
                ListElement { name: qsTr("Today") }
                ListElement { name: qsTr("Yesterday") }
                ListElement { name: qsTr("Last week") }
//                ListElement { name: qsTr("this month") }
                ListElement { name: qsTr("Custom range")}
            }

            DapComboBoxCustomRange
            {
                id: comboboxPeriod
                model: periodModel

                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 10
                anchors.leftMargin: 15
                anchors.rightMargin: 15

                dapIndicatorImageNormal: "qrc:/Resources/"+pathTheme+"/icons/other/icon_arrow_down.png"
                dapIndicatorImageActive: "qrc:/Resources/"+pathTheme+"/icons/other/ic_arrow_up.png"
                dapSidePaddingNormal: 10
                dapSidePaddingActive: 10
                dapNormalColorText: currTheme.white
                dapHilightColorText: currTheme.mainBackground
                dapNormalColorTopText: currTheme.white
                dapHilightColorTopText: currTheme.white
                dapHilightColor: currTheme.lime
                dapHilightTopColor: currTheme.secondaryBackground //"blue" //currTheme.backgroundMainScreen
                dapNormalColor: currTheme.secondaryBackground
                dapNormalTopColor: currTheme.secondaryBackground //"blue" //currTheme.backgroundMainScreen
                dapWidthPopupComboBoxNormal: 318
                dapWidthPopupComboBoxActive: 318
                dapHeightComboBoxNormal: 46
                dapHeightComboBoxActive: 46
    //            dapBottomIntervalListElement: 8
                dapTopEffect: false
                x: popup.visible ? dapSidePaddingActive * (-1) : dapSidePaddingNormal
                dapPaddingTopItemDelegate: 8
                dapHeightListElement: 42
    //            dapIntervalListElement: 10
                dapIndicatorWidth: 24
                dapIndicatorHeight: dapIndicatorWidth
                dapIndicatorLeftInterval: 16
                dapColorTopNormalDropShadow: "#00000000"
                dapColorDropShadow: currTheme.shadowColor
                dapTextFont:  mainFont.dapFont.regular16
                dapDefaultMainLineText: qsTr("All time")
                dapIsDefaultNeedToAppend: true
                dapRangeElementWidth: 74
                dapRangeSpacing: 6
                dapRangeDefaultText: "dd.mm.yyyy"
                dapInactiveRangeTextFont:  mainFont.dapFont.regular14
                dapUnselectedRangeColorTopText: "#ACAAB5"
                dapActiveRangeTextFont:  mainFont.dapFont.medium14
                dapSelectedRangeColorTopText: currTheme.white

                dapCalendars:
                    DapCalendar
                    {
                        dapLeftPadding: 16
                        dapRightPadding: 16
                        dapTopPadding: 0
                        dapBottomPadding: 16
                        dapTitleTopPadding: 20
                        dapTitleBottomPadding: 14
                        dapButtonInterval: 8
                        dapTitleWidth: 108
                        dapDayWidth: 24
                        dapDayHeight: 24
                        dapDayLeftInterval: 8
                        dapDayTopInterval: 2
                        dapCalendarFont:  mainFont.dapFont.regular14

                        dapCalendarBackgroundColor: currTheme.mainBackground
                        dapNormalTextColor: currTheme.white
                        dapSelectedTextColor: currTheme.white
                        dapInvalidTextColor: "#908D9D"

                        dapNormalBackgroundColor: currTheme.secondaryBackground
                        dapSelectedBackgroundColor: currTheme.mainButtonColorNormal0

                        dapDayOfWeeksFormat: Locale.NarrowFormat
//                        dapPreviousYearButtonImage: "qrc:/resources/icons/previous_year_icon.png"
//                        dapPreviousMonthButtonImage: "qrc:/resources/icons/previous_month_icon.png"
//                        dapNextMonthButtonImage: "qrc:/resources/icons/next_month_icon.png"
//                        dapNextYearButtonImage: "qrc:/resources/icons/next_year_icon.png"

                        dapClickMonthImage: "qrc:/Resources/"+ pathTheme +"/icons/other/Arrow.png"
                        dapClickYearImage: "qrc:/Resources/"+ pathTheme +"/icons/other/Double_arrow.png"
                    }

                onDapResultTextChanged:
                {
                    currentPeriodSelected(dapResultText, dapIsRange)
                }
            }
        }

        Text {
            Layout.topMargin: 40
            Layout.leftMargin: 16
            Layout.minimumHeight: 18
            Layout.maximumHeight: 18
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.white
            text: qsTr("Network")
        }

        DapCustomComboBox
        {
            id: comboboxNetwork
            Layout.fillWidth: true
            Layout.topMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            leftMarginDisplayText: 10
            rightMarginIndicator: 10
            leftMarginPopupContain: 10
            rightMarginPopupContain: 10
            popupBorderWidth: 0
            changingRound: true
            isSingleColor: true
            isInnerShadow: false
            isNecessaryToHideCurrentIndex: true
            displayTextPopupColor: currTheme.white

            height: 40

            backgroundColorShow: currTheme.secondaryBackground
            backgroundColorNormal: currTheme.secondaryBackground
            background.radius: 4
            model: netListModel

            font: mainFont.dapFont.regular16

            defaultText: qsTr("Networks")

            isHighPopup:
            {
                var fullHeight = historyRightPanel.height
                var conteinHeight = delegateHeight * (count - 1)
                return fullHeight - y < height + conteinHeight
            }

            onCurrentDisplayTextChanged:
            {
                modelHistory.setNetworkFilter(displayText)
            }
        }

        Component.onDestruction:
        {
            modelHistory.setNetworkFilter("All")
            var data = ["All time", false]
            modelHistory.setCurrentPeriod(data)
            modelHistory.setCurrentStatus("All statuses")
        }

        Item
        {
            id: frameBottom
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}

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
            color: currTheme.textColor
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
                }
            }

            DapRadioButton
            {
                id: buttonSelectionError
                Layout.fillWidth: true
                nameRadioButton: qsTr("Error")
                indicatorInnerSize: 46 
                spaceIndicatorText: 3 
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Error")
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
            color: currTheme.textColor
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
                ListElement { name: "today" }
                ListElement { name: "yesterday" }
                ListElement { name: "last week" }
//                ListElement { name: "this month" }
                ListElement { name: "custom range"}
            }

            DapComboBoxCustomRange
            {
                id: comboboxPeriod
                model: periodModel

                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 10 
                anchors.leftMargin: 15 

                dapIndicatorImageNormal: "qrc:/Resources/"+pathTheme+"/icons/other/icon_arrow_down.png"
                dapIndicatorImageActive: "qrc:/Resources/"+pathTheme+"/icons/other/ic_arrow_up.png"
                dapSidePaddingNormal: 10 
                dapSidePaddingActive: 10 
                dapNormalColorText: currTheme.textColor
                dapHilightColorText: currTheme.hilightTextColorComboBox
                dapNormalColorTopText: currTheme.textColor
                dapHilightColorTopText: currTheme.textColor
                dapHilightColor: currTheme.hilightColorComboBox
                dapHilightTopColor: currTheme.backgroundElements //"blue" //currTheme.backgroundMainScreen
                dapNormalColor: currTheme.backgroundElements
                dapNormalTopColor: currTheme.backgroundElements //"blue" //currTheme.backgroundMainScreen
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
                dapTextFont:  mainFont.dapFont.regular14
                dapDefaultMainLineText: "all time"
                dapIsDefaultNeedToAppend: true
                dapRangeElementWidth: 74 
                dapRangeSpacing: 6 
                dapRangeDefaultText: "dd.mm.yyyy"
                dapInactiveRangeTextFont:  mainFont.dapFont.regular14
                dapUnselectedRangeColorTopText: "#ACAAB5"
                dapActiveRangeTextFont:  mainFont.dapFont.medium14
                dapSelectedRangeColorTopText: "#FFFFFF"

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

                        dapCalendarBackgroundColor: currTheme.backgroundMainScreen
                        dapNormalTextColor: currTheme.textColor
                        dapSelectedTextColor: currTheme.textColor
                        dapInvalidTextColor: "#908D9D"

                        dapNormalBackgroundColor: currTheme.backgroundMainScreen
                        dapSelectedBackgroundColor: currTheme.buttonColorNormal

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

        Item
        {
            id: frameBottom
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}

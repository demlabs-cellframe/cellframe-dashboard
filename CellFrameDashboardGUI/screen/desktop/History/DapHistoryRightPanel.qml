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
        anchors.topMargin: 3 * pt
        spacing: 0 * pt

        Text {
            Layout.minimumHeight: 35 * pt
            Layout.maximumHeight: 35 * pt
            Layout.leftMargin: 15 * pt
            verticalAlignment: Text.AlignVCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor
            text: qsTr("Status")
        }

        ColumnLayout
        {
//            Layout.margins: 3 * pt
            Layout.leftMargin: 2 * pt
            Layout.topMargin: 3 * pt
            spacing: 0

            DapRadioButton
            {
                id: buttonSelectionAllStatuses
                nameRadioButton: qsTr("All statuses")
                checked: true
                indicatorInnerSize: 46 * pt
                spaceIndicatorText: 3 * pt
                fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("All statuses")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionPending
                nameRadioButton: qsTr("Pending")
                indicatorInnerSize: 46 * pt
                spaceIndicatorText: 3 * pt
                fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Pending")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionSent
                nameRadioButton: qsTr("Sent")
                indicatorInnerSize: 46 * pt
                spaceIndicatorText: 3 * pt
                fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Sent")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionReceived
                nameRadioButton: qsTr("Received")
                indicatorInnerSize: 46 * pt
                spaceIndicatorText: 3 * pt
                fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Received")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionError
                nameRadioButton: qsTr("Error")
                indicatorInnerSize: 46 * pt
                spaceIndicatorText: 3 * pt
                fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Error")
                }
            }
        }

        Text {
            Layout.topMargin: 24 * pt
            Layout.leftMargin: 15 * pt
            Layout.minimumHeight: 35 * pt
            Layout.maximumHeight: 35 * pt
            verticalAlignment: Text.AlignVCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor
            text: qsTr("Period")
        }

        // Period selection combo box
        Rectangle
        {
            id: frameComboBoxPeriod
            Layout.topMargin: 16 * pt
            implicitHeight: 60 * pt
//            Layout.maximumHeight: 46 * pt
            Layout.fillWidth: true
            color: "transparent"

            ListModel
            {
                id: periodModel
                ListElement { name: "today" }
                ListElement { name: "yesterday" }
                ListElement { name: "last week" }
                ListElement { name: "this month" }
                ListElement { name: "custom range"}
            }

            DapComboBoxCustomRange
            {
                id: comboboxPeriod
                model: periodModel

                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 10 * pt
                anchors.leftMargin: 15 * pt

                dapIndicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                dapIndicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                dapSidePaddingNormal: 10 * pt
                dapSidePaddingActive: 10 * pt
                dapNormalColorText: currTheme.textColor
                dapHilightColorText: currTheme.hilightTextColorComboBox
                dapNormalColorTopText: currTheme.textColor
                dapHilightColorTopText: currTheme.textColor
                dapHilightColor: currTheme.hilightColorComboBox
                dapHilightTopColor: currTheme.backgroundElements //"blue" //currTheme.backgroundMainScreen
                dapNormalColor: currTheme.backgroundElements
                dapNormalTopColor: currTheme.backgroundElements //"blue" //currTheme.backgroundMainScreen
                dapWidthPopupComboBoxNormal: 318 * pt
                dapWidthPopupComboBoxActive: 318 * pt
                dapHeightComboBoxNormal: 46 * pt
                dapHeightComboBoxActive: 46 * pt
    //            dapBottomIntervalListElement: 8 * pt
                dapTopEffect: false
                x: popup.visible ? dapSidePaddingActive * (-1) : dapSidePaddingNormal
                dapPaddingTopItemDelegate: 8 * pt
                dapHeightListElement: 42 * pt
    //            dapIntervalListElement: 10 * pt
                dapIndicatorWidth: 24 * pt
                dapIndicatorHeight: dapIndicatorWidth
                dapIndicatorLeftInterval: 16 * pt
                dapColorTopNormalDropShadow: "#00000000"
                dapColorDropShadow: currTheme.shadowColor
                dapTextFont:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                dapDefaultMainLineText: "all time"
                dapIsDefaultNeedToAppend: true
                dapRangeElementWidth: 74 * pt
                dapRangeSpacing: 6 * pt
                dapRangeDefaultText: "dd.mm.yyyy"
                dapInactiveRangeTextFont:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                dapUnselectedRangeColorTopText: "#ACAAB5"
                dapActiveRangeTextFont:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                dapSelectedRangeColorTopText: "#FFFFFF"

                dapCalendars:
                    DapCalendar
                    {
                        dapLeftPadding: 16 * pt
                        dapRightPadding: 16 * pt
                        dapTopPadding: 0 * pt
                        dapBottomPadding: 16 * pt
                        dapTitleTopPadding: 20 * pt
                        dapTitleBottomPadding: 14 * pt
                        dapButtonInterval: 8 * pt
                        dapTitleWidth: 108 * pt
                        dapDayWidth: 24 * pt
                        dapDayHeight: 24 * pt
                        dapDayLeftInterval: 8 * pt
                        dapDayTopInterval: 2 * pt
                        dapCalendarFont:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14

                        dapCalendarBackgroundColor: currTheme.backgroundMainScreen
                        dapNormalTextColor: currTheme.textColor
                        dapSelectedTextColor: currTheme.textColor
                        dapInvalidTextColor: "#908D9D"

                        dapNormalBackgroundColor: currTheme.backgroundMainScreen
                        dapSelectedBackgroundColor: currTheme.buttonColorNormal

                        dapDayOfWeeksFormat: Locale.NarrowFormat
                        dapPreviousYearButtonImage: "qrc:/resources/icons/previous_year_icon.png"
                        dapPreviousMonthButtonImage: "qrc:/resources/icons/previous_month_icon.png"
                        dapNextMonthButtonImage: "qrc:/resources/icons/next_month_icon.png"
                        dapNextYearButtonImage: "qrc:/resources/icons/next_year_icon.png"
                    }

                onDapResultTextChanged:
                {
                    currentPeriodSelected(dapResultText, dapIsRange)
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
}

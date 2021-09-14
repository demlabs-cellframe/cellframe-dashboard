import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../"


DapTopPanel
{
    property alias dapComboboxPeriod: comboboxPeriod
    property alias dapComboboxWallet: comboboxWallet
    property alias dapComboboxStatus: comboboxStatus


    // Frame icon search
    Rectangle
    {
        id: frameIconSearch
        anchors.left: parent.left
        anchors.leftMargin: 16 * pt
        anchors.verticalCenter: parent.verticalCenter
        height: 15 * pt
        width: 15 * pt
        color: "transparent"
        Image
        {
            id: iconSearch
            anchors.fill: parent
            source: "qrc:/resources/icons/ic_search.png"
        }
    }

    // Wallet selection combo box
    Rectangle
    {
        id: frameTextFieldSearch
        anchors.left: frameIconSearch.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10 * pt
        width: 252 * pt
        height: layoutSearch.height
        color: "transparent"
        ColumnLayout
        {
            id: layoutSearch
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            TextField
            {
                id: textFieldSearch
                //anchors.top: parent.top
                //anchors.left: parent.left
                //anchors.leftMargin: 10 * pt
                //anchors.right: parent.right
                placeholderText: qsTr("Search")
                font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                style:
                    TextFieldStyle
                    {
                        textColor: "#ACAAB5"
                        placeholderTextColor: "#ACAAB5"
                        background:
                            Rectangle
                            {
                                border.width: 0
                                color: "transparent"
                            }
                    }
            }
            Rectangle
            {
                //anchors.top: textFieldSearch.bottom
                width: parent.width
                height: 1 * pt
                color: "#59556C"
            }
        }
    }

    // Static text "Period"
    Label
    {
        id: textPeriod
        text: qsTr("Period")
        anchors.left: frameTextFieldSearch.right
        anchors.leftMargin: 42 * pt
        anchors.verticalCenter: parent.verticalCenter
        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
        color: "#ACAAB5"
    }

    // Period selection combo box
    Rectangle
    {
        id: frameComboBoxPeriod

        anchors.left: textPeriod.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 30 * pt
        width: 204 * pt
        color: "transparent"

        ListModel
        {
            id: periodModel
            ListElement { name: "today" }
            ListElement { name: "yesterday" }
            ListElement { name: "last week" }
            ListElement { name: "last month" }
            ListElement { name: "custom range"}
        }

        DapComboBoxCustomRange
        {
            id: comboboxPeriod
            model: periodModel
            dapIndicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down.png"
            dapIndicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up.png"
            dapSidePaddingNormal: 0 * pt
            dapSidePaddingActive: 16 * pt
            dapNormalColorText: "#070023"
            dapHilightColorText: "#FFFFFF"
            dapNormalColorTopText: "#FFFFFF"
            dapHilightColorTopText: "#070023"
            dapHilightColor: "#330F54"
            dapNormalTopColor: "#070023"
            dapWidthPopupComboBoxNormal: 204 * pt
            dapWidthPopupComboBoxActive: 236 * pt
            dapHeightComboBoxNormal: 24 * pt
            dapHeightComboBoxActive: 46 * pt
            dapBottomIntervalListElement: 8 * pt
            dapTopEffect: false
            x: popup.visible ? dapSidePaddingActive * (-1) : dapSidePaddingNormal
            dapNormalColor: "#FFFFFF"
            dapHilightTopColor: dapNormalColor
            dapPaddingTopItemDelegate: 8 * pt
            dapHeightListElement: 32 * pt
            dapIntervalListElement: 10 * pt
            dapIndicatorWidth: 24 * pt
            dapIndicatorHeight: dapIndicatorWidth
            dapIndicatorLeftInterval: 16 * pt
            dapColorTopNormalDropShadow: "#00000000"
            dapColorDropShadow: "#40ABABAB"
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
                    dapCalendarBackgroundColor: "#FFFFFF"
                    dapNormalTextColor: "#070023"
                    dapSelectedTextColor: "#FFFFFF"
                    dapInvalidTextColor: "#908D9D"
                    dapNormalBackgroundColor: "#FFFFFF"
                    dapSelectedBackgroundColor: "#3E3853"
                    dapDayOfWeeksFormat: Locale.NarrowFormat
                    dapPreviousYearButtonImage: "qrc:/resources/icons/previous_year_icon.png"
                    dapPreviousMonthButtonImage: "qrc:/resources/icons/previous_month_icon.png"
                    dapNextMonthButtonImage: "qrc:/resources/icons/next_month_icon.png"
                    dapNextYearButtonImage: "qrc:/resources/icons/next_year_icon.png"
                }
        }
    }

    // Static text "Wallet"
    Label
    {
        id: textHeaderWallet
        text: qsTr("Wallet")
        anchors.left: frameComboBoxPeriod.right
        anchors.leftMargin: 42 * pt
        anchors.verticalCenter: parent.verticalCenter
        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
        color: "#ACAAB5"
    }

    // Wallet selection combo box
    Rectangle
    {
        id: frameComboBoxWallet

        anchors.left: textHeaderWallet.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 30 * pt
        width: 148 * pt
        color: "transparent"

        DapComboBox
        {
            id: comboboxWallet
            model: dapModelWallets
            comboBoxTextRole: ["name"]
            mainLineText: "all wallets"
            currentIndex: -1
            isDefaultNeedToAppend: true
            indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down.png"
            indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up.png"
            sidePaddingNormal: 0 * pt
            sidePaddingActive: 16 * pt
            normalColorText: "#070023"
            hilightColorText: "#FFFFFF"
            normalColorTopText: "#FFFFFF"
            hilightColorTopText: "#070023"
            hilightColor: "#330F54"
            normalTopColor: "#070023"
            widthPopupComboBoxNormal: 148 * pt
            widthPopupComboBoxActive: 180 * pt
            heightComboBoxNormal: 24 * pt
            heightComboBoxActive: 44 * pt
            bottomIntervalListElement: 8 * pt
            topEffect: false
            x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
            normalColor: "#FFFFFF"
            hilightTopColor: normalColor
            paddingTopItemDelegate: 8 * pt
            heightListElement: 32 * pt
            intervalListElement: 10 * pt
            indicatorWidth: 24 * pt
            indicatorHeight: indicatorWidth
            indicatorLeftInterval: 8 * pt
            colorTopNormalDropShadow: "#00000000"
            colorDropShadow: "#40ABABAB"
            fontComboBox: [ dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
            colorMainTextComboBox: [["#FFFFFF", "#070023"]]
            colorTextComboBox: [["#070023", "#FFFFFF"]]
        }
    }

    // Static text "Status"
    Label
    {
        id: textHeaderStatus
        text: qsTr("Status")
        anchors.left: frameComboBoxWallet.right
        anchors.leftMargin: 42 * pt
        anchors.verticalCenter: parent.verticalCenter
        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
        color: "#ACAAB5"
    }

    // Stats selection combo box
    Rectangle
    {
        id: frameComboBoxStatus

        anchors.left: textHeaderStatus.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 30 * pt
        width: 120 * pt
        color: "transparent"

        ListModel
        {
            id: statusModel
            ListElement { name: "Pending" }
            ListElement { name: "Sent" }
            ListElement { name: "Received" }
            ListElement { name: "Error" }
        }

        DapComboBox
        {
            id: comboboxStatus
            model: statusModel
            comboBoxTextRole: ["name"]
            mainLineText: "all statuses"
            currentIndex: -1
            isDefaultNeedToAppend: true
            indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down.png"
            indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up.png"
            sidePaddingNormal: 0 * pt
            sidePaddingActive: 16 * pt
            normalColorText: "#070023"
            hilightColorText: "#FFFFFF"
            normalColorTopText: "#FFFFFF"
            hilightColorTopText: "#070023"
            hilightColor: "#330F54"
            normalTopColor: "#070023"
            widthPopupComboBoxNormal: 120 * pt
            widthPopupComboBoxActive: 152 * pt
            heightComboBoxNormal: 24 * pt
            heightComboBoxActive: 44 * pt
            bottomIntervalListElement: 8 * pt
            topEffect: false
            x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
            normalColor: "#FFFFFF"
            hilightTopColor: normalColor
            paddingTopItemDelegate: 8 * pt
            heightListElement: 32 * pt
            intervalListElement: 10 * pt
            indicatorWidth: 24 * pt
            indicatorHeight: indicatorWidth
            indicatorLeftInterval: 8 * pt
            colorTopNormalDropShadow: "#00000000"
            colorDropShadow: "#40ABABAB"
            fontComboBox: [ dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
            colorMainTextComboBox: [["#FFFFFF", "#070023"]]
            colorTextComboBox: [["#070023", "#FFFFFF"]]
        }
    }
}

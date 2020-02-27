import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../"

DapAbstractTopPanelForm
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
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 10 * pt
                anchors.right: parent.right
                placeholderText: qsTr("Search")
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
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
                anchors.top: textFieldSearch.bottom
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
        anchors.leftMargin: 75 * pt
        anchors.verticalCenter: parent.verticalCenter
        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
        color: "#ACAAB5"
    }

    // Period selection combo box
    Rectangle
    {
        id: frameComboBoxPeriod

        anchors.left: textPeriod.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 26 * pt
        width: 108 * pt
        color: "transparent"

        ListModel
        {
            id: periodModel
            ListElement { name: "today" }
            ListElement { name: "yesterday" }
            ListElement { name: "last week" }
            ListElement { name: "last month" }
        }

        DapComboBox
        {
            id: comboboxPeriod
            model: periodModel
            comboBoxTextRole: ["name"]
            mainLineText: "all time"
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
            widthPopupComboBoxNormal: 108 * pt
            widthPopupComboBoxActive: 140 * pt
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
            fontComboBox: [dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14]
            colorMainTextComboBox: [["#FFFFFF", "#070023"]]
            colorTextComboBox: [["#070023", "#FFFFFF"]]
        }
    }

    // Static text "Wallet"
    Label
    {
        id: textHeaderWallet
        text: qsTr("Wallet")
        anchors.left: frameComboBoxPeriod.right
        anchors.leftMargin: 75 * pt
        anchors.verticalCenter: parent.verticalCenter
        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
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
            fontComboBox: [dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14]
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
        anchors.leftMargin: 75 * pt
        anchors.verticalCenter: parent.verticalCenter
        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
        color: "#ACAAB5"
    }

    // Stats selection combo box
    Rectangle
    {
        id: frameComboBoxStatus

        anchors.left: textHeaderStatus.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 26 * pt
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
            fontComboBox: [dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14]
            colorMainTextComboBox: [["#FFFFFF", "#070023"]]
            colorTextComboBox: [["#070023", "#FFFFFF"]]
        }
    }
}

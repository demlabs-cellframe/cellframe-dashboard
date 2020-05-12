import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"
import "../../"

DapAbstractTopPanelForm
{
    anchors.fill: parent

    // Static text "Wallet"
    Label
    {
        id: textHeaderWallet
        text: qsTr("Wallet")
        anchors.left: parent.left
        anchors.leftMargin: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
        color: "#ACAAB5"
    }

    // Wallet selection combo box
    Rectangle
    {
        id: frameComboBox

        anchors.left: textHeaderWallet.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 30 * pt
        width: 148 * pt
        color: "transparent"

        DapComboBox
        {
            id: comboboxWallet
            //model: modelWallets
            comboBoxTextRole: ["text"]
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

    // Static wallet balance text "Wallet balance"
    Label
    {
        id: headerWalletBalance
        text: qsTr("Wallet balance")
        anchors.left: frameComboBox.right
        anchors.leftMargin: 70 * pt
        anchors.verticalCenter: parent.verticalCenter
        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
        color: "#ACAAB5"
    }

    // Dynamic wallet balance text
    ///Now it's not dynamic and must be no USD
    /*Label
    {
        id: textWalletBalance
        text: "$ 3 050 745.3453289 USD"
        anchors.left: headerWalletBalance.right
        anchors.leftMargin: 18 * pt
        anchors.verticalCenter: parent.verticalCenter
        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular16
        color: "#FFFFFF"
    }*/
}



/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

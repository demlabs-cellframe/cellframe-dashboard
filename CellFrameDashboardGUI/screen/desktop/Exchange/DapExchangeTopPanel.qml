import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../"
import "../SettingsWallet.js" as SettingsWallet

DapTopPanel
{
    anchors.leftMargin: 4*pt
    radius: currTheme.radiusRectangle
    color: currTheme.backgroundPanel

    RowLayout
    {
        anchors.left: parent.left
        anchors.leftMargin: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
        spacing: 18

        // Static text "Wallet"
        Label
        {
            id: textHeaderWallet
            text: qsTr("Wallet: ")
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
            color: currTheme.textColor
        }
        Label
        {
            id: textNameWallet
            text: dapModelWallets.get(SettingsWallet.currentIndex).name
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
            color: currTheme.textColor
        }


        // Static wallet balance text "Wallet balance"
        Label
        {
            id: headerWalletBalance
            Layout.leftMargin: 40
            text: qsTr("Token balance: ")
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
            color: currTheme.textColor
        }

        // Dynamic wallet balance text
        Label
        {
            id: textWalletBalance
//            text: "$ 3 050 745.3453289 USD"
            text: exchangeTokenModel.count ? exchangeTokenModel.get(tokenComboBox.currentIndex).balance_without_zeros : "-------"
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
            color: currTheme.textColor
        }

        // Static token text "Token: "
        Label
        {
            id: textWalletToken
            Layout.leftMargin: 40
            text: "Token: "
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
            color: currTheme.textColor
        }

        // Token selection combo box
        Item
        {
            width: 150 * pt

            DapComboBox
            {
                id: tokenComboBox
                model: exchangeTokenModel

                comboBoxTextRole: ["name"]
                mainLineText: dapModelWallets.count && exchangeTokenModel.count ? exchangeTokenModel.get(0).name : "No tokens"
                indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                sidePaddingNormal: 10 * pt
                sidePaddingActive: 10 * pt

                widthPopupComboBoxNormal: 150 * pt
                widthPopupComboBoxActive: 150 * pt
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 42 * pt
                topEffect: false

                normalColor: currTheme.backgroundElements
                normalTopColor: currTheme.backgroundPanel
                hilightTopColor: currTheme.backgroundPanel

                paddingTopItemDelegate: 8 * pt
                heightListElement: 42 * pt
                indicatorWidth: 24 * pt
                indicatorHeight: indicatorWidth
                colorDropShadow: currTheme.shadowColor
                roleInterval: 15
                endRowPadding: 37

                fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16]
                colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                alignTextComboBox: [Text.AlignLeft, Text.AlignRight]
            }
        }
    }
}

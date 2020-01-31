import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"
import "../../"

DapAbstractTopPanel 
{
    property alias dapAddWalletButton: addWalletButton
    property alias dapComboboxWallet: comboboxWallet
    property alias dapComboboxNetwork: comboboxWalletNetwork.model
    anchors.fill: parent

    // Static text "Wallet"
    Label 
    {
        id: textHeaderWallet
        text: qsTr("Wallet")
        anchors.left: parent.left
        anchors.leftMargin: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
        font.family: dapFontRobotoRegular.name
        font.pixelSize: 12 * pt
        color: "#ACAAB5"
    }

    ListModel
    {
        id: sss
        ListElement
        {
            name: "Абракадабра"
            val: 1
            temp: "rtrtrtrtr"
        }
        ListElement
        {
            name: "Эллипсоид"
            val: 2
            temp: "qwqwqwqwq"
        }
        ListElement
        {
            name: "Бесперспективняк"
            val: 3
            temp: "assasasa"
        }
        ListElement
        {
            name: "Ивняк-няк-няк"
            val: 4
            temp: "sdsdsdsds"
        }
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
            //model: modelWallets
            model: sss
            comboBoxTextRole: ["name"]
            comboBoxRoleWidth: [50]
            roleInterval: 20 * pt
            //endRowPadding: 44 * pt
            mainLineText: "all wallets"
            indicatorImageNormal: "qrc:/res/icons/ic_arrow_drop_down.png"
            indicatorImageActive: "qrc:/res/icons/ic_arrow_drop_up.png"
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
            fontComboBox.pixelSize: 14 * pt
            fontComboBox.family: "Roboto"
        }
    }

    Rectangle
    {
        id: frameComboBoxNetwork

        anchors.left: frameComboBoxWallet.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 30 * pt
        width: 148 * pt
        color: "transparent"

        ListModel
        {
            id: mT
            ListElement
            {
                name: "Pr"
                val: 1
            }
            ListElement
            {
                name: "Kl"
                val: 2
            }
            ListElement
            {
                name: "Prfshdfhdfha aertertartaret"
                val: 3
            }
            ListElement
            {
                name: "Klrestsert reataer rtrser"
                val: 4
            }
        }


        DapComboBox
        {
            id: comboboxWalletNetwork
            model: mT
            comboBoxTextRole: ["name", "val"]
            comboBoxRoleWidth: [70, 10]
            roleInterval: 20 * pt
            //endRowPadding: 44 * pt
            mainLineText: "all wallets"
            indicatorImageNormal: "qrc:/res/icons/ic_arrow_drop_down.png"
            indicatorImageActive: "qrc:/res/icons/ic_arrow_drop_up.png"
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
            fontComboBox.pixelSize: 14 * pt
            fontComboBox.family: "Roboto"
        }
    }

    // Static wallet balance text "Wallet balance"
    Label 
    {
        id: headerWalletBalance
        text: qsTr("Wallet balance")
        anchors.left: frameComboBoxNetwork.right
        anchors.leftMargin: 70 * pt
        anchors.verticalCenter: parent.verticalCenter
        font.family: dapFontRobotoRegular.name
        font.pixelSize: 12 * pt
        color: "#ACAAB5"
    }

    // Dynamic wallet balance text
    Label 
    {
        id: textWalletBalance
        text: "$ 3 050 745.3453289 USD"
        anchors.left: headerWalletBalance.right
        anchors.leftMargin: 18 * pt
        anchors.verticalCenter: parent.verticalCenter
        font.family: dapFontRobotoRegular.name
        font.pixelSize: 16 * pt
        color: "#FFFFFF"
    }

    // Wallet create button
    DapButton
    {
        id: addWalletButton
        textButton: "New wallet"
        anchors.right: parent.right
        anchors.rightMargin: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
        normalImageButton: "qrc:/res/icons/new-wallet_icon_dark.png"
        hoverImageButton: "qrc:/res/icons/new-wallet_icon_dark_hover.png"
        heightButton: 24 * pt
        widthButton: 120 * pt
        widthImageButton: 28 * pt
        heightImageButton: 28 * pt
        indentImageLeftButton: 10 * pt
        colorBackgroundNormal: "#070023"
        colorBackgroundHover: "#D51F5D"
        colorButtonTextNormal: "#FFFFFF"
        colorButtonTextHover: "#FFFFFF"
        indentTextRight: 20 * pt
        fontButton.pixelSize: 14 * pt
        borderColorButton: "#000000"
        borderWidthButton: 0
        fontButton.family: "Roboto"
        fontButton.weight: Font.Normal
        horizontalAligmentText:Qt.AlignRight
        colorTextButton: "#FFFFFF"

    }
}

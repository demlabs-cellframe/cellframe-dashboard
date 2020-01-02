import QtQuick 2.4
import QtQuick.Controls 2.0
<<<<<<< HEAD
import "qrc:/widgets"
=======
>>>>>>> develop
import "../../"


DapAbstractTopPanel
{
<<<<<<< HEAD
    anchors.fill: parent
=======
    property alias testButton: button
    Button
    {
        id: button
        anchors.fill: parent
        text: "Press"
    }
>>>>>>> develop

    // Static text "Wallet"
    Label
    {
        id:textHeaderWallet
        text: qsTr("Wallet")
        anchors.left: parent.left
        anchors.leftMargin: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
        font.family: DapMainApplicationWindow.dapFontRobotoRegular.name
        font.pixelSize: 12 * pt
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

            model: ListModel{
                id:сonversionList
                ListElement{text:"all wallets"}
                ListElement{text:"Money for children"}
                ListElement{text:"Money for education"}
                ListElement{text:"Money for medicine"}
            }

            indicatorImageNormal: "qrc:/res/icons/ic_arrow_drop_down.png"
            indicatorImageActive: "qrc:/res/icons/ic_arrow_drop_up.png"
            sidePaddingNormal:0 * pt
            sidePaddingActive:16 * pt
            topIndentActive:10 * pt
            normalColorText:"#070023"
            hilightColorText:"#FFFFFF"
            normalColorTopText:"#FFFFFF"
            hilightColorTopText:"#070023"
            hilightColor: "#330F54"
            normalTopColor: "#070023"
            fontSizeComboBox: 14*px
            widthPopupComboBoxNormal:148 * pt
            widthPopupComboBoxActive:180 * pt
            heightComboBoxNormal:24 * pt
            heightComboBoxActive:44 * pt
            bottomIntervalListElement:8 * pt
            topEffect:false
            x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
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
        font.family: DapMainApplicationWindow.dapFontRobotoRegular.name
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
        font.family: DapMainApplicationWindow.dapFontRobotoRegular.name
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
        colorBackgroundNormal:"#070023"
        colorBackgroundHover: "#D51F5D"
        colorButtonTextNormal: "#FFFFFF"
        colorButtonTextHover: "#FFFFFF"
        indentTextRight: 20 * pt
        fontSizeButton: 14 * pt
        existenceImage:true
        borderColorButton: "#000000"
        borderWidthButton: 0
    }
}

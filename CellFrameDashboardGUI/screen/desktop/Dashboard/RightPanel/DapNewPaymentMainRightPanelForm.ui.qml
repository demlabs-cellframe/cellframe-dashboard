import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"

DapAbstractRightPanel
{
    /// @param dapButtonSend Send funds button.
    property alias dapButtonSend: buttonSend
    /// @param dapTextInputAmountPayment Input field for transfer amount.
    property alias dapTextInputAmountPayment: textInputAmountPayment
    /// @param dapCmboBoxTokenModel Token combobox model.
    property alias dapCmboBoxTokenModel: comboboxToken.model

    property alias dapCmboBoxToken: comboboxToken
    //@param dapSendedToken Name of token to send
    property string dapSendedToken: comboboxToken.mainLineText

    property string dapCurrentWallet

    property alias dapTextSenderWalletAddress: textSenderWalletAddress.fullText
    /// @param dapTextInputRecipientWalletAddress Recipient wallet address input field.
    property alias dapTextInputRecipientWalletAddress: textInputRecipientWalletAddress

    dapHeaderData:
        Row
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.rightMargin: 16 * pt
            anchors.topMargin: 12 * pt
            anchors.bottomMargin: 12 * pt
            spacing: 12 * pt

            Item
            {
                id: itemButtonClose
                data: dapButtonClose
                height: dapButtonClose.height
                width: dapButtonClose.width
            }

            Text
            {
                id: textHeader
                text: qsTr("New payment")
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular16
                color: "#3E3853"
            }
        }

    dapContentItemData:
        Rectangle
        {
            anchors.fill: parent
            color: "transparent"

            // Sender wallet
            Rectangle
            {
                id: frameSenderWallet
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textFrameSenderWallet
                    color: "#ffffff"
                    text: qsTr("From")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }

                Rectangle
                {
                    id: frameSenderWalletAddress
                    color: "transparent"
                    anchors.top: frameSenderWallet.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 16 * pt
                    anchors.rightMargin: 16 * pt
                    height: 120 * pt

                    Rectangle
                    {
                        id: frameSenderWalletToken
                        color: "transparent"
                        anchors.top: frameSenderWalletAddress.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: 20 * pt
                        anchors.leftMargin: 16 * pt
                        anchors.rightMargin: 16 * pt
                        height: 40 * pt
                        DapComboBox
                        {
                            id: comboboxToken
                            anchors.centerIn: parent
                            comboBoxTextRole: ["name", "name"]
                            mainLineText: "all tokens"
                            indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down_dark.png"
                            indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up.png"
                            sidePaddingNormal: 0 * pt
                            sidePaddingActive: 20 * pt
                            normalColorText: "#070023"
                            hilightColorText: "#FFFFFF"
                            normalColorTopText: "#070023"
                            hilightColorTopText: "#070023"
                            hilightColor: "#330F54"
                            normalTopColor: parent.color
                            widthPopupComboBoxNormal: 328 * pt
                            widthPopupComboBoxActive: 368 * pt
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
                            indicatorLeftInterval: 20 * pt
                            colorTopNormalDropShadow: "#00000000"
                            colorDropShadow: "#40ABABAB"
                            roleInterval: 20
                            endRowPadding: 44
                            fontComboBox: [dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14]
                            colorMainTextComboBox: [["#070023", "#070023"], ["#070023", "#908D9D"]]
                            colorTextComboBox: [["#070023", "#FFFFFF"], ["#908D9D", "#FFFFFF"]]
                            alignTextComboBox: [Text.AlignLeft, Text.AlignRight]
                        }
                    }
                    Rectangle
                    {
                        id: splitLineSenderWalletToken
                        height: 1 * pt
                        width: parent.width
                        color: "#E3E2E6"
                        anchors.top: frameSenderWalletToken.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: 14 * pt
                        anchors.leftMargin: 20 * pt
                        anchors.rightMargin: 20 * pt
                    }
                    DapText
                    {
                        id: textSenderWalletAddress
                        anchors.top: splitLineSenderWalletToken.top
                        anchors.topMargin: 20 * pt
                        anchors.left: parent.left
                        anchors.leftMargin: 20 * pt
                        width: 240 * pt
                        fontDapText: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                        textColor: "#757184"
                    }
            }

            // Amount payment
            Rectangle
            {
                id: frameAmountPayment
                anchors.top: frameSenderWalletAddress.bottom
                anchors.right: parent.right
                anchors.left: parent.left
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textFrameamountPayment
                    color: "#ffffff"
                    text: qsTr("Amount")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    anchors.leftMargin: 16 * pt
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle
            {
                id: frameInputAmountPayment
                height: 112 * pt
                color: "transparent"
                anchors.top: frameAmountPayment.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                Rectangle
                {
                    id: frameAmountField
                    anchors.left: parent.left
                    anchors.leftMargin: 20 * pt
                    anchors.right: parent.right
                    anchors.rightMargin: 20 * pt
                    anchors.top: frameInputAmountPayment.top
                    anchors.topMargin: 20 * pt
                    height: textTokenReduction.height
                    color: "transparent"

                    TextField
                    {
                        id: textInputAmountPayment
                        anchors.verticalCenter: parent.verticalCenter
                        placeholderText: qsTr("0")
                        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular16
                        horizontalAlignment: Text.AlignLeft
                        anchors.left: parent.left
                        anchors.leftMargin: -6 * pt
                        anchors.right: textTokenReduction.left
                        anchors.rightMargin: 20 * pt

                        style:
                            TextFieldStyle
                            {
                                textColor: "#070023"
                                placeholderTextColor: "#070023"
                                background:
                                    Rectangle
                                    {
                                        border.width: 0
                                        color: "transparent"
                                    }
                            }
                    }
                    Text
                    {
                        id: textTokenReduction
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular16
                        horizontalAlignment: Text.AlignRight
                        color: "#070023"
                        text: dapSendedToken

                    }
                }
                Rectangle
                {
                    id: splitLineAmount
                    height: 1 * pt
                    width: parent.width
                    color: "#E3E2E6"
                    anchors.top: frameAmountField.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 16 * pt
                    anchors.leftMargin: 20 * pt
                    anchors.rightMargin: 20 * pt
                }
                Rectangle
                {
                    id: frameAmountConvert
                    anchors.left: parent.left
                    anchors.leftMargin: 20 * pt
                    anchors.right: parent.right
                    anchors.rightMargin: 20 * pt
                    anchors.top: splitLineAmount.top
                    anchors.topMargin: 16 * pt
                    //height: textAmountConvertValue.height
                    color: "transparent"
                    ////////////Delete all USD
                    /*Text
                    {
                        id: textAmountConvertValue
                        anchors.verticalCenter: parent.verticalCenter
                        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                        horizontalAlignment: Text.AlignLeft
                        anchors.left: parent.left
                        anchors.leftMargin: textInputAmountPayment.anchors.leftMargin + 6 * pt
                        color: "#757184"
                        text: qsTr("0")
                    }
                    Text
                    {
                        id: textAmountConvertCurrency
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                        horizontalAlignment: Text.AlignRight
                        color: "#757184"
                        text: qsTr("USD")
                    }*/
                }
            }

            // Recipient wallet
            Rectangle
            {
                id: frameRecipientWallet
                anchors.top: frameInputAmountPayment.bottom
                anchors.right: parent.right
                anchors.left: parent.left
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textRecipientWallet
                    color: "#ffffff"
                    text: qsTr("To")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    anchors.leftMargin: 16 * pt
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle
            {
                id: frameRecipientWalletAddress
                anchors.top: frameRecipientWallet.bottom
                anchors.left: parent.left
                anchors.leftMargin: 16 * pt
                anchors.right: parent.right
                anchors.rightMargin: 16 * pt
                height: 52 * pt
                color: "transparent"

                TextField
                {
                    id: textInputRecipientWalletAddress
                    anchors.verticalCenter: parent.verticalCenter
                    placeholderText: qsTr("Receiver Address")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular16
                    horizontalAlignment: Text.AlignLeft
                    anchors.top: frameRecipientWalletAddress.top
                    anchors.topMargin: 12 * pt
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 20 * pt - 8 * pt
                    anchors.rightMargin: 20 * pt
                    style:
                        TextFieldStyle
                        {
                            textColor: "#070023"
                            placeholderTextColor: "#C7C6CE"
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
                    id: splitLineRecipientWalletAddress
                    height: 1 * pt
                    width: parent.width
                    color: "#E3E2E6"
                    anchors.top: textInputRecipientWalletAddress.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 12 * pt
                    anchors.leftMargin: 20 * pt
                    anchors.rightMargin: 20 * pt
                }
            }

            // Button "Send"
            DapButton
            {
                id: buttonSend
                implicitHeight: 44 * pt
                implicitWidth: 130 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: frameRecipientWalletAddress.bottom
                anchors.topMargin: 60 * pt
                textButton: qsTr("Send")
                colorBackgroundHover: "#D51F5D"
                colorBackgroundNormal: "#3E3853"
                colorButtonTextNormal: "#FFFFFF"
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular18
            }

            Rectangle
            {
                id: frameBottom
                height: 124 * pt
                anchors.top: buttonSend.bottom
                anchors.topMargin: 24 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "transparent"
            }

        }
}

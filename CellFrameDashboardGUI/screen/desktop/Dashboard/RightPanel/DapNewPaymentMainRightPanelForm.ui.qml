import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
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

    property alias dapComboboxNetwork: comboboxNetwork

    property alias dapCmboBoxNetworkModel: comboboxNetwork.model

    property alias dapCmboBoxToken: comboboxToken

    property alias dapFrameAmountPayment: frameAmountPayment
    property alias dapFrameInputAmountPayment: frameInputAmountPayment
    property alias dapFrameRecipientWallet: frameRecipientWallet
    property alias dapFrameRecipientWalletAddress: frameRecipientWalletAddress

    property alias dapTextNotEnoughTokensWarning: textNotEnoughTokensWarning
    //@param dapSendedToken Name of token to send
    property string dapSendedToken: comboboxToken.mainLineText

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
        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            // Sender wallet
            Rectangle
            {
                id: frameSenderWallet
                Layout.fillWidth: true
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

            ColumnLayout
            {
                id: frameSenderWalletAddress
                Layout.fillWidth: true
                Layout.margins: 16 * pt
                spacing: 16 * pt

                Rectangle
                {
                    id: frameSenderNetwork
                    color: "transparent"
                    Layout.fillWidth: true
                    height: 40 * pt
                    DapComboBox
                    {
                        id: comboboxNetwork
                        anchors.centerIn: parent
                        comboBoxTextRole: ["name"]
                        mainLineText: "private"
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
            }

            // Amount payment
            Rectangle
            {
                id: frameAmountPayment
                Layout.fillWidth: true
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

            ColumnLayout
            {
                id: frameInputAmountPayment
                Layout.fillWidth: true
                Layout.margins: 0 * pt
                spacing: 0 * pt

                RowLayout
                {
                    id: frameAmountField
                    Layout.fillWidth: true
                    Layout.margins: 16 * pt
                    spacing: 16 * pt

                    TextField
                    {
                        id: textInputAmountPayment
                        Layout.fillWidth: true
                        placeholderText: qsTr("0")
                        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular16
                        horizontalAlignment: Text.AlignLeft

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
                    Rectangle
                    {
                        id: frameSenderWalletToken
                        color: "transparent"
                        height: 40 * pt
                        width: 150 * pt
                        DapComboBox
                        {
                            id: comboboxToken
                            anchors.centerIn: parent
                            comboBoxTextRole: ["name"]
                            mainLineText: "tCELL"
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
                            widthPopupComboBoxNormal: 110 * pt
                            widthPopupComboBoxActive: 150 * pt
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

                }

            }

            // Recipient wallet
            Rectangle
            {
                id: frameRecipientWallet
                Layout.fillWidth: true
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
                Layout.fillWidth: true
                height: 52 * pt
                color: "transparent"

                TextField
                {
                    id: textInputRecipientWalletAddress
                    anchors.verticalCenter: parent.verticalCenter
                    placeholderText: qsTr("Receiver Address")
                    validator: RegExpValidator { regExp: /[0-9A-Za-z]+/ }
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
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 35 * pt
                textButton: qsTr("Send")
                colorBackgroundHover: "#D51F5D"
                colorBackgroundNormal: "#3E3853"
                colorButtonTextNormal: "#FFFFFF"
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                shadowColor:"#2A2C33"
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

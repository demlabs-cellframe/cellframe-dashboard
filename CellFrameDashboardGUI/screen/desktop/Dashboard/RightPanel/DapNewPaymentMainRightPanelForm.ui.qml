import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.4
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

    property alias dapTextNotEnoughTokensWarning: textNotEnoughTokensWarning
    //@param dapSendedToken Name of token to send
    property string dapSendedToken: comboboxToken.mainLineText

    property string dapCurrentWallet

    property string dapCurrentNetwork

//    property alias dapTextSenderWalletAddress: textSenderWalletAddress.fullText
    /// @param dapTextInputRecipientWalletAddress Recipient wallet address input field.
    property alias dapTextInputRecipientWalletAddress: textInputRecipientWalletAddress

    dapHeaderData:
        Item
        {
            anchors.fill: parent
            Item
            {
                id: itemButtonClose
                data: dapButtonClose
                height: dapButtonClose.height
                width: dapButtonClose.width
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 11 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 22 * pt
                anchors.rightMargin: 13 * pt

            }

            Text
            {
                id: textHeader
                text: qsTr("New payment")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 50 * pt

                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
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
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textFrameSenderWallet
                    color: currTheme.textColor
                    text: qsTr("From")
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
                }
            }

            ColumnLayout
            {
                id: frameSenderWalletAddress
//                anchors.fill: parent
//                anchors.top: frameSenderWallet

                Layout.fillWidth: true
                Layout.leftMargin: 5 * pt
                Layout.rightMargin: 5 * pt
//                Layout.margins: 16 * pt
//                spacing: 16 * pt
//                height: 70 * pt

                Rectangle
                {
                    id: frameSenderNetwork
                    color: currTheme.backgroundElements
                    Layout.fillWidth: true
                    height: 70 * pt
                    DapComboBox
                    {
                        id: comboboxNetwork
                        anchors.centerIn: parent
                        comboBoxTextRole: ["name"]
                        mainLineText: "private"
                        indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                        indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                        sidePaddingNormal: 35 * pt
                        sidePaddingActive: 37 * pt
//                        normalColorText: currTheme.textColor
//                        hilightColorText: currTheme.textColor
//                        normalColorTopText: currTheme.textColor
//                        hilightColorTopText: currTheme.textColor
                        hilightColor: currTheme.buttonColorNormal

                        widthPopupComboBoxNormal: 318 * pt
                        widthPopupComboBoxActive: 318 * pt
                        heightComboBoxNormal: 24 * pt
                        heightComboBoxActive: 42 * pt
//                        bottomIntervalListElement: 10 * pt
                        topEffect: false

                        x: sidePaddingNormal
                        normalColor: currTheme.backgroundMainScreen
                        normalTopColor: parent.color
                        hilightTopColor: currTheme.backgroundMainScreen


                        paddingTopItemDelegate: 8 * pt
                        heightListElement: 42 * pt
//                        intervalListElement: 10 * pt
                        indicatorWidth: 24 * pt
                        indicatorHeight: indicatorWidth
//                        indicatorLeftInterval: 0 * pt
//                        colorTopNormalDropShadow: "#00000000"
                        colorDropShadow: currTheme.shadowColor
                        roleInterval: 15
                        endRowPadding: 44

                        fontComboBox: [dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14]
                        colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                        colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                        alignTextComboBox: [Text.AlignLeft, Text.AlignRight]
                    }
                }
//                Rectangle
//                {
//                    id: splitLineSenderWalletToken
//                    height: 1 * pt
//                    Layout.fillWidth: true
//                    color: "#E3E2E6"
//                }
//                DapText
//                {
//                    id: textSenderWalletAddress
//                    Layout.fillWidth: true
//                    width: 240 * pt
//                    fontDapText: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
//                    textColor: "#757184"
//                }
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
                Layout.topMargin: 30 * pt
                textButton: qsTr("Send")
                colorBackgroundHover: "#D51F5D"
                colorBackgroundNormal: "#3E3853"
                colorButtonTextNormal: "#FFFFFF"
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular18
            }

            Text
            {
                id: textNotEnoughTokensWarning
                Layout.fillWidth: true
                Layout.margins: 30 * pt
                color: "#ff2020"
                text: qsTr("Not enough available tokens. Enter a lower value.")
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                visible: true
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

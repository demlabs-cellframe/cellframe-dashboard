import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.4
import QtGraphicalEffects 1.0
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
//                Layout.leftMargin: 5 * pt
//                Layout.rightMargin: 5 * pt
//                Layout.margins: 16 * pt
//                Layout.topMargin: 22 * pt
//                Layout.bottomMargin: 22 * pt
//                spacing: 16 * pt
//                height: 70 * pt

                RowLayout
                {
                    id: frameSenderNetwork
//                    color: currTheme.backgroundElements
                    Layout.fillWidth: true
                    Layout.leftMargin: 16 * pt
                    Layout.rightMargin: 16 * pt
                    height: 70 * pt

                    DapComboBox
                    {
                        id: comboboxNetwork
//                        anchors.centerIn: parent
                        comboBoxTextRole: ["name"]
                        mainLineText: "private"
                        indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                        indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                        sidePaddingNormal: 19 * pt
                        sidePaddingActive: 19 * pt
                        hilightColor: currTheme.buttonColorNormal
//                        anchors.fill: parent
                        Layout.fillWidth: true

                        widthPopupComboBoxNormal: parent.width * pt
                        widthPopupComboBoxActive: parent.width * pt
                        heightComboBoxNormal: 24 * pt
                        heightComboBoxActive: 42 * pt
//                        bottomIntervalListElement: 10 * pt
                        topEffect: false

//                        x: sidePaddingNormal
                        normalColor: currTheme.backgroundMainScreen
                        normalTopColor: currTheme.backgroundElements
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
                        endRowPadding: 37

                        fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
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
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textFrameamountPayment
                    color: currTheme.textColor
                    text: qsTr("Amount")
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                    anchors.leftMargin: 15 * pt
                    anchors.left: parent.left
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
                    horizontalAlignment: Text.AlignRight
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
//                    spacing: 28 * pt

                    TextField
                    {
                        id: textInputAmountPayment
                        Layout.fillWidth: true
//                        anchors.leftMargin: 10 * pt
                        Layout.leftMargin: 20 * pt
                        width: 150 * pt
                        height: 28 * pt
                        placeholderText: qsTr("0")
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                        horizontalAlignment: Text.AlignRight

                        style:
                            TextFieldStyle
                            {
                                textColor: currTheme.textColor
                                placeholderTextColor: currTheme.textColor
                                background:
                                    Rectangle
                                    {
                                        border.width: 1
                                        radius: 4 * pt
                                        border.color: currTheme.borderColor
                                        color: currTheme.backgroundElements
                                    }
                            }
                    }
                    Rectangle
                    {
                        id: frameSenderWalletToken
                        color: "transparent"
                        height: 42 * pt
                        width: 119 * pt
                        Layout.leftMargin: 28 * pt
                        Layout.rightMargin: 5 * pt
                        DapComboBox
                        {
                            id: comboboxToken
                            anchors.fill: parent
                            comboBoxTextRole: ["name"]
                            mainLineText: "tCELL"
                            indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                            indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                            sidePaddingNormal: 19 * pt
                            sidePaddingActive: 19 * pt
                            widthPopupComboBoxNormal: 119 * pt
                            widthPopupComboBoxActive: 119 * pt
                            heightComboBoxNormal: 24 * pt
                            heightComboBoxActive: 42 * pt
                            topEffect: false
                            x: sidePaddingNormal
                            normalColor: currTheme.backgroundMainScreen
                            hilightTopColor: currTheme.backgroundMainScreen
                            hilightColor: currTheme.buttonColorNormal
                            normalTopColor: parent.color
                            paddingTopItemDelegate: 8 * pt
                            heightListElement: 42 * pt
                            indicatorWidth: 24 * pt
                            indicatorHeight: indicatorWidth
                            colorDropShadow: currTheme.shadowColor
                            roleInterval: 15
                            endRowPadding: 37
                            fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
                            colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                            colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
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
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textRecipientWallet
                    color: currTheme.textColor
                    text: qsTr("To")
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
                }
            }

            Rectangle
            {
                id: frameRecipientWalletAddress
                Layout.fillWidth: true
                Layout.leftMargin: 38 * pt
                Layout.rightMargin: 36 * pt
//                Layout.topMargin: 26 * pt
                height: 53 * pt
                color: "transparent"

                TextField
                {
                    id: textInputRecipientWalletAddress
                    Layout.fillWidth: true
                    anchors.verticalCenter: parent.verticalCenter
                    placeholderText: qsTr("Paste here")
                    validator: RegExpValidator { regExp: /[0-9A-Za-z]+/ }
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    horizontalAlignment: Text.AlignLeft
                    anchors.fill: parent
//                    anchors.top: frameRecipientWalletAddress.top
                    anchors.topMargin: 26 * pt
//                    anchors.left: parent.left
//                    anchors.right: parent.right
//                    anchors.leftMargin: 20 * pt - 8 * pt
//                    anchors.rightMargin: 20 * pt
                    style:
                        TextFieldStyle
                        {
                            textColor: currTheme.textColor
                            placeholderTextColor: currTheme.placeHolderTextColor

                            background:
                                Rectangle
                                {
                                    border.width: 0
                                    color: currTheme.backgroundElements
                                }
                        }
                }

                Rectangle
                {
                    id: splitLineRecipientWalletAddress
                    height: 1 * pt
                    width: parent.width
                    color: currTheme.borderColor
                    anchors.top: textInputRecipientWalletAddress.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 8 * pt
//                    anchors.leftMargin: 20 * pt
//                    anchors.rightMargin: 20 * pt
                }
            }

            // Button "Send"
            DapButton
            {
                id: buttonSend
//                radius: currTheme.radiusButton
                implicitHeight: 36 * pt
                implicitWidth: 132 * pt
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 50 * pt
                textButton: qsTr("Send")
                colorBackgroundHover: currTheme.buttonColorHover
                colorBackgroundNormal: currTheme.buttonColorNormal
                colorButtonTextNormal: currTheme.textColor
                colorButtonTextHover: currTheme.textColor
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16


            }
            DropShadow {
//                Layout.alignment: buttonSend
                anchors.fill: buttonSend
                horizontalOffset: 1
                verticalOffset: 1
                radius: 10
                samples: 32
                color: "#2A2C33"
                source: buttonSend
                smooth: true
                }



            Text
            {
                id: textNotEnoughTokensWarning
                Layout.fillWidth: true
                Layout.margins: 30 * pt
                color: "#ff2020"
                text: qsTr("Not enough available tokens. Enter a lower value.")
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
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

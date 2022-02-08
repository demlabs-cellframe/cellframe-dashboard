import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.4
import QtGraphicalEffects 1.0

import "qrc:/widgets"
import "../../../"

DapRightPanel
{
    /// @param dapButtonSend Send funds button.
    property alias dapButtonSend: buttonSend
    /// @param dapTextInputAmountPayment Input field for transfer amount.
    property alias dapTextInputAmountPayment: textInputAmountPayment
    /// @param dapCmboBoxTokenModel Token combobox model.
    property alias dapCmboBoxTokenModel: comboboxToken.model

    property alias dapComboboxNetwork: comboboxNetwork
    property alias dapComboboxChain: comboboxChain

    property alias dapChainGroup: chainGroup

    property alias dapCmboBoxNetworkModel: comboboxNetwork.model
    property alias dapCmboBoxChainModel: comboboxChain.model

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
        Item
        {
            anchors.fill: parent
//            Layout.fillWidth: true
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
                anchors.topMargin: 9 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 24 * pt
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
                anchors.leftMargin: 52 * pt

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
                    anchors.leftMargin: 17 * pt
                    anchors.topMargin: 20 * pt
                    anchors.bottomMargin: 5 * pt
                }
            }

            ColumnLayout
            {
                id: frameSenderWalletAddress

                Layout.fillWidth: true
                spacing: 10 * pt
                Layout.topMargin: 10 * pt
                Layout.bottomMargin: 10 * pt
                Layout.leftMargin: 25 * pt
                Layout.rightMargin: 10 * pt

                Rectangle
                {
                    id: frameSignatureType
                    height: 60 * pt
        //            width: 350 * pt
                    color: "transparent"
                    Layout.fillWidth: true

                    DapComboBox
                    {
                        id: comboboxNetwork

//                        anchors.centerIn: parent
//                        anchors.fill: parent
//                        anchors.leftMargin: 35 * pt
//                        anchors.rightMargin: 37 * pt
//                        anchors.topMargin: 11 * pt
//                        anchors.bottomMargin: 17 * pt

                        anchors.centerIn: parent
                        anchors.fill: parent
                        anchors.margins: 10 * pt
                        anchors.leftMargin: 15 * pt

                        comboBoxTextRole: ["name"]
                        mainLineText: "private"
                        indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                        indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                        sidePaddingNormal: 10 * pt
                        sidePaddingActive: 10 * pt
//                            hilightColor: currTheme.buttonColorNormal

                        widthPopupComboBoxNormal: 318 * pt
                        widthPopupComboBoxActive: 318 * pt
                        heightComboBoxNormal: 24 * pt
                        heightComboBoxActive: 42 * pt
                        topEffect: false

                        normalColor: currTheme.backgroundMainScreen
                        normalTopColor: currTheme.backgroundElements
                        hilightTopColor: currTheme.backgroundMainScreen

                        paddingTopItemDelegate: 8 * pt
                        heightListElement: 42 * pt
                        indicatorWidth: 24 * pt
                        indicatorHeight: indicatorWidth
                        colorDropShadow: currTheme.shadowColor
                        roleInterval: 15
                        endRowPadding: 37

                        fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
                        colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
//                            colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                        alignTextComboBox: [Text.AlignLeft, Text.AlignRight]
                    }
                }

//                RowLayout
//                {
//                    Layout.fillWidth: true
//                    Layout.minimumHeight: 40 * pt
//                    Layout.maximumHeight: 40 * pt

//                    Text
//                    {
//                        Layout.fillWidth: true
//                        color: currTheme.textColor
//                        text: qsTr("Network: ")
//                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
//                        horizontalAlignment: Text.AlignLeft
//                    }

//                    Rectangle
//                    {
//                        width: 200 * pt
//                        height: 40 * pt
//                        color: "transparent"

//                        DapComboBox
//                        {
//                            id: comboboxNetwork

//                            anchors.centerIn: parent
//                            anchors.fill: parent

//                            comboBoxTextRole: ["name"]
//                            mainLineText: "private"
//                            indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
//                            indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
//                            sidePaddingNormal: 10 * pt
//                            sidePaddingActive: 10 * pt
////                            hilightColor: currTheme.buttonColorNormal

//                            widthPopupComboBoxNormal: 318 * pt
//                            widthPopupComboBoxActive: 318 * pt
//                            heightComboBoxNormal: 24 * pt
//                            heightComboBoxActive: 42 * pt
//                            topEffect: false

//                            normalColor: currTheme.backgroundMainScreen
//                            normalTopColor: currTheme.backgroundElements
//                            hilightTopColor: currTheme.backgroundMainScreen

//                            paddingTopItemDelegate: 8 * pt
//                            heightListElement: 42 * pt
//                            indicatorWidth: 24 * pt
//                            indicatorHeight: indicatorWidth
//                            colorDropShadow: currTheme.shadowColor
//                            roleInterval: 15
//                            endRowPadding: 37

//                            fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
//                            colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
////                            colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
//                            alignTextComboBox: [Text.AlignLeft, Text.AlignRight]
//                        }
//                    }
//                }

                RowLayout
                {
                    id: chainGroup

                    Layout.fillWidth: true
                    Layout.minimumHeight: 40 * pt
                    Layout.maximumHeight: 40 * pt
                    visible: false

                    Text
                    {
                        Layout.fillWidth: true
                        color: currTheme.textColor
                        text: qsTr("Chain:")
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                        horizontalAlignment: Text.AlignLeft
                    }

                    Rectangle
                    {
                        width: 200 * pt
                        height: 40 * pt
                        color: "transparent"

                        DapComboBox
                        {
                            id: comboboxChain

                            anchors.centerIn: parent
                            anchors.fill: parent

                            comboBoxTextRole: ["name"]
                            mainLineText: "private"
                            indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                            indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                            sidePaddingNormal: 10 * pt
                            sidePaddingActive: 10 * pt
//                            hilightColor: currTheme.buttonColorNormal

                            widthPopupComboBoxNormal: 318 * pt
                            widthPopupComboBoxActive: 318 * pt
                            heightComboBoxNormal: 24 * pt
                            heightComboBoxActive: 42 * pt
                            topEffect: false

                            normalColor: currTheme.backgroundMainScreen
                            normalTopColor: currTheme.backgroundElements
                            hilightTopColor: currTheme.backgroundMainScreen

                            paddingTopItemDelegate: 8 * pt
                            heightListElement: 42 * pt
                            indicatorWidth: 24 * pt
                            indicatorHeight: indicatorWidth
                            colorDropShadow: currTheme.shadowColor
                            roleInterval: 15
                            endRowPadding: 37

                            fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
                            colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
//                            colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                            alignTextComboBox: [Text.AlignLeft, Text.AlignRight]
                        }
                    }
                }

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
                    anchors.left: parent.left
                    anchors.leftMargin: 17 * pt
                    anchors.topMargin: 20 * pt
                    anchors.bottomMargin: 5 * pt
                    horizontalAlignment: Text.AlignRight
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            ColumnLayout
            {
                id: frameInputAmountPayment
                Layout.fillWidth: true
                Layout.margins: 10 * pt
                spacing: 10 * pt

                RowLayout
                {
                    id: frameAmountField
                    Layout.fillWidth: true
                    Layout.margins: 0 * pt
//                    spacing: 28 * pt

                    TextField
                    {
                        id: textInputAmountPayment
                        Layout.fillWidth: true
                        Layout.leftMargin: 15 * pt
                        width: 150 * pt
                        height: 28 * pt
                        placeholderText: "0"
//                        placeholderText: "0.0"
                        validator: RegExpValidator { regExp: /[0-9]+\.?[0-9]{0,9}/ }
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
                        width: 125 * pt
                        Layout.leftMargin: 0 * pt
                        Layout.rightMargin: 0 * pt
                        DapComboBox
                        {
                            id: comboboxToken
                            anchors.fill: parent
                            comboBoxTextRole: ["name"]
                            mainLineText: "tCELL"
                            indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                            indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                            sidePaddingNormal: 10 * pt
                            sidePaddingActive: 10 * pt
                            widthPopupComboBoxNormal: 119 * pt
                            widthPopupComboBoxActive: 119 * pt
                            heightComboBoxNormal: 24 * pt
                            heightComboBoxActive: 42 * pt
                            topEffect: false
                            x: sidePaddingNormal
                            normalColor: currTheme.backgroundMainScreen
                            normalTopColor: currTheme.backgroundElements
                            hilightTopColor: currTheme.backgroundMainScreen
//                            hilightColor: currTheme.buttonColorNormal

                            paddingTopItemDelegate: 8 * pt
                            heightListElement: 42 * pt
                            indicatorWidth: 24 * pt
                            indicatorHeight: indicatorWidth
                            colorDropShadow: currTheme.shadowColor
                            roleInterval: 15
                            endRowPadding: 37
                            fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
                            colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
//                            colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
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
                    anchors.leftMargin: 17 * pt
                    anchors.topMargin: 20 * pt
                    anchors.bottomMargin: 5 * pt
                }
            }

            Rectangle
            {
                id: frameRecipientWalletAddress
                Layout.fillWidth: true
                Layout.leftMargin: 20 * pt
                Layout.rightMargin: 20 * pt
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
                    anchors.topMargin: 26 * pt
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

            Rectangle
            {
                width: 278*pt
                height: 69 * pt
                color: "transparent"
                Layout.topMargin: 43 * pt
                Layout.fillWidth: true

                Text
                {
                    id: textNotEnoughTokensWarning
                    anchors.fill: parent
                    anchors.leftMargin: 37 * pt
                    anchors.rightMargin: 36 * pt
                    color: "#79FFFA"
                    text: qsTr("Not enough available tokens. Enter a lower value.")
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    visible: true
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
                Layout.topMargin: 35 * pt
                textButton: qsTr("Send")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
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

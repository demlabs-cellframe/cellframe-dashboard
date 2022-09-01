import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.5 as Controls
import QtQuick.Layouts 1.4
import QtGraphicalEffects 1.0

import "qrc:/widgets"
import "../../../"
import "../../controls"

DapRectangleLitAndShaded
{
    property alias dapButtonClose: itemButtonClose

    /// @param dapButtonSend Send funds button.
    property alias dapButtonSend: buttonSend
    /// @param dapTextInputAmountPayment Input field for transfer amount.
    property alias dapTextInputAmountPayment: textInputAmountPayment
    /// @param dapComboBoxTokenModel Token combobox model.
    property alias dapComboBoxTokenModel: comboboxToken.model

    property alias dapComboboxNetwork: comboboxNetwork
    property alias dapComboboxChain: comboboxChain

    property alias dapWalletMessagePopup: walletMessagePopup

    property alias dapChainGroup: chainGroup

    property alias dapComboBoxNetworkModel: comboboxNetwork.model
    property alias dapComboBoxChainModel: comboboxChain.model

    property alias dapComboBoxToken: comboboxToken

    property alias dapFrameAmountPayment: frameAmountPayment
    property alias dapFrameInputAmountPayment: frameInputAmountPayment
    property alias dapFrameRecipientWallet: frameRecipientWallet
    property alias dapFrameRecipientWalletAddress: frameRecipientWalletAddress

    property alias dapTextNotEnoughTokensWarning: textNotEnoughTokensWarning
    //@param dapSendedToken Name of token to send
    property string dapSendedToken: comboboxToken.displayText

    /// @param dapTextInputRecipientWalletAddress Recipient wallet address input field.
    property alias dapTextInputRecipientWalletAddress: textInputRecipientWalletAddress

    color: currTheme.backgroundElements
    radius: currTheme.radiusRectangle
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    DapMessagePopup
    {
        id: walletMessagePopup
        dapButtonCancel.visible: true
    }

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16

                id: itemButtonClose
                height: 20 
                width: 20 
                heightImage: 20 
                widthImage: 20 

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
            }

            Text
            {
                id: textHeader
                text: qsTr("New payment")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }
        }

        // Sender wallet
        Rectangle
        {
            id: frameSenderWallet
            Layout.fillWidth: true
            color: currTheme.backgroundMainScreen
            height: 30 
            Text
            {
                id: textFrameSenderWallet
                color: currTheme.textColor
                text: qsTr("From")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        ColumnLayout
        {
            id: frameSenderWalletAddress

            Layout.fillWidth: true
            spacing: 10
            Layout.margins: 10 
            Layout.leftMargin: 16

            Rectangle
            {
                id: frameSignatureType
                height: 42 
                color: "transparent"
                Layout.fillWidth: true

                DapComboBox
                {
                    id: comboboxNetwork

                    anchors.centerIn: parent
                    anchors.fill: parent
                    anchors.leftMargin: 5 
                    anchors.rightMargin: 5

                    font: mainFont.dapFont.regular16

                    defaultText: qsTr("Networks")
                }
            }

            RowLayout
            {
                id: chainGroup

                Layout.fillWidth: true
                Layout.minimumHeight: 40 
                Layout.maximumHeight: 40 
                visible: false

                Text
                {
                    Layout.fillWidth: true
                    color: currTheme.textColor
                    text: qsTr("Chain:")
                    font: mainFont.dapFont.regular14
                    horizontalAlignment: Text.AlignLeft
                }

                Rectangle
                {
                    width: 200 
                    height: 40 
                    color: "transparent"

                    DapComboBox
                    {
                        id: comboboxChain

                        anchors.centerIn: parent
                        anchors.fill: parent

                        font: mainFont.dapFont.regular16
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
            height: 30 
            Text
            {
                id: textFrameamountPayment
                color: currTheme.textColor
                text: qsTr("Amount")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        ColumnLayout
        {
            id: frameInputAmountPayment
            Layout.fillWidth: true
            Layout.margins: 10 

            Layout.leftMargin: 36
            Layout.rightMargin: 16

            spacing: 10

            RowLayout
            {
                id: frameAmountField
                Layout.fillWidth: true
                Layout.margins: 0 

                TextField
                {
                    id: textInputAmountPayment
                    Layout.fillWidth: true
                    width: 171
                    Layout.minimumHeight: 40
                    Layout.maximumHeight: 40
    //                        placeholderText: "0"
    //                        placeholderText: "0.0"
                    validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                    font: mainFont.dapFont.regular16
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
                                    radius: 4 
                                    border.color: currTheme.borderColor
                                    color: currTheme.backgroundElements
                                }
                        }
                }

                Rectangle
                {
                    id: frameSenderWalletToken
                    color: "transparent"
                    height: 42 
                    width: 125 
                    Layout.leftMargin: 5
                    Layout.rightMargin: 0 
                    DapComboBox
                    {
                        id: comboboxToken
                        anchors.fill: parent

                        defaultText: qsTr("Tokens")

                        font: mainFont.dapFont.regular16
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
            height: 30 
            Text
            {
                id: textRecipientWallet
                color: currTheme.textColor
                text: qsTr("To")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        Rectangle
        {
            id: frameRecipientWalletAddress
            Layout.fillWidth: true
            Layout.leftMargin: 36
            Layout.rightMargin: 36
            height: 53 
            color: "transparent"

            TextField
            {
                id: textInputRecipientWalletAddress
                Layout.fillWidth: true
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: qsTr("Paste here")
                validator: RegExpValidator { regExp: /[0-9A-Za-z]+/ }
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
                anchors.topMargin: 20
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
                height: 1 
                width: parent.width
                color: currTheme.borderColor
                anchors.top: textInputRecipientWalletAddress.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 8 
    //                    anchors.leftMargin: 20 
    //                    anchors.rightMargin: 20 
            }
        }

        Rectangle
        {
            width: 278*pt
            height: 69 
            color: "transparent"
            Layout.topMargin: 43 
            Layout.fillWidth: true


        }

        Item{Layout.fillHeight: true}

        Text
        {
            id: textNotEnoughTokensWarning

            Layout.fillWidth: true
            Layout.bottomMargin: 12
            Layout.maximumWidth: 281
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

            color: "#79FFFA"
            text: qsTr("Not enough available tokens. Enter a lower value.")
            font: mainFont.dapFont.regular14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            visible: false
        }

        // Button "Send"
        DapButton
        {
            id: buttonSend

            implicitHeight: 36
            implicitWidth: 132

            Layout.bottomMargin: 40
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            textButton: qsTr("Send")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular16
        }
    }
}

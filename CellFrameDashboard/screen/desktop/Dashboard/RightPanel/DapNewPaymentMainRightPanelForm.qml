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

    property alias loadIndicator: loadIndicator

    property alias balance: balance

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    Component.onCompleted:
    {
        updateWindow()
    }

    DapFeePopup
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
                color: currTheme.white
            }
        }

        // Sender wallet
        Rectangle
        {
            id: frameSenderWallet
            Layout.fillWidth: true
            color: currTheme.mainBackground
            height: 30 
            Text
            {
                id: textFrameSenderWallet
                color: currTheme.white
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

                DapCustomComboBox
                {
                    id: comboboxNetwork

                    anchors.centerIn: parent
                    anchors.fill: parent
                    anchors.leftMargin: 5 
                    anchors.rightMargin: 5
                    backgroundColorShow: currTheme.secondaryBackground
                    mainTextRole: "networkName"
                    font: mainFont.dapFont.regular16
                    model: walletModelInfo
                    defaultText: qsTr("Networks")

                    onCurrantDisplayTextChanged:
                    {
                        walletModule.setWalletTokenModel(dapComboboxNetwork.displayText)
                        updateWindow()
                    }
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
                    color: currTheme.white
                    text: qsTr("Chain:")
                    font: mainFont.dapFont.regular14
                    horizontalAlignment: Text.AlignLeft
                }

                Rectangle
                {
                    width: 200 
                    height: 40 
                    color: "transparent"

                    DapCustomComboBox
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
            color: currTheme.mainBackground
            height: 30

            RowLayout{
                anchors.fill: parent
                spacing: 0

                Text
                {
                    Layout.alignment:  Qt.AlignLeft | Qt.AlignVCenter
                    Layout.leftMargin: 16

                    color: currTheme.white
                    text: qsTr("Amount")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                }

                RowLayout{
                    Layout.alignment:  Qt.AlignRight | Qt.AlignVCenter
                    Layout.maximumWidth: 150
                    spacing: 0

                    Text
                    {
                        Layout.alignment:  Qt.AlignRight | Qt.AlignVCenter
                        color: currTheme.gray
                        text: qsTr("Balance: ")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                    }

                    DapBigText
                    {
                        id: balance
                        textElement.horizontalAlignment: Text.AlignRight
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment:  Qt.AlignRight | Qt.AlignVCenter
                        Layout.rightMargin: 16
                        textFont: mainFont.dapFont.medium12
                        textColor: currTheme.white

                        Component.onCompleted:
                        {
                            fullText = walletTokensModel.get(dapComboBoxToken.displayText).value + " " + dapComboBoxToken.displayText
                        }
                    }

                }
            }
        }

        ColumnLayout
        {
            property bool percentIsSelected: false

            id: frameInputAmountPayment
            Layout.fillWidth: true
            Layout.margins: 10 

            Layout.topMargin: 20
            Layout.leftMargin: 36
            Layout.rightMargin: 16

            spacing: 10

            RowLayout
            {
                id: frameAmountField
                Layout.fillWidth: true
                Layout.margins: 0

                DapTextField
                {
                    property string realAmount: "0.00"
                    property string abtAmount: "0.00"

                    id: textInputAmountPayment
                    Layout.fillWidth: true
                    width: 171
                    Layout.minimumHeight: 40
                    Layout.maximumHeight: 40
                    placeholderText: "0.0"
                    validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignRight
                    borderWidth: 1
                    borderRadius: 4
                    selectByMouse: true

                    onTextChanged: {
                        if(frameInputAmountPayment.percentIsSelected)
                            frameInputAmountPayment.percentIsSelected = false
                        else
                        {
                            button25.selected = false
                            button50.selected = false
                            button75.selected = false
                            button100.selected = false
                        }
                    }


                    DapContextMenu{}
                }

                Rectangle
                {
                    id: frameSenderWalletToken
                    color: "transparent"
                    height: 42
                    width: 125
                    Layout.leftMargin: 5
                    Layout.rightMargin: 0
                    DapCustomComboBox
                    {
                        id: comboboxToken
                        anchors.fill: parent

                        defaultText: qsTr("Tokens")
                        backgroundColorShow: currTheme.secondaryBackground
                        mainTextRole: "tokenName"
                        model: walletTokensModel
                        font: mainFont.dapFont.regular16

                        onCurrentTextChanged: {
                            textInputAmountPayment.text = ""
                        }
                    }
                }

            }

            RowLayout
            {
                Layout.fillWidth: true
                Layout.rightMargin: 20

                DapButton
                {
                    id: button25
                    Layout.fillWidth: true
                    implicitHeight: 26
                    textButton: qsTr("25%")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium12
                    selected: false
                    onClicked:
                    {
                        if(button25.selected)
                        {
                            textInputAmountPayment.text = ""
                            return
                        }

                        button25.selected = true
                        button50.selected = false
                        button75.selected = false
                        button100.selected = false

                        var data = {
                        "network"      : dapComboboxNetwork.displayText,
                        "percent"      : "0.25",
                        "send_ticker"  : dapComboBoxToken.displayText,
                        "wallet_name"  : walletInfo.name}

                        var res = walletModule.calculatePrecentAmount(data);
                        frameInputAmountPayment.percentIsSelected = true
                        textInputAmountPayment.text = res
                        textInputAmountPayment.cursorPosition = 0
                    }
                }

                DapButton
                {
                    id: button50
                    Layout.fillWidth: true
                    implicitHeight: 26
                    textButton: qsTr("50%")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium12
                    selected: false
                    onClicked:
                    {
                        if(button50.selected)
                        {
                            textInputAmountPayment.text = ""
                            return
                        }
                        button25.selected = false
                        button50.selected = true
                        button75.selected = false
                        button100.selected = false

                        var data = {
                        "network"      : dapComboboxNetwork.displayText,
                        "percent"      : "0.5",
                        "send_ticker"   : dapComboBoxToken.displayText,
                        "wallet_name"  : walletInfo.name}

                        var res = walletModule.calculatePrecentAmount(data);
                        frameInputAmountPayment.percentIsSelected = true
                        textInputAmountPayment.text = res
                        textInputAmountPayment.cursorPosition = 0
                    }
                }

                DapButton
                {
                    id: button75
                    Layout.fillWidth: true
                    implicitHeight: 26
                    textButton: qsTr("75%")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium12
                    selected: false
                    onClicked:
                    {
                        if(button75.selected)
                        {
                            textInputAmountPayment.text = ""
                            return
                        }
                        button25.selected = false
                        button50.selected = false
                        button75.selected = true
                        button100.selected = false

                        var data = {
                        "network"      : dapComboboxNetwork.displayText,
                        "percent"      : "0.75",
                        "send_ticker"   : dapComboBoxToken.displayText,
                        "wallet_name"  : walletInfo.name}

                        var res = walletModule.calculatePrecentAmount(data);
                        frameInputAmountPayment.percentIsSelected = true
                        textInputAmountPayment.text = res
                        textInputAmountPayment.cursorPosition = 0
                    }
                }

                DapButton
                {
                    id: button100
                    Layout.fillWidth: true
                    implicitHeight: 26
                    textButton: qsTr("100%")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium12
                    selected: false
                    onClicked:
                    {
                        if(button100.selected)
                        {
                            textInputAmountPayment.text = ""
                            return
                        }

                        button25.selected = false
                        button50.selected = false
                        button75.selected = false
                        button100.selected = true

                        var data = {
                        "network"      : dapComboboxNetwork.displayText,
                        "percent"      : "1.0",
                        "send_ticker"   : dapComboBoxToken.displayText,
                        "wallet_name"  : walletInfo.name}

                        var res = walletModule.calculatePrecentAmount(data);
                        frameInputAmountPayment.percentIsSelected = true
                        textInputAmountPayment.text = res
                        textInputAmountPayment.cursorPosition = 0
                    }
                }
            }

            Text{
                id: warnMtoken
                Layout.fillWidth: true
                height: 32
                visible: comboboxToken.currentText[0] === "m"
                text: qsTr("Warning! To unstake you need to have the exact amount of m-tokens in the wallet you staked")
                font: mainFont.dapFont.regular12
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                color: "#FFCD44"
            }

        }

        // Recipient wallet
        Rectangle
        {
            id: frameRecipientWallet
            Layout.topMargin: 10
            Layout.fillWidth: true
            color: currTheme.mainBackground
            height: 30 
            Text
            {
                id: textRecipientWallet
                color: currTheme.white
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
            Layout.leftMargin: 28
            Layout.rightMargin: 28
            height: 53 
            color: "transparent"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            DapTextField
            {
                id: textInputRecipientWalletAddress
                anchors.verticalCenter: parent.verticalCenter
                anchors.fill: parent
                anchors.topMargin: 20

                placeholderText: "nTSTphWddAcMUpSNXEOTztqLUifmLuhbZMycDbGNVZCdQEelLewojIrlyQtRvwZtIFYuLEKOMoulwTEyotCdUjdZnzBEqkLnaGpQxp"
                validator: RegExpValidator { regExp: /[0-9A-Za-z]+/ }
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft

                bottomLineVisible: true
                bottomLineSpacing: 6
                bottomLineLeftRightMargins: 7

                selectByMouse: true
                DapContextMenu{}
            }
        }

        Text
        {
            id: textNotEnoughTokensWarning

            Layout.fillWidth: true
            Layout.maximumWidth: 281
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: 12
            Layout.bottomMargin: 12

            color: currTheme.neon
            text: qsTr("Not enough available tokens. Enter a lower value.")
            font: mainFont.dapFont.regular12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            visible: false
        }

        Item{
            Layout.fillHeight: true
        }

        DapLoadIndicator {
            id: loadIndicator
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 12

            indicatorSize: 32
            countElements: 6
            elementSize: 5
            visible: running

            running: true
        }

        // Button "Send"
        DapButton
        {
            id: buttonSend

            implicitHeight: 36
            Layout.fillWidth: true
            Layout.leftMargin: 36
            Layout.rightMargin: 36

            Layout.bottomMargin: 40
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            textButton: ""

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 6

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font: mainFont.dapFont.medium14
                color: currTheme.white

                text: textInputAmountPayment.text === "" ? qsTr("Send") + " 0 " + comboboxToken.displayText
                                                         : qsTr("Send") + " " + textInputAmountPayment.text + " " + comboboxToken.displayText

                elide: Text.ElideMiddle

            }
        }
    }

    function updateWindow()
    {
        if (walletModelInfo.count <= dapComboboxNetwork.currentIndex)
        {
            console.warn("walletModelInfo.count <= dapComboboxNetwork.currentIndex")
        }
        else
        {
            console.log("dapComboboxNetwork.onCurrentIndexChanged")

            if (walletTokensModel.count === 0)
            {
                frameAmountPayment.visible = false
                frameInputAmountPayment.visible = false
                frameRecipientWallet.visible = false
                frameRecipientWalletAddress.visible = false
                textNotEnoughTokensWarning.visible = false
                buttonSend.visible = false
            }
            else
            {
                frameAmountPayment.visible = true
                frameInputAmountPayment.visible = true
                frameRecipientWallet.visible = true
                frameRecipientWalletAddress.visible = true
                textNotEnoughTokensWarning.visible = true
                buttonSend.visible = true
            }

            balance.fullText = walletTokensModel.get(dapComboBoxToken.displayText).value
                                 + " " + dapComboBoxToken.displayText

        }
    }
}

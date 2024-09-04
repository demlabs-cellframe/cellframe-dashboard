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

    property alias dapFeeController: feeController
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

    property alias balance: balance
    property bool showNetFeePopup: false

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    Component.onCompleted:
    {
        walletModule.tryUpdateFee()
        updateWindow()
    }

    DapFeePopup
    {
        id: walletMessagePopup
        dapButtonCancel.visible: true
        fee2Layout.visible: false
        height: 258

    }

    Item
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 42

        HeaderButtonForRightPanels
        {
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

    contentData:
        Controls.ScrollView
    {
        id: scrollView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 42

        Controls.ScrollBar.horizontal.policy: Controls.ScrollBar.AlwaysOff
        Controls.ScrollBar.vertical.policy: Controls.ScrollBar.AlwaysOn
        clip: true

        contentData:
            ColumnLayout
        {
            width: scrollView.width
            spacing: 0

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

                        Component.onCompleted:
                        {
                            walletModule.getComission(displayText)
                        }

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
                                button25.selected = false
                                button50.selected = false
                                button75.selected = false
                                button100.selected = false
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
                            button25.selected = true
                            button50.selected = false
                            button75.selected = false
                            button100.selected = false

                            var data = {
                                "network"      : dapComboboxNetwork.displayText,
                                "percent"      : 25,
                                "send_ticker"   : dapComboBoxToken.displayText,
                                "wallet_name"  : walletInfo.name}

                            var res = walletModule.calculatePrecentAmount(data);
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
                            button25.selected = false
                            button50.selected = true
                            button75.selected = false
                            button100.selected = false

                            var data = {
                                "network"      : dapComboboxNetwork.displayText,
                                "percent"      : 50,
                                "send_ticker"   : dapComboBoxToken.displayText,
                                "wallet_name"  : walletInfo.name}

                            var res = walletModule.calculatePrecentAmount(data);
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
                            button25.selected = false
                            button50.selected = false
                            button75.selected = true
                            button100.selected = false

                            var data = {
                                "network"      : dapComboboxNetwork.displayText,
                                "percent"      : 75,
                                "send_ticker"   : dapComboBoxToken.displayText,
                                "wallet_name"  : walletInfo.name}

                            var res = walletModule.calculatePrecentAmount(data);
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
                            button25.selected = false
                            button50.selected = false
                            button75.selected = false
                            button100.selected = true

                            var data = {
                                "network"      : dapComboboxNetwork.displayText,
                                "percent"      : 100,
                                "send_ticker"   : dapComboBoxToken.displayText,
                                "wallet_name"  : walletInfo.name}

                            var res = walletModule.calculatePrecentAmount(data);
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
                    text: qsTr("Warning! To unstake you need to have the exact amount of mCELL in the wallet you staked")
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

            // Validator fee
            Rectangle
            {
                id: frameValidatorFee
                Layout.topMargin: 20
                Layout.fillWidth: true
                color: currTheme.mainBackground
                height: 30
                Text
                {
                    id: textValidatorFee
                    color: currTheme.white
                    text: qsTr("Validator fee")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }
            }

            DapFeeComponent
            {
                property string medianStr: ""

                id: feeController

                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                onCurrentValueChanged:
                {
                    walletModule.setUserFee(currentValue)
                }

                Component.onCompleted:
                {
                    walletModule.tryUpdateFee()
                }

                Component.onDestruction:
                {
                    walletModule.setUserFee("")
                }

                function getFeeData()
                {
                    var resFee = walletModule.getFee(dapComboboxNetwork.displayText)
                    if(resFee.error === 0 && resFee.validator_fee !== "" && resFee.network_fee !== "")
                    {
                        var new_median = resFee.validator_fee
                        if(new_median !== feeController.medianStr)
                        {
                            if(feeController.medianStr !== "")
                            {
                                notifyAboutChange(new_median)
                            }
                            else
                            {
                                init(generateRanges(new_median))
                            }
                            feeController.medianStr = new_median
                        }
                        showNetFeePopup = !(resFee.network_fee === "0.0")
                    }
                }

                function notifyAboutChange(new_median)
                {
                    var new_ranges = generateRanges(new_median)
                    feeController.rangeValues = new_ranges
                    initStates()
                    dapTextNotEnoughTokensWarning.text =
                            qsTr("Validator fee was been changed. New median data: %1")
                    .arg(new_median)
                }

                function generateRanges(median_str)
                {
                    var median = parseFloat(median_str);
                    return {
                        "veryLow": 0,
                        "low": median/2,
                        "middle": median,
                        "high": median * 1.5,
                        "veryHigh": median * 2
                    }
                }
            }


            Item{Layout.fillHeight: true}

            Text
            {
                id: textNotEnoughTokensWarning

                Layout.fillWidth: true
                Layout.bottomMargin: 12
                Layout.maximumWidth: 281
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

                color: currTheme.neon
                text: qsTr("Not enough available tokens. Enter a lower value.")
                font: mainFont.dapFont.regular12
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
                frameValidatorFee.visible = false
                feeController.visible = false
                buttonSend.visible = false
            }
            else
            {
                frameAmountPayment.visible = true
                frameInputAmountPayment.visible = true
                frameRecipientWallet.visible = true
                frameRecipientWalletAddress.visible = true
                textNotEnoughTokensWarning.visible = true
                frameValidatorFee.visible = true
                feeController.visible = true
                buttonSend.visible = true
            }
            if(comboboxNetwork.displayText !== "")
            {
                walletModule.getComission(dapComboboxNetwork.displayText)
                feeController.valueName = modulesController.getMainTokenName(dapComboboxNetwork.displayText)
                feeController.medianStr = ""
                feeController.getFeeData()

            }

            balance.fullText = walletTokensModel.get(dapComboBoxToken.displayText).value
                    + " " + dapComboBoxToken.displayText

        }
    }

    Connections
    {
        target: walletModule
        function onFeeInfoUpdated()
        {
            feeController.getFeeData()
        }
    }

}

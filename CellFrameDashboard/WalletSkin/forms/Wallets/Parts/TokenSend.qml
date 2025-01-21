import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../controls"
import "../Logic"

DapBottomScreen{
    id:root
    property var tokenData: selectedToken.get(0)
    LogicWallet{id: logicWallet}

    property var feeStruct: {
        "error": 1,
        "fee_ticker": "UNKNOWN",
        "network_fee": "0.00",
        "validator_fee": "0.00"
    }

    heightForm: 401
    header.text: qsTr("Send ") + tokenData.tokenName
    backButton.visible: true

    DapMessagePopup
    {
        id: walletMessagePopup
        dapButtonCancel.visible: true

        onSignalAccept:
        {
            console.log("dapWalletMessagePopup.onSignalAccept", accept)
            if (accept)
            {
                feeStruct = walletModule.getFee(walletModule.currentNetworkName);
                console.log("Validator fee:", feeStruct.validator_fee)

                var amount = logicWallet.toDatoshi(textInputAmountPayment.text)
                var commission = logicWallet.toDatoshi(feeStruct.validator_fee)

                console.log("DapCreateTransactionCommand:")
                console.log("   network:", walletModule.currentNetworkName )
                console.log("   wallet from:", walletModule.currentWalletName)
                console.log("   wallet to:", textInputRecipientWalletAddress.text)
                console.log("   token:", tokenData.tokenName)
                console.log("   amount:", amount)
                console.log("   comission:", commission)

                logicMainApp.requestToService("DapCreateTransactionCommand",
                    walletModule.currentNetworkName,
                    walletModule.currentWalletName,
                    textInputRecipientWalletAddress.text,tokenData.tokenName,
                    amount, commission)
            }
        }
    }

    dataItem:
    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 16
        anchors.bottomMargin: 0
        spacing: 0


        RowLayout{
            Layout.topMargin: 4
            width: 15
            spacing: 0

            Text
            {
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Amount")
                font: mainFont.dapFont.medium12
                color: currTheme.gray
            }

            Item{Layout.fillWidth: true}


            Item{
                Layout.fillWidth: true
                height: 15

                Text
                {
                    id: balanceText
                    anchors.right: balanceValue.left
                    text: qsTr("Balance:")
                    font: mainFont.dapFont.medium12
                    color: currTheme.gray
                }

                DapBigText
                {
                    id: balanceValue
                    anchors.right: parent.right
                    width: 120
                    height: 15
                    textColor: currTheme.white
                    horizontalAlign: Qt.AlignRight
                    fullText: tokenData.value + " " + tokenData.tokenName
                    textFont: mainFont.dapFont.medium12
                }
            }
        }

        Rectangle{
            Layout.fillWidth: true
            Layout.topMargin: 6
            height: 40
            radius: 4
            color: currTheme.secondaryBackground

            RowLayout
            {
                anchors.fill: parent
                spacing: 0

                DapWalletTextField
                {
                    id: textInputAmountPayment
                    Layout.fillWidth: true
                    Layout.minimumHeight: 40
                    Layout.maximumHeight: 40
                    placeholderText: qsTr("0.0")
                    validator: RegExpValidator { regExp: /[0-9]*\.*\,?[0-9]{0,18}/ }
                    inputMethodHints: Qt.ImhDigitsOnly
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignLeft
                    placeholderColor: currTheme.gray

                    borderWidth: 0
                    borderRadius: 4
                    backgroundColor: currTheme.secondaryBackground

                    selectByMouse: true

                    onTextChanged: {
                        if (text.charAt(text.length - 1) === ',') {
                            text = text.slice(0, text.length - 1) + ".";
                        }
                    }
                    onUpdateFeild:
                    {
                        if(textInputAmountPayment.activeFocus)
                        {
                            var delta = textInputAmountPayment.getDelta()
                            if(delta)
                            {
                                form.y = root.parent.height - (heightForm + delta)
                            }
                        }
                        else
                        {
                            form.y = root.parent.height - heightForm
                        }
                    }
                }

                Text
                {
                    id: textToken
                    Layout.fillHeight: true
                    verticalAlignment: Qt.AlignVCenter
                    Layout.rightMargin: 12
                    color: currTheme.white
                    font: mainFont.dapFont.regular16
                    text: tokenData.tokenName
                }
            }
        }

        Text
        {
            Layout.topMargin: 20
            text: qsTr("To")
            font: mainFont.dapFont.medium12
            color: currTheme.gray
        }

        DapWalletTextField
        {
            id: textInputRecipientWalletAddress
            Layout.fillWidth: true
            Layout.topMargin: 6
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40

            placeholderText: qsTr("Paste here")
            validator: RegExpValidator { regExp: /[0-9A-Za-z]+/ }
            font: mainFont.dapFont.regular16
            horizontalAlignment: Text.AlignLeft
            borderWidth: 0
            borderRadius: 4
            placeholderColor: currTheme.gray
            backgroundColor: currTheme.secondaryBackground
            selectByMouse: true

            onUpdateFeild:
            {
                if(activeFocus)
                {
                    var delta = textInputRecipientWalletAddress.getDelta()
                    if(delta)
                    {
                        form.y = root.parent.height - (heightForm + delta)
                    }
                }
                else
                {
                    form.y = root.parent.height - heightForm
                }
            }
        }

        Item{
            Layout.fillHeight: true
        }

        Text
        {
            id: textNotEnoughTokensWarning

            Layout.fillWidth: true
            Layout.bottomMargin: 12
            Layout.maximumWidth: 281
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

            color: currTheme.neon
            text: qsTr("Not enough available tokens. Enter a lower value.")
            font: mainFont.dapFont.regular14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            visible: false
        }

        Item {
            Layout.fillHeight: true
        }


        DapButton{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.bottomMargin: 48

            Layout.minimumHeight: 36
            Layout.maximumHeight: 36
            Layout.maximumWidth: 132
            Layout.minimumWidth: 132

            textButton: qsTr("Send")

            implicitHeight: 36
            implicitWidth: 132
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked:
            {
                console.log("balance:", tokenData.datoshi)
                console.log("amount:", textInputAmountPayment.text)
                console.log("wallet address:", textInputRecipientWalletAddress.text.length)
                console.log("full_balance", tokenData.value)

                if (textInputAmountPayment.text === "" ||
                    logicWallet.testAmount("0.0", textInputAmountPayment.text))
                {
                    console.log("Zero value")
                    textNotEnoughTokensWarning.visible = true
                    textNotEnoughTokensWarning.text = qsTr("Zero value.")
                }
                else
                if (textInputRecipientWalletAddress.text.length != 104 && textInputRecipientWalletAddress.text !== "null")
                {
                    console.log("Wrong address length")
                    textNotEnoughTokensWarning.visible = true
                    textNotEnoughTokensWarning.text = qsTr("Enter a valid wallet address.")
                }
                else
                {
                    var data = {
                        "network"      : walletModule.currentNetworkName,
                        "amount"       : textInputAmountPayment.text,
                        "send_ticker"  : tokenData.tokenName,
                        "wallet_name"  : walletModule.currentWalletName}

                    var res = walletModule.approveTx(data);

                    switch(res.error) {
                    case 0:
                        console.log("Correct tx data")
                        feeStruct = walletModule.getFee(walletModule.currentNetworkName);
                        console.log("Validator fee:", feeStruct.validator_fee)

                        if(feeStruct.error === 0)
                        {
                            textNotEnoughTokensWarning.visible = false
                            textNotEnoughTokensWarning.text = ""
                            var feeMsg = "\r\n" + qsTr("Network: ") + feeStruct.network_fee + " " + feeStruct.fee_ticker +
                                    "\r\n" + qsTr("Validator: ") + feeStruct.validator_fee + " " + feeStruct.fee_ticker;
                            walletMessagePopup.smartOpen(
                                        qsTr("Confirming the transaction"),
                                        qsTr("Attention, the transaction fee will be") + feeMsg)
                            console.log("Stop update fee timer")
                        }
                        else
                        {
                            textNotEnoughTokensWarning.visible = true
                            textNotEnoughTokensWarning.text = qsTr("Error processing network information")
                        }
                        break;
                    case 1:
                        console.warn("Rcv fee error")
                        textNotEnoughTokensWarning.visible = true
                        textNotEnoughTokensWarning.text = qsTr("Error processing network information")
                        break;
                    case 2:
                        console.warn("Not enough tokens")
                        textNotEnoughTokensWarning.visible = true
                        textNotEnoughTokensWarning.text =
                                qsTr("Not enough available tokens. Maximum value with fee = %1. Enter a lower value. Current value = %2")
                        .arg(res.availBalance).arg(textInputAmountPayment.text)
                        break;
                    case 3:
                        console.warn("Not enough tokens for pay fee")
                        textNotEnoughTokensWarning.visible = true
                        textNotEnoughTokensWarning.text =
                                qsTr("Not enough available tokens for fee. Balance = %1. Current fee value = %2")
                        .arg(res.availBalance).arg(res.feeSum)
                        break;
                    case 4:
                        console.warn("No tokens for create transaction")
                        textNotEnoughTokensWarning.visible = true
                        textNotEnoughTokensWarning.text =
                                qsTr("No tokens for create transaction")
                        break;
                    default:
                        console.warn("Unknown error")
                        textNotEnoughTokensWarning.visible = true
                        textNotEnoughTokensWarning.text =
                                qsTr("Unknown error")
                        break;
                    }
                }
            }
        }
    }
    
    Connections
    {
        target: dapServiceController
        function onTransactionCreated(aResult)
        {
            var jsonDoc = JSON.parse(aResult)
            if(jsonDoc) {
                logicMainApp.commandResult = jsonDoc.result
                dapBottomPopup.push("qrc:/walletSkin/forms/Wallets/Parts/TokenSendDone.qml")
            }
            else
            {
                console.log("Transaction create error")
            }
        }
    }

    Connections
    {
        target:root
        function onAnimationStopped()
        {
            if(textInputAmountPayment.activeFocus)
            {
                var delta = textInputAmountPayment.getDelta()
                if(delta)
                {
                    form.y = root.parent.height - (heightForm + delta)
                }
            }
        }
    }
}

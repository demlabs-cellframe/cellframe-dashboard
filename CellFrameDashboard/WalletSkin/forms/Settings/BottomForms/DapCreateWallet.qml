import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../controls"

DapBottomScreen{
    id: root
    shift: 300
    ListModel
    {
        id: signatureTypeWallet
        ListElement
        {
            name: "Dilithium"
            sign: "sig_dil"
            secondname: qsTr("Recommended")
        }
        ListElement
        {
            name: "Falcon"
            sign: "sig_falcon"
            secondname: ""
        }
    }

    ListModel
    {
        id: typeWallet
        ListElement{ name: qsTr("Protected")}
        ListElement{ name: qsTr("Standard")}
    }

    ListModel
    {
        id: recoveryModel
        ListElement{ name: qsTr("24 words")}
//        { "Export to file" or "Backup file" }
    }

    heightForm: comboBoxTypeWallet.displayText === qsTr("Protected") ? 563 : 482
    header.text: logicMainApp.restoreWalletMode ? qsTr("Restore a wallet") : qsTr("Create wallet")

    Component.onCompleted:
    {
        logicMainApp.walletPass = ""
        logicMainApp.walletType = ""
        logicMainApp.walletRecoveryHash = ""
        logicMainApp.walletSign = ""
        logicMainApp.walletName = ""
        logicMainApp.walletRecoveryType = qsTr("24 words")

        if(logicMainApp.restoreWalletMode)
        {
            // Add bliss and picnic signature only for restore mode
            signatureTypeWallet.append(
                        { name : "Bliss",
                            sign: "sig_bliss",
                            secondname: qsTr("Depricated") })
            signatureTypeWallet.append(
                        { name : "Picnic",
                            sign: "sig_picnic",
                            secondname: qsTr("Depricated") })

            recoveryModel.append({ name: qsTr("Backup file")})
        }
        else
        {
            recoveryModel.append({ name: qsTr("Export to file")})
        }
    }

    dataItem:
    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 16
        anchors.bottomMargin: 0
        spacing: 0

        Text
        {
            Layout.topMargin: 4
            Layout.minimumHeight: 15
            Layout.maximumHeight: 15
            text: qsTr("Wallet name")
            font: mainFont.dapFont.regular12
            color: currTheme.gray
        }

        DapWalletTextField
        {
            id: textInputNameWallet
            Layout.fillWidth: true
            Layout.topMargin: 6
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            placeholderText: qsTr("Your wallet name")
            validator: RegExpValidator { regExp: /[0-9A-Za-z\_]+/ }
            font: mainFont.dapFont.regular16
            horizontalAlignment: Text.AlignLeft
            placeholderColor: currTheme.gray
            backgroundColor: currTheme.secondaryBackground
            selectByMouse: !params.isMobile

            onUpdateFeild:
            {
                if(textInputNameWallet.activeFocus)
                {
                    var delta = textInputNameWallet.getDelta()
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
            Connections
            {
                target:root
                function onAnimationStopped()
                {
                    if(textInputNameWallet.activeFocus)
                    {
                        var delta = textInputNameWallet.getDelta()
                        if(delta)
                        {
                            form.y = root.parent.height - (heightForm + delta)
                        }
                    }
                }
            }
        }

        Text
        {
            Layout.topMargin: 20
            Layout.minimumHeight: 15
            Layout.maximumHeight: 15
            text: qsTr("Choose signature type")
            font: mainFont.dapFont.regular12
            color: currTheme.gray
        }

        Rectangle
        {
            z: comboBoxSignatureTypeWallet.popupVisible ? 100 : 80
            Layout.topMargin: 6
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            color: "transparent"
            Layout.fillWidth: true
            DefaultComboBox
            {
                z: 100
                id: comboBoxSignatureTypeWallet
                model: signatureTypeWallet
                leftMarginText: 8
                rightMarginIndicator: 4
                anchors.fill: parent
                font: mainFont.dapFont.regular16
                defaultText: qsTr("all signature")
            }
        }

        Text
        {
            Layout.topMargin: 20
            Layout.minimumHeight: 15
            Layout.maximumHeight: 15
            text: qsTr("Type of wallet")
            font: mainFont.dapFont.regular12
            color: currTheme.gray
        }

        Rectangle
        {
            z: comboBoxTypeWallet.popupVisible ? 100 : 80
            Layout.topMargin: 6
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            color: "transparent"
            Layout.fillWidth: true
            DefaultComboBox
            {
                z: 100
                id: comboBoxTypeWallet
                model: typeWallet
                leftMarginText: 8
                rightMarginIndicator: 4
                anchors.fill: parent
                font: mainFont.dapFont.regular16
                defaultText: qsTr("Protected")
                onCurrentIndexChanged: /* no call*/ form.updateY()
            }
        }

        Text
        {
            Layout.topMargin: 20
            Layout.minimumHeight: 15
            Layout.maximumHeight: 15
            text: qsTr("Wallet password")
            font: mainFont.dapFont.regular12
            color: currTheme.gray
            visible: comboBoxTypeWallet.displayText === qsTr("Protected")
        }

        Rectangle
        {
            Layout.topMargin: 6
            Layout.fillWidth: true
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            color: currTheme.secondaryBackground
            visible: comboBoxTypeWallet.displayText === qsTr("Protected")

            DapWalletTextField
            {
                id: textInputPasswordWallet
                echoMode: indicator.isActive ? TextInput.Normal : TextInput.Password
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: qsTr("Password")
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
                anchors.rightMargin: 16 + indicator.width + 5
                validator: RegExpValidator { regExp: /[0-9A-Za-z\_\:\(\)\?\@\{\}\%\<\>\,\.\*\;\:\'\"\[\]\/\?\"\|\\\^\&\*]+/ }
                indicator.anchors.rightMargin: -(16 + indicator.width/2 + 2)
                indicatorVisible: true
                indicatorSourceDisabled: "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_eyeHide.svg"
                indicatorSourceEnabled: "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_eyeShow.svg"
                indicatorSourceDisabledHover: "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_eyeHideHover.svg"
                indicatorSourceEnabledHover: "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_eyeShowHover.svg"
                selectByMouse: true
                isActiveCopy: false

                onUpdateFeild:
                {
                    if(textInputPasswordWallet.activeFocus)
                    {
                        var delta = textInputPasswordWallet.getDelta()
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
        }

        Text
        {
            Layout.topMargin: 20
            Layout.minimumHeight: 15
            Layout.maximumHeight: 15
            text: qsTr("Recovery method")
            font: mainFont.dapFont.regular12
            color: currTheme.gray
        }

        Rectangle
        {
            Layout.topMargin: 6
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            color: "transparent"
            Layout.fillWidth: true
            z: recoveryTypeWallet.popupVisible ? 100 : 80
            DefaultComboBox
            {
                z: 100
                id: recoveryTypeWallet
                model: recoveryModel
                leftMarginText: 8
                rightMarginIndicator: 4
                anchors.fill: parent
                font: mainFont.dapFont.regular16
                topOrientation: true
                defaultText: qsTr("24 words")
            }
        }

        Text
        {
            id: textError
            Layout.topMargin: 10
            Layout.fillWidth: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.bottomMargin: 10
            Layout.alignment: Qt.AlignHCenter
            color: "#79FFFA"
            text: qsTr("")
            font: mainFont.dapFont.regular14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            visible: text.length
        }

        Item{Layout.fillHeight: true}

        DapButton{
            Layout.fillWidth: true
            Layout.leftMargin: 122
            Layout.rightMargin: 122
            Layout.minimumHeight: 36
            Layout.maximumHeight: 36
            Layout.bottomMargin: 48
            textButton: qsTr("Next")
            implicitHeight: 36
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked:
            {
                if (textInputNameWallet.text === "")
                {
                    textError.text =
                        qsTr("Enter the wallet name using Latin letters, numbers and underscore.")
                    console.warn("Empty wallet name")
                }
                else
                if(comboBoxTypeWallet.displayText === "Protected" && textInputPasswordWallet.length < 4)
                {
                    textError.text =
                        qsTr("Wallet password must contain at least 4 characters")
                    console.warn("Invalid password")
                }
                else
                {
                    textError.text = ""

                    var password = comboBoxTypeWallet.displayText === qsTr("Protected") ? textInputPasswordWallet.text : ""
                    logicMainApp.walletPass =  password
                    logicMainApp.walletType = comboBoxTypeWallet.displayText
                    logicMainApp.walletRecoveryHash = ""
                    logicMainApp.walletRecoveryType = recoveryTypeWallet.displayText
                    logicMainApp.walletSign = signatureTypeWallet.get(comboBoxSignatureTypeWallet.currentIndex).sign
                    logicMainApp.walletName = textInputNameWallet.text

                    console.log("walletRecoveryType", logicMainApp.walletRecoveryType)
                    console.log("walletSign", logicMainApp.walletSign);
                    dapBottomPopup.push("qrc:/walletSkin/forms/Settings/BottomForms/DapRecoveryWallet.qml")
                }
            }
        }
    }

    Connections
    {
        target: dapServiceController
        function onWalletCreated(wallet)
        {
            logicMainApp.commandResult = wallet.result
            dapBottomPopup.push("qrc:/walletSkin/forms/Settings/BottomForms/DapCreateWalletDone.qml")
        }
    }
}

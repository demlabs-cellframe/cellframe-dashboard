import QtQuick 2.4

DapCreateWalletForm
{
//    dapNextRightPanel: recoveryWallet
//    dapPreviousRightPanel: ""

    property string dapSignatureTypeWallet

    Component.onCompleted:
    {
//        if (logicMainApp.currentTab === dashboardScreenPath)
//          dapPreviousRightPanel = lastActionsWallet
//        if (logicMainApp.currentTab === settingsScreenPath)
//          dapPreviousRightPanel = emptyRightPanel

        if (!logicMainApp.restoreWalletMode)
        {
            dapTextHeader.text = qsTr("New wallet")
            dapButtonSelectionNothing.visible = true
        }
        else
        {
            dapTextHeader.text = qsTr("Restore a wallet")
            dapButtonSelectionNothing.visible = false
        }
    }

    dapComboBoxSignatureTypeWallet.onCurrentIndexChanged:
    {
        dapSignatureTypeWallet = dapSignatureTypeWalletModel.get(dapComboBoxSignatureTypeWallet.currentIndex).sign
    }

    dapButtonNext.onClicked:
    {
        if (dapTextInputNameWallet.text === "")
        {
            dapWalletNameWarning.text =
                qsTr("Enter the wallet name using Latin letters, dotes, dashes and / or numbers.")
            console.warn("Empty wallet name")
        }
        else if(logicMainApp.walletType === "Protected" && dapTextInputPassword.length < 4)
        {
            dapWalletNameWarning.text =
                qsTr("Wallet password must contain at least 4 characters")
            console.warn("Invalid password")
        }
        else
        {
            dapWalletNameWarning.text = ""

            walletInfo.name = dapTextInputNameWallet.text
            walletInfo.signature_type = dapSignatureTypeWallet
            walletInfo.password = dapTextInputPassword.text

            if (logicMainApp.walletRecoveryType !== "Nothing")
            {
                print("walletRecoveryType", logicMainApp.walletRecoveryType)

//                dapNextRightPanel = recoveryWallet
//                nextActivated("recoveryWallet");
                navigator.recoveryWalletFunc()
            }
            else
            {
                console.log("Create new wallet " + walletInfo.name);
                console.log(walletInfo.signature_type);

                if(logicMainApp.walletType === "Protected")
                    dapServiceController.requestToService("DapAddWalletCommand",
                           walletInfo.name,
                           walletInfo.signature_type,
                           "",
                           walletInfo.password)
                else
                    dapServiceController.requestToService("DapAddWalletCommand",
                           walletInfo.name,
                           walletInfo.signature_type)

            }

        }

    }

    dapButtonClose.onClicked:
    {
        dapWalletNameWarning.text = ""
//        if (logicMainApp.currentTab === dashboardScreenPath)
//            previousActivated(lastActionsWallet)
//        if (logicMainApp.currentTab === settingsScreenPath)
//        {
//            previousActivated(emptyRightPanel)
//            dapSettingsRightPanel.visible = false
//            dapSettingsRightPanel.width = 0
//            dapSettingsScreen.dapExtensionsBlock.visible = true
//        }
        navigator.popPage()
    }

    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
//            nextActivated("doneWallet");
//            console.log(wallet.success, wallet.message)

            commandResult.success = wallet.success
            commandResult.message = wallet.message

            navigator.doneWalletFunc()
        }
    }
}

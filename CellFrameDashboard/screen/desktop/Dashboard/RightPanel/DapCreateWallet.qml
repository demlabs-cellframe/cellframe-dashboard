import QtQuick 2.4

DapCreateWalletForm
{
    dapButtonNext.onClicked:
    {
        if (dapTextInputNameWallet.text === "")
        {
            dapWalletNameWarning.text =
                qsTr("Enter the wallet name using Latin letters, dashes, underscore or numbers.")
            console.warn("Empty wallet name")
        }
        else if(walletModule.isConteinListWallets(dapTextInputNameWallet.text))
        {
            dapWalletNameWarning.text =
                qsTr("A wallet with that name already exists.")
            console.warn("A wallet with that name already exists.", dapTextInputNameWallet.text)
        }
        else if(logicWallet.walletType === "Protected" && dapTextInputPassword.length < 4)
        {
            dapWalletNameWarning.text =
                qsTr("Wallet password must contain at least 4 characters")
            console.warn("Invalid password")
        }
        else if(logicWallet.walletType === "Protected" && dapTextInputPassword.text !==  dapTextInputPasswordConfirmWallet.text)
        {
            dapWalletNameWarning.text =
                qsTr("You entered two different passwords. Please try again.")
            console.warn("Two different passwords")
        }
        else
        {
            var index = dapComboBoxSignatureTypeWallet.currentIndex === -1 ? 0 : dapComboBoxSignatureTypeWallet.currentIndex
            var dapSignatureTypeWallet = dapSignatureTypeWalletModel.get(index).sign
            dapWalletNameWarning.text = ""

            walletInfo.name = dapTextInputNameWallet.text
            walletInfo.signature_type = dapSignatureTypeWallet
            walletInfo.password = dapTextInputPassword.text

            console.log("dapTextInputNameWallet.text", dapTextInputNameWallet.text)
            console.log("walletRecoveryType", logicWallet.walletRecoveryType)

            navigator.recoveryWalletFunc()
        }

    }

    dapButtonClose.onClicked:
    {
        txExplorerModule.statusProcessing = true

        dapWalletNameWarning.text = ""
        navigator.popPage()
    }
}

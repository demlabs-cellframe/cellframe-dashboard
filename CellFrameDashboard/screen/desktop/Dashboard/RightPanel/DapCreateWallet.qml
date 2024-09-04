import QtQuick 2.4

DapCreateWalletForm
{
    Component.onCompleted: walletModule.timerUpdateFlag(false);

    dapButtonNext.onClicked:
    {
        if (dapTextInputNameWallet.text === "")
        {
            dapWalletNameWarning.text =
                qsTr("Enter the wallet name using Latin letters, dashes, underscore or numbers.")
            console.warn("Empty wallet name")
        }
        else if(logicWallet.walletType === "Protected" && dapTextInputPassword.length < 4)
        {
            dapWalletNameWarning.text =
                qsTr("Wallet password must contain at least 4 characters")
            console.warn("Invalid password")
        }
        else
        {
            dapWalletNameWarning.text = ""

            var dapSignatureTypeWallet = ""
            if(multiSigMode)
            {
                dapSignatureTypeWallet = "sig_multi_chained"
                for(var i = 0; i < dapModelMultiSig.count; i++)
                {
                    dapSignatureTypeWallet += " " + dapModelMultiSig.get(i)["sign"]
                }
            }
            else
            {
                var index = dapComboBoxSignatureTypeWallet.currentIndex === -1 ? 0 : dapComboBoxSignatureTypeWallet.currentIndex
                dapSignatureTypeWallet = dapSignatureTypeWalletModel.get(index).sign
            }

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
        walletModule.timerUpdateFlag(true);
        navigator.popPage()
    }
}

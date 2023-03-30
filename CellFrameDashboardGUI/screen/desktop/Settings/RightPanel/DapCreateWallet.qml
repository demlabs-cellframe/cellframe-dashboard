import QtQuick 2.4

DapCreateWalletForm
{
//    dapNextRightPanel: recoveryWallet
//    dapPreviousRightPanel: ""

    property string dapSignatureTypeWallet

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

            print("walletRecoveryType", logicMainApp.walletRecoveryType)

            navigator.recoveryWalletFunc()
        }

    }

    dapButtonClose.onClicked:
    {
        dapWalletNameWarning.text = ""
        navigator.popPage()
    }

    Connections
    {
        target: dapServiceController
        function onWalletCreated(wallet)
        {
            commandResult.success = wallet.success
            commandResult.message = wallet.message

            navigator.doneWalletFunc()
        }
    }
}

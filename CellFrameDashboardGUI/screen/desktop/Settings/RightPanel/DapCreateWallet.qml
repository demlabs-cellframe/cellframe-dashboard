import QtQuick 2.4

DapCreateWalletForm
{
//    dapNextRightPanel: recoveryWallet
//    dapPreviousRightPanel: ""

    property string dapSignatureTypeWallet

    Component.onCompleted:
    {
//        if (globalLogic.currentTab === "Wallet")
//          dapPreviousRightPanel = lastActionsWallet
//        if (globalLogic.currentTab === settingsScreenPath)
//          dapPreviousRightPanel = emptyRightPanel

        if (!globalLogic.restoreWalletMode)
            dapTextHeader.text = qsTr("New wallet")
        else
            dapTextHeader.text = qsTr("Restore a wallet")
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
        else
        {
            dapWalletNameWarning.text = ""

            walletInfo.name = dapTextInputNameWallet.text
            walletInfo.signature_type = dapSignatureTypeWallet

            if (globalLogic.walletRecoveryType !== "Nothing")
            {
                print("walletRecoveryType", globalLogic.walletRecoveryType)
                navigator.recoveryWalletFunc()

//                dapNextRightPanel = recoveryWallet
//                nextActivated("recoveryWallet");
            }
            else
            {
//                dapNextRightPanel = doneWallet

                console.log("Create new wallet " + walletInfo.name);
                console.log(walletInfo.signature_type);
                dapServiceController.requestToService("DapAddWalletCommand",
                       walletInfo.name,
                       walletInfo.signature_type)
            }

        }

    }

    dapButtonClose.onClicked:
    {
        dapWalletNameWarning.text = ""
        if (globalLogic.currentTab === "Wallet")
            pop()
        if (globalLogic.currentTab === "Settings")
        {
//            pop()
            navigator.popPage()
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
//            nextActivated("doneWallet");
            navigator.doneWalletFunc()
        }
    }
}

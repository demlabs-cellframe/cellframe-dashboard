import QtQuick 2.4

DapCreateWalletForm
{
    dapNextRightPanel: recoveryWallet
    dapPreviousRightPanel: emptyRightPanel

    property string dapSignatureTypeWallet

    dapComboBoxSignatureTypeWallet.onCurrentIndexChanged:
    {
        dapSignatureTypeWallet = dapSignatureTypeWalletModel.get(dapComboBoxSignatureTypeWallet.currentIndex).sign
    }

    dapUseExestionWallet.onCheckedChanged:
    {
        walletOperation = operationModel.get(dapUseExestionWallet.checked ? 1 : 0).operation
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

            if (recoverySelectionWords.checked)
            {
                dapNextRightPanel = recoveryWallet
                nextActivated("recoveryWallet");
            }
            if (recoverySelectionNothing.checked)
            {
                dapNextRightPanel = doneWallet

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
        previousActivated(lastActionsWallet)
//        dashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"
    }

    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
            nextActivated("doneWallet");
        }
    }
}

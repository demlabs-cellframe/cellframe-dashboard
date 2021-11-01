import QtQuick 2.4

DapInputNewWalletNameRightPanelForm
{
    dapNextRightPanel: recoveryWallet
    dapPreviousRightPanel: lastActionsWallet

    property string dapSignatureTypeWallet

    dapComboBoxSignatureTypeWallet.onCurrentIndexChanged:
    {
        dapSignatureTypeWallet = dapSignatureTypeWalletModel.get(dapComboBoxSignatureTypeWallet.currentIndex).sign
    }

    dapButtonNext.onClicked:
    {
        if (dapTextInputNameWallet.text === "")
        {
            dapWalletNameWarning.visible = true
            console.warn("Empty wallet name")
        }
        else
        {
            dapWalletNameWarning.visible = false

            walletInfo.name = dapTextInputNameWallet.text
            walletInfo.signature_type = dapSignatureTypeWallet

            nextActivated("recoveryWallet");
        }

    }

    dapButtonClose.onClicked:
    {
        dapWalletNameWarning.visible = false
        previousActivated(lastActionsWallet)
        dashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"
    }

//    Connections
//    {
//        target: dapServiceController
//        onWalletCreated:
//        {
//            nextActivated("doneWallet");
//        }
//    }
}

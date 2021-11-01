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

            dapServiceController.CurrentWallet = dapTextInputNameWallet.text
            dapServiceController.CurrentSignatureType = dapSignatureTypeWallet

            nextActivated("recoveryWallet");

//            console.log("Create new wallet "+dapTextInputNameWallet.text);
//            console.log(dapSignatureTypeWallet);
//            console.log(dapServiceController.CurrentNetwork)
//            dapServiceController.requestToService("DapAddWalletCommand", dapTextInputNameWallet.text    //original
//                                                  , dapSignatureTypeWallet, dapServiceController.CurrentNetwork
//                                                  , "0xad12dec5ab4f");
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

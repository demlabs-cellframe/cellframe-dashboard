import QtQuick 2.4

DapInputNewWalletNameRightPanelForm
{
    property string dapSignatureTypeWallet

    dapComboBoxSignatureTypeWallet.onCurrentIndexChanged:
    {
        dapSignatureTypeWallet = dapSignatureTypeWalletModel.get(dapComboBoxSignatureTypeWallet.currentIndex).sign
    }

    dapButtonNext.onClicked:
    {
        console.log(dapTextInputNameWallet.text)
        console.log(dapSignatureTypeWallet)
        console.log(dapServiceController.CurrentNetwork)
        dapServiceController.requestToService("DapAddWalletCommand", dapTextInputNameWallet.text    //original
                                              , dapSignatureTypeWallet, dapServiceController.CurrentNetwork
                                              , "0xad12dec5ab4f");
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
        dashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"
    }

    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
            if(wallet[0])
            {
                nextActivated("doneWallet")
            }
        }
    }

}

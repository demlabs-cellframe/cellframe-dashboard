import QtQuick 2.4

DapRecoveryWalletRightPanelForm
{
    dapNextRightPanel: doneWallet
    dapPreviousRightPanel: lastActionsWallet

    Connections
    {
        target: walletHashManager
        onSetHashString:
        {
            dapServiceController.CurrentRecoveryHash = hash
            print("hash = ", hash, dapServiceController.CurrentRecoveryHash)
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
            nextActivated("doneWallet");
        }
    }

    dapButtonNext.onClicked:
    {
        console.log("Create new wallet " + dapServiceController.CurrentWallet);
        console.log(dapServiceController.CurrentSignatureType);
        print("hash = ", dapServiceController.CurrentRecoveryHash)
        dapServiceController.requestToService("DapAddWalletCommand",
               dapServiceController.CurrentWallet,
               dapServiceController.CurrentSignatureType,
               dapServiceController.CurrentRecoveryHash)
    }

    Component.onCompleted:
    {
        print("DapRecoveryWalletRightPanelForm Component.onCompleted")

        dapServiceController.CurrentRecoveryHash = ""
        walletHashManager.generateNewWords()
    }

    dapButtonCopy.onClicked:
    {
        dapButtonCopy.colorBackgroundButton = "#EDEFF2"
        dapButtonCopy.colorTextButton = "#3E3853"

        walletHashManager.copyWordsToClipboard()
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
    }
}

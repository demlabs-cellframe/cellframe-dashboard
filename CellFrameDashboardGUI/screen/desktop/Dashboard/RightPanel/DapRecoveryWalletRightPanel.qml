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
            walletInfo.recovery_hash = hash
            print("hash = ", walletInfo.recovery_hash)
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
        console.log("Create new wallet " + walletInfo.name);
        console.log(walletInfo.signature_type);
        print("hash = ", walletInfo.recovery_hash)
        dapServiceController.requestToService("DapAddWalletCommand",
               walletInfo.name,
               walletInfo.signature_type,
               walletInfo.recovery_hash)
    }

    Component.onCompleted:
    {
        print("DapRecoveryWalletRightPanelForm Component.onCompleted")

        walletInfo.recovery_hash = ""
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

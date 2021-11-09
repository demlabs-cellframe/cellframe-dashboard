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

            if (walletInfo.recovery_hash !== "" && walletOperation !== "create")
            {
                dapTextBottomMessage.text = ""
            }
        }
        onClipboardError:
        {
            dapTextBottomMessage.color = "#FF0300"
            dapTextBottomMessage.text =
                qsTr("The clipboard does not contain 24 words.")

            dapButtonPaste.enabled = true
            dapButtonNext.enabled = false
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

    Component.onCompleted:
    {
        print("DapRecoveryWalletRightPanelForm Component.onCompleted")
        print("walletOperation", walletOperation)

        dapButtonCopy.enabled = true
        dapButtonPaste.enabled = true
        dapButtonNext.enabled = false

        walletInfo.recovery_hash = ""

        if (walletOperation === "create")
        {
            dapTextTopMessage.text =
                qsTr("Recovery words copied to clipboard. Keep them in a safe place before proceeding to the next step.")
            walletHashManager.generateNewWords()
            dapButtonPaste.visible = false
        }
        else
        {
            dapTextTopMessage.color = "#B3FF00"
            dapTextTopMessage.text =
                qsTr("Copy the previously saved words to the clipboard and click the 'Paste' button.")
            walletHashManager.clearWords()
            dapButtonCopy.visible = false
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

    dapButtonCopy.onClicked:
    {
        dapButtonCopy.enabled = false
        dapButtonNext.enabled = true

        dapTextBottomMessage.text =
            qsTr("Recovery words copied to clipboard. Keep them in a safe place before proceeding to the next step.")

        walletHashManager.copyWordsToClipboard()
    }

    dapButtonPaste.onClicked:
    {
        dapButtonPaste.enabled = false
        dapButtonNext.enabled = true

        walletHashManager.pasteWordsFromClipboard()
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
    }
}

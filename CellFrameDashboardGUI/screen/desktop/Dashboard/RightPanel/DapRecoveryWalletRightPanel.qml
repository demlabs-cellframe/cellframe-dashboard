import QtQuick 2.12
import Qt.labs.platform 1.0

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

            dapButtonAction.enabled = true
            dapButtonNext.enabled = false
        }

        onFileError:
        {
            dapTextBottomMessage.color = "#FF0300"
            if (walletOperation === "create")
                dapTextBottomMessage.text =
                    qsTr("File saving error.")
            else
                dapTextBottomMessage.text =
                    qsTr("File loading error.")

            dapButtonAction.enabled = true
            dapButtonNext.enabled = false
        }

        onSetFileName:
        {
            if (walletOperation === "create")
                dapBackupFileName.text = qsTr("File saved to:\n") + fileName
            else
                dapBackupFileName.text = qsTr("File loaded from:\n") + fileName
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

        dapButtonAction.enabled = true
        dapButtonNext.enabled = false
        walletInfo.recovery_hash = ""

        if (walletRecoveryType === "Words")
        {
            dapTextMethod.text = qsTr("24 words")

            if (walletOperation === "create")
                dapButtonAction.textButton = qsTr("Copy")
            else
                dapButtonAction.textButton = qsTr("Paste")

            dapWordsGrid.visible = true
            dapBackupFileName.visible = false
        }
        if (walletRecoveryType === "File")
        {
            dapTextMethod.text = qsTr("Backup file")

            if (walletOperation === "create")
                dapButtonAction.textButton = qsTr("Save")
            else
                dapButtonAction.textButton = qsTr("Load")

            dapWordsGrid.visible = false
            dapBackupFileName.visible = true
        }


        if (walletRecoveryType === "Words")
        {
            if (walletOperation === "create")
            {
                dapTextTopMessage.text =
                    qsTr("Click the 'Copy' button and keep these words in a safe place. They will be required to restore your wallet in case of loss of access to it.")
                walletHashManager.generateNewWords()
            }
            else
            {
                dapTextTopMessage.color = "#6F9F00"
                dapTextTopMessage.text =
                    qsTr("Copy the previously saved words to the clipboard and click the 'Paste' button.")
                walletHashManager.clearWords()
            }
        }
        if (walletRecoveryType === "File")
        {
            if (walletOperation === "create")
            {
                dapTextTopMessage.text =
                    qsTr("Click the 'Save' button and keep backup file in a safe place. They will be required to restore your wallet in case of loss of access to it.")
                walletHashManager.generateNewFile()
            }
            else
            {
                dapTextTopMessage.color = "#6F9F00"
                dapTextTopMessage.text =
                    qsTr("Click the 'Load' button and select the previously saved backup file.")
            }
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

    dapButtonAction.onClicked:
    {
        dapButtonAction.enabled = false
        dapButtonNext.enabled = true

        if (walletRecoveryType === "Words")
        {
            if (walletOperation === "create")
            {
                dapTextBottomMessage.color = "#6F9F00"
                dapTextBottomMessage.text =
                    qsTr("Recovery words copied to clipboard. Keep them in a safe place before proceeding to the next step.")

                walletHashManager.copyWordsToClipboard()
            }
            else
            {
                walletHashManager.pasteWordsFromClipboard()
            }

        }

        if (walletRecoveryType === "File")
        {
            if (walletOperation === "create")
            {
                saveFileDialog.open()
            }
            else
            {
                openFileDialog.open()
            }

        }
    }

    FileDialog {
        visible: false
        id: saveFileDialog
        title: qsTr("Save wallet recovery file...")
        fileMode: FileDialog.SaveFile
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        nameFilters: [qsTr("Wallet recovery files (*.walletbackup)"), "All files (*.*)"]
        defaultSuffix: "walletbackup"
        onAccepted:
        {
            var path = saveFileDialog.file.toString();
            walletHashManager.saveFile(path)
        }
        onRejected:
        {
            dapTextBottomMessage.text = ""

            dapButtonAction.enabled = true
            dapButtonNext.enabled = false
        }
    }


    FileDialog {
        visible: false
        id: openFileDialog
        title: qsTr("Open wallet recovery file...")
        fileMode: FileDialog.OpenFile
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        nameFilters: [qsTr("Wallet recovery files (*.walletbackup)"), "All files (*.*)"]
        defaultSuffix: "walletbackup"
        onAccepted:
        {
            var path = openFileDialog.file.toString();
            walletHashManager.openFile(path)
        }
        onRejected:
        {
            dapTextBottomMessage.text = ""

            dapButtonAction.enabled = true
            dapButtonNext.enabled = false
        }
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
    }
}

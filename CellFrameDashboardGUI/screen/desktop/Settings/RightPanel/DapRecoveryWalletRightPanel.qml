import QtQuick 2.4
import Qt.labs.platform 1.0

DapRecoveryWalletRightPanelForm
{
    Connections
    {
        target: walletHashManager

        onSetHashString:
        {
            walletInfo.recovery_hash = hash
//            print("hash = ", walletInfo.recovery_hash)

            if (walletInfo.recovery_hash !== "" && logicMainApp.restoreWalletMode)
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
            dapButtonNext.visible = false
        }

        onFileError:
        {
            dapTextBottomMessage.color = "#FF0300"
            if (!logicMainApp.restoreWalletMode)
                dapTextBottomMessage.text =
                    qsTr("File saving error.")
            else
                dapTextBottomMessage.text =
                    qsTr("File loading error.")

            dapButtonAction.enabled = true
            dapButtonNext.enabled = false
            dapButtonNext.visible = false
        }

        onSetFileName:
        {
            if (!logicMainApp.restoreWalletMode)
                dapBackupFileName.text = qsTr("File saved to:\n") + fileName
            else
                dapBackupFileName.text = qsTr("File loaded from:\n") + fileName
        }
    }

    Component.onCompleted:
    {
//        print("DapRecoveryWalletRightPanelForm Component.onCompleted")
//        print("logicMainApp.restorelogicMainApp.WalletMode", logicMainApp.restoreWalletMode)

        dapButtonAction.enabled = true
        dapButtonNext.enabled = false
        dapButtonNext.visible = false
        walletInfo.recovery_hash = ""

        if (logicMainApp.walletRecoveryType === "Words")
        {
            dapTextMethod.text = qsTr("Recovery method: 24 words")

            if (!logicMainApp.restoreWalletMode)
                dapButtonAction.textButton = qsTr("Copy")
            else
                dapButtonAction.textButton = qsTr("Paste")

            dapWordsGrid.visible = true
            dapBackupFileName.visible = false
        }
        if (logicMainApp.walletRecoveryType === "File")
        {
            dapTextMethod.text = qsTr("Recovery method: Backup file")

            if (!logicMainApp.restoreWalletMode)
                dapButtonAction.textButton = qsTr("Save")
            else
                dapButtonAction.textButton = qsTr("Load")

            dapWordsGrid.visible = false
            dapBackupFileName.visible = true
        }


        if (logicMainApp.walletRecoveryType === "Words")
        {
            if (!logicMainApp.restoreWalletMode)
            {
                dapTextTopMessage.color = "#E4E111"
                dapTextTopMessage.text =
                    qsTr("Keep these words in a safe place. They will be required to restore your wallet in case of loss of access to it.")
                walletHashManager.generateNewWords(walletInfo.password)
            }
            else
            {
                dapTextTopMessage.color = "#6F9F00"
                dapTextTopMessage.text =
                    qsTr("Copy the previously saved words to the clipboard and click the 'Paste' button.")
                walletHashManager.clearWords()
            }
        }
        if (logicMainApp.walletRecoveryType === "File")
        {
            if (!logicMainApp.restoreWalletMode)
            {
                dapTextTopMessage.text =
                    qsTr("Click the 'Save' button and keep backup file in a safe place. They will be required to restore your wallet in case of loss of access to it.")
                dapTextTopMessage.color = "#59D2C2"
                walletHashManager.generateNewFile(walletInfo.password)
            }
            else
            {
                dapTextTopMessage.color = "#BEFF00"
                dapTextTopMessage.text =
                    qsTr("Click the 'Load' button and select the previously saved backup file.")
            }
        }
    }

    dapButtonNext.onClicked:
    {
        console.log("Create new wallet " + walletInfo.name);
        console.log(walletInfo.signature_type);
//        print("hash = ", walletInfo.recovery_hash)
        if(walletInfo.password === "")
            dapServiceController.requestToService("DapAddWalletCommand",
                   walletInfo.name,
                   walletInfo.signature_type,
                   walletInfo.recovery_hash)
        else
            dapServiceController.requestToService("DapAddWalletCommand",
                   walletInfo.name,
                   walletInfo.signature_type,
                   walletInfo.recovery_hash,
                   walletInfo.password)
    }

    dapButtonAction.onClicked:
    {
        dapButtonAction.enabled = true
        dapButtonNext.enabled = true
        dapButtonNext.visible = true

        if (logicMainApp.walletRecoveryType === "Words")
        {
            if (!logicMainApp.restoreWalletMode)
            {
                dapTextBottomMessage.color = "#B3FF00"
                dapTextBottomMessage.text =
                    qsTr("Recovery words copied to clipboard. Keep them in a safe place before proceeding to the next step.")

                walletHashManager.copyWordsToClipboard()
            }
            else
            {
                walletHashManager.pasteWordsFromClipboard(walletInfo.password)
            }

        }

        if (logicMainApp.walletRecoveryType === "File")
        {
            if (!logicMainApp.restoreWalletMode)
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
            dapButtonNext.visible = false
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
            walletHashManager.openFile(path, walletInfo.password)
        }
        onRejected:
        {
            dapTextBottomMessage.text = ""

            dapButtonAction.enabled = true
            dapButtonNext.enabled = false
            dapButtonNext.visible = false
        }
    }

    dapButtonClose.onClicked:
    {
        pop()
    }

    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
            commandResult.success = wallet.success
            commandResult.message = wallet.message

            navigator.doneWalletFunc()
        }
    }
}

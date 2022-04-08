import QtQuick 2.4
import Qt.labs.platform 1.0

DapRecoveryWalletRightPanelForm
{
//    dapNextRightPanel: doneWallet
//    dapPreviousRightPanel: ""

    Connections
    {
        target: walletHashManager

        onSetHashString:
        {
            walletInfo.recovery_hash = hash
            print("hash = ", walletInfo.recovery_hash)

            if (walletInfo.recovery_hash !== "" && globalLogic.restoreWalletMode)
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
            if (!globalLogic.restoreWalletMode)
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
            if (!globalLogic.restoreWalletMode)
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
            navigator.doneWalletFunc()
//            nextActivated("doneWallet");
        }
    }

    Component.onCompleted:
    {
//        if (globalLogic.currentTab === "Wallet")
//          dapPreviousRightPanel = createNewWallet
//        if (globalLogic.currentTab === settingsScreenPath)
//          dapPreviousRightPanel = inputNameWallet

        print("DapRecoveryWalletRightPanelForm Component.onCompleted")
        print("restoreWalletMode", globalLogic.restoreWalletMode)

        dapButtonAction.enabled = true
        dapButtonNext.enabled = false
        dapButtonNext.visible = false
        walletInfo.recovery_hash = ""

        if (globalLogic.walletRecoveryType === "Words")
        {
            dapTextMethod.text = qsTr("Recovery method: 24 words")

            if (!globalLogic.restoreWalletMode)
                dapButtonAction.textButton = qsTr("Copy")
            else
                dapButtonAction.textButton = qsTr("Paste")

            dapWordsGrid.visible = true
            dapBackupFileName.visible = false
        }
        if (globalLogic.walletRecoveryType === "File")
        {
            dapTextMethod.text = qsTr("Recovery method: Backup file")

            if (!globalLogic.restoreWalletMode)
                dapButtonAction.textButton = qsTr("Save")
            else
                dapButtonAction.textButton = qsTr("Load")

            dapWordsGrid.visible = false
            dapBackupFileName.visible = true
        }


        if (globalLogic.walletRecoveryType === "Words")
        {
            if (!globalLogic.restoreWalletMode)
            {
                dapTextTopMessage.color = "#FFFF00"
                dapTextTopMessage.text =
                    qsTr("Keep these words in a safe place. They will be required to restore your wallet in case of loss of access to it.")
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
        if (globalLogic.walletRecoveryType === "File")
        {
            if (!globalLogic.restoreWalletMode)
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
        dapButtonAction.enabled = true
        dapButtonNext.enabled = true
        dapButtonNext.visible = true

        if (globalLogic.walletRecoveryType === "Words")
        {
            if (!globalLogic.restoreWalletMode)
            {
                dapTextBottomMessage.color = "#B3FF00"
                dapTextBottomMessage.text =
                    qsTr("Recovery words copied to clipboard. Keep them in a safe place before proceeding to the next step.")

                walletHashManager.copyWordsToClipboard()
            }
            else
            {
                walletHashManager.pasteWordsFromClipboard()
            }

        }

        if (globalLogic.walletRecoveryType === "File")
        {
            if (!globalLogic.restoreWalletMode)
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
            walletHashManager.openFile(path)
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
//        if (globalLogic.currentTab === "Settings")
//        {
//            dapRightPanelFrame.visible = false
//            dapRightPanelFrame.width = 0
//            dapSettingsScreen.dapExtensionsBlock.visible = true
//        }
        pop()
    }
}

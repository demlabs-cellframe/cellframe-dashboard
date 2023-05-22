import QtQuick 2.4
import Qt.labs.platform 1.0

DapRecoveryWalletRightPanelForm
{

    Connections
    {
        target: walletHashManager

        function onSetHashString(hash)
        {
            walletInfo.recovery_hash = hash
//            print("hash = ", walletInfo.recovery_hash)
        }

        function onClipboardError()
        {
            dapButtonNext.enabled = false

            dapMainWindow.infoItem.showInfo(
                        220,60,
                        dapMainWindow.width*0.5,
                        8,
                        "The clipboard does not\ncontain 24 words",
                        "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")

        }

        function onFileError()
        {
            dapButtonNext.enabled = false

            var result
            if (!logicWallet.restoreWalletMode)
                result = qsTr("File saving error.")
            else
                result = qsTr("File loading error.")

            dapMainWindow.infoItem.showInfo(
                        185,0,
                        dapMainWindow.width*0.5,
                        8,
                        result,
                        "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")
        }

        function onSetFileName(fileName)
        {
            if (!logicWallet.restoreWalletMode)
                dapBackupFileName.text = qsTr("File saved\n") + fileName
            else
                dapBackupFileName.text = qsTr("File loaded\n") + fileName
        }
    }

    Component.onCompleted:
    {
        console.log("DapRecoveryWalletRightPanelForm Component.onCompleted")
        console.log("walletInfo.name", walletInfo.name)
//        print("logicMainApp.restorelogicMainApp.WalletMode", logicMainApp.restoreWalletMode)

        if(logicMainApp.restoreWalletMode)
        {
            acceptedLayout.visible = false
            dapButtonAction.enabled = true
        }

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

            dapWarningText1.text = qsTr("I'm aware that a wallet seed phrase can't be generated after wallet creation")
            dapWarningText2.text = qsTr("I'm aware that unless I save the seed phrase correctly I will lose access to my wallet after deleting it")
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

            dapWarningText1.text = qsTr("I'm aware that a wallet backup file can't be generated after wallet creation")
            dapWarningText2.text = qsTr("I'm aware that unless I have an undamaged backup file I will lose access to my wallet after deleting it")
        }


        if (logicMainApp.walletRecoveryType === "Words")
        {
            if (!logicMainApp.restoreWalletMode)
            {
                dapTextTopMessage.text =
                    qsTr("Keep these words in a safe place. They will be required to restore your wallet in case of loss of access to it.")
                walletHashManager.generateNewWords(walletInfo.password)
            }
            else
            {
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
                walletHashManager.generateNewFile(walletInfo.password)
            }
            else
            {
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
            logicMainApp.requestToService("DapAddWalletCommand",
                   walletInfo.name,
                   walletInfo.signature_type,
                   walletInfo.recovery_hash)
        else
            logicMainApp.requestToService("DapAddWalletCommand",
                   walletInfo.name,
                   walletInfo.signature_type,
                   walletInfo.recovery_hash,
                   walletInfo.password)
    }

    dapButtonAction.onClicked:
    {
        if (logicMainApp.walletRecoveryType === "Words")
        {
            if (!logicMainApp.restoreWalletMode)
            {
                dapButtonNext.enabled = true

                walletHashManager.copyWordsToClipboard()

                dapMainWindow.infoItem.showInfo(
                            0,0,
                            dapMainWindow.width*0.5,
                            8,
                            "Words copied",
                            "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
            }
            else
            {
                dapButtonNext.enabled = true

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
            dapButtonNext.enabled = true
            walletHashManager.saveFile(path)
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
            dapButtonNext.enabled = true
            walletHashManager.openFile(path, walletInfo.password)
        }
    }

    dapButtonClose.onClicked:
    {
        pop()
    }

    Connections
    {
        target: dapServiceController
        function onWalletCreated(wallet)
        {
            commandResult.success = wallet.success
            commandResult.message = wallet.message

            navigator.doneWalletFunc()
        }
    }
}

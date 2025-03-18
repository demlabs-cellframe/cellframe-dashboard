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
                        qsTr("The clipboard does not\ncontain 24 words"),
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
                dapBackupFileName.text = qsTr("File saved") + "\n" + fileName
            else
                dapBackupFileName.text = qsTr("File loaded") + "\n" + fileName
        }
    }

    Component.onCompleted:
    {
        console.log("DapRecoveryWalletRightPanelForm Component.onCompleted")
        console.log("walletInfo.name", walletInfo.name)
//        print("logicWallet.restorelogicMainApp.WalletMode", logicWallet.restoreWalletMode)

        if(logicWallet.restoreWalletMode)
        {
            acceptedLayout.visible = false
            dapButtonAction.enabled = true
        }

        walletInfo.recovery_hash = ""

        if (logicWallet.walletRecoveryType === "Words")
        {
            dapTextMethod.text = qsTr("Recovery method: 24 words")

            if (!logicWallet.restoreWalletMode)
                dapButtonAction.textButton = qsTr("Copy")
            else
                dapButtonAction.textButton = qsTr("Paste")

            dapWordsGrid.visible = true
            dapBackupFileName.visible = false

            dapWarningText1.text = qsTr("I'm aware that a wallet seed phrase can't be generated after wallet creation")
            dapWarningText2.text = qsTr("I'm aware that unless I save the seed phrase correctly I will lose access to my wallet after deleting it")
        }
        if (logicWallet.walletRecoveryType === "File")
        {
            dapTextMethod.text = qsTr("Recovery method: Backup file")

            if (!logicWallet.restoreWalletMode)
                dapButtonAction.textButton = qsTr("Save")
            else
                dapButtonAction.textButton = qsTr("Load")

            dapWordsGrid.visible = false
            dapBackupFileName.visible = true

            dapWarningText1.text = qsTr("I'm aware that a wallet backup file can't be generated after wallet creation")
            dapWarningText2.text = qsTr("I'm aware that unless I have an undamaged backup file I will lose access to my wallet after deleting it")
        }


        if (logicWallet.walletRecoveryType === "Words")
        {
            if (!logicWallet.restoreWalletMode)
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
        if (logicWallet.walletRecoveryType === "File")
        {
            if (!logicWallet.restoreWalletMode)
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
        var argsRequest
        if(walletInfo.password === "")
            argsRequest = [walletInfo.name,
                   walletInfo.signature_type,
                   walletInfo.recovery_hash]
        else
            argsRequest = [walletInfo.name,
                   walletInfo.signature_type,
                   walletInfo.recovery_hash,
                   walletInfo.password]

        walletModule.createWallet(argsRequest);
    }

    dapButtonAction.onClicked:
    {
        if (logicWallet.walletRecoveryType === "Words")
        {
            if (!logicWallet.restoreWalletMode)
            {
                dapButtonNext.enabled = true

                walletHashManager.copyWordsToClipboard()

                dapMainWindow.infoItem.showInfo(
                            0,0,
                            dapMainWindow.width*0.5,
                            8,
                            qsTr("Words copied"),
                            "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
            }
            else
            {
                dapButtonNext.enabled = true

                walletHashManager.pasteWordsFromClipboard(walletInfo.password)
            }
        }

        if (logicWallet.walletRecoveryType === "File")
        {
            if (!logicWallet.restoreWalletMode)
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
        nameFilters: [qsTr("Wallet recovery files (*.walletbackup)"), qsTr("All files (*.*)")]
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
        nameFilters: [qsTr("Wallet recovery files (*.walletbackup)"), qsTr("All files (*.*)")]
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
        txExplorerModule.statusProcessing = true
        pop()
    }

    Connections
    {
        target: walletModule
        function onSigWalletCreate(rcvData)
        {
            var jsonDocument = JSON.parse(rcvData)
            var wallet = jsonDocument.result
            console.log("wallet created request, ", wallet.message)
            commandResult.success = wallet.success
            commandResult.message = wallet.message

            navigator.doneWalletFunc()
        }
    }
}

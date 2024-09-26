import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.0
import "qrc:/widgets"
import "../../controls"


DapBottomScreen{
    property string words
    property string recovery_hash

    heightForm: 740
    header.text: logicMainApp.walletRecoveryType

    backButton.visible: true

    dataItem:
    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 16
        anchors.bottomMargin: 0
        spacing: 0

        Text
        {
            id: textTopMessage
            Layout.fillWidth: true
            Layout.topMargin: 26
            Layout.leftMargin: 33
            Layout.rightMargin: 33
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            color: currTheme.neon
            wrapMode: Text.WordWrap
            font: mainFont.dapFont.regular14
        }


        Text{
            id: wordsText
            Layout.topMargin: 32
            Layout.fillWidth: true
            Layout.leftMargin: 36
            Layout.rightMargin: 36
            horizontalAlignment: Text.AlignHCenter
            color: currTheme.white
            font: mainFont.dapFont.regular16
            wrapMode: Text.WordWrap
            text: words
        }

        Text
        {
            id: backupFileNameText
            visible: false
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            color: currTheme.gray
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            font: mainFont.dapFont.regular14
        }


        Text
        {
            id: textBottomMessage
            Layout.fillWidth: true
            Layout.minimumHeight: 48
            Layout.leftMargin: 32
            Layout.rightMargin: 32
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 30
            color: currTheme.lightGreen
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font: mainFont.dapFont.regular14
        }

        Item{ Layout.fillHeight: true}

        ColumnLayout
        {
            id: checkBoxBlock
            Layout.topMargin: 32
            Layout.fillWidth: true
            Layout.leftMargin: -16
            Layout.minimumHeight: 150
            Layout.maximumHeight: 150
            spacing: 0

            Rectangle{
                Layout.fillWidth: true
                height: 1
                color: currTheme.secondaryBackground
            }

            RowLayout
            {
                Layout.topMargin: 32
                Layout.fillWidth: true

                DapCheckBox
                {
                    id: checkBoxWarning1
                    Layout.minimumWidth: 46
                    Layout.minimumHeight: 46
                    width: 46
                    height: 46
                    indicatorInnerSize: width
                    onCheckedChanged:
                    {
                        actionButton.enabled =
                                checkBoxWarning1.checked &&
                                checkBoxWarning2.checked

                        if (!actionButton.enabled)
                            nextButton.enabled = false
                    }
                }

                Text
                {
                    id: textWarning1
                    Layout.fillWidth: true
                    Layout.bottomMargin: 5
                    text: logicMainApp.walletRecoveryType === qsTr("24 words") ?
                              qsTr("I'm aware that a wallet seed phrase can't be generated after wallet creation") :
                              qsTr("I'm aware that a wallet backup file can't be generated after wallet creation")
                    wrapMode: Text.WordWrap
                    color: currTheme.white
                    font: mainFont.dapFont.regular14
                    verticalAlignment: Text.AlignVCenter
                    MouseArea{
                        anchors.fill: parent
                        onClicked: checkBoxWarning1.checked = !checkBoxWarning1.checked
                    }
                }
            }

            RowLayout
            {
                Layout.fillWidth: true
                Layout.topMargin: 20

                DapCheckBox
                {
                    id: checkBoxWarning2
                    Layout.minimumWidth: 46
                    Layout.minimumHeight: 46
                    width: 46
                    height: 46
                    indicatorInnerSize: width
                    onCheckedChanged:
                    {
                        actionButton.enabled =
                                checkBoxWarning1.checked &&
                                checkBoxWarning2.checked

                        if (!actionButton.enabled)
                            nextButton.enabled = false
                    }
                }

                Text
                {
                    id: textWarning2
                    Layout.fillWidth: true
                    Layout.bottomMargin: 5
                    text: logicMainApp.walletRecoveryType === qsTr("24 words") ?
                              qsTr("I'm aware that unless I save the seed phrase correctly I will lose access to my wallet after deleting it") :
                              qsTr("I'm aware that unless I have an undamaged backup file I will lose access to my wallet after deleting it")
                    wrapMode: Text.WordWrap
                    color: currTheme.white
                    font: mainFont.dapFont.regular14
                    verticalAlignment: Text.AlignVCenter

                    MouseArea{
                        anchors.fill: parent
                        onClicked: checkBoxWarning2.checked = !checkBoxWarning2.checked
                    }
                }

            }
        }

        Item{
            height: 83
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 14
            Layout.bottomMargin: 48

            DapButton
            {
                id: actionButton
                implicitHeight: 36
                implicitWidth: 132
                Layout.alignment: Qt.AlignCenter
                checkable: true
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14

                onClicked: {
                    nextButton.enabled = true
                    nextButton.visible = true

                    if (logicMainApp.walletRecoveryType === qsTr("24 words"))
                    {
                        if (!logicMainApp.restoreWalletMode)
                        {
                            textBottomMessage.color = "#B3FF00"
                            textBottomMessage.text =
                                qsTr("Recovery words copied to clipboard. Keep them in a safe place before proceeding to the next step.")

                            walletHashManager.copyWordsToClipboard()
                        }
                        else
                        {
                            walletHashManager.pasteWordsFromClipboard(logicMainApp.walletPass)
                            words = getWords()
                        }
                    }
                    else
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
            }
            DapButton
            {
                id: nextButton
                implicitHeight: 36
                implicitWidth: 132
                Layout.alignment: Qt.AlignCenter
                textButton: logicMainApp.restoreWalletMode && logicMainApp.walletRecoveryType !== qsTr("24 words") ?
                                qsTr("Import wallet") : qsTr("Create wallet")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14
                enabled: false

                onClicked: {
                    var argsRequest = [logicMainApp.walletName,
                                       logicMainApp.walletSign,
                                       recovery_hash,
                                       logicMainApp.walletPass]
                    walletModule.createWallet(argsRequest);
                }
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
            textBottomMessage.text = ""
            actionButton.enabled = true
            nextButton.enabled = false
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
            walletHashManager.openFile(path, logicMainApp.walletPass)
        }
        onRejected:
        {
            textBottomMessage.text = ""
            actionButton.enabled = true
            nextButton.enabled = false
        }
    }

    Connections
    {
        target: dapServiceController
        function onWalletCreated(aResult)
        {
            var jsonDoc = JSON.parse(aResult)
            if(jsonDoc)
            {
                logicMainApp.commandResult = jsonDoc.result
                dapBottomPopup.push("qrc:/walletSkin/forms/Settings/BottomForms/DapCreateWalletDone.qml")
            }
            else {
                console.log("Create wallet error")
            }
        }
    }

    function getWords()
    {
        var words = "";
        for(var i = 0; i < wordsModel.length; i++)
        {
            words += wordsModel[i] + " "
        }
        return words
    }

    Connections
    {
        target: walletHashManager

        function onSetHashString(hash)
        {
            recovery_hash = hash
            if (recovery_hash !== "" && logicMainApp.restoreWalletMode)
            {
                textBottomMessage.text = ""
            }
        }

        function onClipboardError()
        {
            textBottomMessage.color = "#FF0300"
            textBottomMessage.text =
                qsTr("The clipboard does not contain 24 words.")

            actionButton.enabled = true
            nextButton.enabled = false
        }

        function onFileError()
        {
            textBottomMessage.color = "#FF0300"
            if (!logicMainApp.restoreWalletMode)
                textBottomMessage.text =
                    qsTr("File saving error.")
            else
                textBottomMessage.text =
                    qsTr("File loading error.")

            actionButton.enabled = true
            nextButton.enabled = false
        }

        function onSetFileName(fileName)
        {
            if (!logicMainApp.restoreWalletMode)
            {
                backupFileNameText.visible = true
                backupFileNameText.text = qsTr("File saved to:\n") + fileName
            }
            else
            {
                backupFileNameText.visible = true
                backupFileNameText.text = qsTr("File loaded from:\n") + fileName
            }
        }
    }

    Component.onCompleted: {

        actionButton.enabled = false
        nextButton.enabled = false
        recovery_hash = ""

        if(logicMainApp.walletRecoveryType === qsTr("24 words"))
        {
            if (!logicMainApp.restoreWalletMode)
            {
                actionButton.textButton = qsTr("Copy")
                textTopMessage.color = "#79FFFA"
                textTopMessage.text =
                    qsTr("Keep these words in a safe place. They will be required to restore your wallet in case of loss of access to it.")
                walletHashManager.generateNewWords(logicMainApp.walletPass)
                words = getWords()
            }
            else
            {
                actionButton.textButton = qsTr("Paste")
                textTopMessage.color = "#6F9F00"
                textTopMessage.text =
                    qsTr("Copy the previously saved words to the clipboard and click the 'Paste' button.")
                walletHashManager.clearWords()
            }

            wordsText.visible = true
            backupFileNameText.visible = false
        }
        else
        {
            if (!logicMainApp.restoreWalletMode)
            {
                actionButton.textButton = qsTr("Save")
                textTopMessage.text =
                    qsTr("Click the 'Save' button and keep backup file in a safe place. They will be required to restore your wallet in case of loss of access to it.")
                textTopMessage.color = "#59D2C2"
                walletHashManager.generateNewFile(logicMainApp.walletPass)
            }
            else
            {
                actionButton.textButton = qsTr("Load")
                textTopMessage.color = "#79FFFA"
                textTopMessage.text =
                    qsTr("Click the 'Load' button and select the previously saved backup file.")
            }
            wordsText.visible = false
//            backupFileName.visible = true
        }
    }
}

import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import "qrc:/widgets"
import "../../../"
import "../../controls"
import "../../Settings/NodeSettings"

Rectangle
{
    property bool isMasterNode: nodeMasterModule.isMasterNode

    id: root

    color: currTheme.mainBackground

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Text
        {
            Layout.fillWidth: true
            font: mainFont.dapFont.medium14
            color: currTheme.white
            text: qsTr("Actions")
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            Layout.topMargin: 4
            textButton: qsTr("Import an existing wallet")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            onClicked:
            {
                walletDialog.open()
            }
        }

        FileDialog
        {
            id: walletDialog
            folder: shortcuts.home
            nameFilters: ["Wallets (*.dwallet)"]
            onAccepted:
            {
                console.log("Wallet: ", fileUrl)
                nodeMasterModule.moveWallet(fileUrl)
            }
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            textButton: qsTr("Import certificate")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            onClicked:
            {
                certDialog.open()
            }
        }

        FileDialog
        {
            id: certDialog
            folder: shortcuts.home
            nameFilters: ["Certifiacates (*.dcert)"]
            onAccepted:
            {
                console.log("Certifiacate: ", fileUrl)
                nodeMasterModule.moveCertificate(fileUrl)
            }
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            textButton: qsTr("Add service")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            visible: false
            onClicked:
            {
            }
        }

        Text
        {
            Layout.fillWidth: true
            Layout.topMargin: 12
            font: mainFont.dapFont.medium14
            color: currTheme.white
            text: qsTr("Validator Actions")
            visible: isMasterNode
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            Layout.topMargin: 4
            textButton: qsTr("Last Actions")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            visible: isMasterNode
            onClicked:
            {
                dapRightPanel.push(lastActionsMasterNode)
            }
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            textButton: qsTr("Orders")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            visible: isMasterNode
            onClicked:
            {
                dapRightPanel.push(ordersMasterNodePanel)
            }
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            textButton: qsTr("Blocks")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            visible: false//isMasterNode
            onClicked:
            {
            }
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            textButton: qsTr("Config")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            visible: false//isMasterNode
            onClicked:
            {
            }
        }

        Item { Layout.fillHeight: true }

    }

    Component.onCompleted:
    {

    }

    Component.onDestruction:
    {

    }
}




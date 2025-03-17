import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 1.4

import "qrc:/"
import "../../"
import "../controls"
import "RightPanel"
import "MenuBlocks"

DapPage
{
    ///@detalis Path to the right panel of node settings.
    readonly property string nodeSettingsPanel: path + "/Settings/NodeSettings/NodeBlock.qml"
    ///@detalis Path to the right panel of requests.
    readonly property string requestsPanel: path + "/Settings/RightPanel/DapRequestsRightPanel.qml"

    id: settingsTab
//    property int dapIndexCurrentWallet: -1
    property alias dapSettingsScreen: settingsScreen

    Timer{id:timer}

    QtObject {
        id: navigator

        function openNodeSettings() {
            dapRightPanelFrame.frame.visible = true
            dapRightPanel.push(nodeSettingsPanel)
        }

        function openRequests() {
            dapRightPanelFrame.frame.visible = true
            dapRightPanel.push(requestsPanel)
        }

        function popPage() {
            dapRightPanel.clear()
            dapRightPanel.push(dapExtensionsBlock)
            dapRightPanelFrame.frame.visible = false
        }

        function openWalletsController() {
            walletsControllerPopup.show(removeWalletPopup)
        }
    }

    dapHeader.initialItem: DapSettingsTopPanel { id:topPanel }

    dapScreen.initialItem: DapSettingsScreen {
        id: settingsScreen

        onNodeSettingsSignal:
        {
            dapRightPanel.pop()
            navigator.openNodeSettings()
        }

        onSwitchMenuTab:
        {
            for (var i = 0; i < modelMenuTab.count; ++i)
                if (modelMenuTab.get(i).tag === tag)
                {
                    modelMenuTab.setProperty(i, "showTab", state)
                    break
                }
            menuTabChanged()
        }

        onSwitchAppsTab:
        {
            for (var i = 0; i < modelMenuTab.count; ++i)
                if (modelMenuTab.get(i).tag === tag && modelMenuTab.get(i).name === name)
                {
                    modelMenuTab.setProperty(i, "showTab", state)
                    break
                }

            menuTabChanged()
        }
    }

    dapRightPanel.initialItem: DapExtensionsBlock{id:dapExtensionsBlock}
    dapRightPanelFrame.visible: true
    dapRightPanelFrame.frame.visible: false

    DapMessagePopup
    {
        id: clearMessagePopup
        dapButtonCancel.visible: true
        onSignalAccept: if(accept)settingsModule.clearNodeData()
    }

    Connections
    {
        target: settingsModule

        function onSigVersionInfo(versionResult)
        {
            var jsonDocument = JSON.parse(versionResult)

            if(settingsModule.guiRequest)
            {
                if(jsonDocument.message === "Service not found")
                {
                    messagePopupVersion.smartOpenVersion(qsTr("Wallet update"), "", "", qsTr("Service not found"))
                }
                else if(!jsonDocument.hasUpdate && jsonDocument.message === "Reply version")
                    logicMainApp.rcvReplyVersion()
                else if(jsonDocument.message !== "" && jsonDocument.hasUpdate)
                {
                    messagePopupVersion.smartOpenVersion(qsTr("Wallet update"), settingsModule.dashboardVersion, jsonDocument.lastVersion, "")
                }
            }
        }
        function onSigNodeDataRemoved()
        {
            dapMainWindow.infoItem.showInfo(
                        200,0,
                        dapMainWindow.width*0.5,
                        8,
                        qsTr("Node data cleared"),
                        "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
        }
    }
}

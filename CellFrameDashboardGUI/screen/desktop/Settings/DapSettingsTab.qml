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
    property bool sendRequest: false

    Timer{id:timer}

    property var walletInfo:
    {
        "name": "",
        "network": "",
        "chain": "",
        "signature_type": "",
        "recovery_hash": "",
        "password": ""
    }
    property var commandResult:
    {
        "success": "",
        "message": ""
    }

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
    }

    dapHeader.initialItem: DapSettingsTopPanel { id:topPanel }

    dapScreen.initialItem: DapSettingsScreen {
        id: settingsScreen

        onCreateWalletSignal:
        {
            dapRightPanel.pop()
            logicMainApp.restoreWalletMode = restoreMode
            navigator.createWallet()
        }

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

    onSendRequestChanged: if(sendRequest) timeout.start()

    Timer{
        id: timeout
        interval: 10000; running: false; repeat: false;
        onTriggered: {
            messagePopupVersion.smartOpen("Dashboard update", qsTr("Service not found"))
            sendRequest = false
        }
    }

    Timer {
        id: updateSettingsTimer
        interval: logicMainApp.autoUpdateInterval; running: false; repeat: true
        onTriggered:
        {
            if(!logicMainApp.stateNotify || logicMainApp.nodeVersion === "")
                logicMainApp.requestToService("DapVersionController", "version node")

        }
    }

    Component.onCompleted:
    {
        logicMainApp.requestToService("DapVersionController", "version node")
        updateSettingsTimer.start()
    }

    Component.onDestruction:
        updateSettingsTimer.stop()


    Connections
    {
        target: dapServiceController

        function onVersionControllerResult(versionResult)
        {
            if(sendRequest)
            {
//                sendRequest = false
                timeout.stop()
                if(!versionResult.hasUpdate && versionResult.message === "Reply version")
                    logicMainApp.rcvReplyVersion()
                else if(versionResult.message !== "" && versionResult.hasUpdate)
                {
                    messagePopupVersion.smartOpen("Dashboard update", qsTr("Current version - " + dapServiceController.Version +"\n"+
                                                                           "Last version - " + versionResult.lastVersion +"\n" +
                                                                           "Go to website to download?"))
                }
            }
        }
    }
    Connections
    {
        target: messagePopupVersion
        function onClick() {sendRequest = false}
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "../../controls"
import "qrc:/widgets"

ColumnLayout
{
    id: mainPage

    property bool edited: false

    signal updateAll()

    signal reset(var node_flag, var network_name)

    anchors.fill: parent

    ListModel
    {
        id: networkModel
    }

    Component.onCompleted:
    {
//        logicMainApp.requestToService("DapNodeRestart");
        console.log("NodeBlock.onCompleted")

        configWorker.resetAllChanges()

//        console.log("subzero", "node-role",
//                    configWorker.readConfigValue("subzero", "node-role"))

//        console.log("subzero", "getNetworkStatus",
//                    configWorker.getNetworkStatus("subzero"))
//        console.log("mileena", "getNetworkStatus",
//                    configWorker.getNetworkStatus("mileena"))

//        configWorker.setNetworkStatus("subzero", false)

//        configWorker.setNetworkStatus("mileena", true)

//        configWorker.saveAllChanges()

        var netList = configWorker.getNetworkList()

        for(var i = 0; i < netList.length; ++i)
            networkModel.append(
                        { name : capitalizeFirstLetter(netList[i]),
                          network : netList[i] })

        console.log("netList", netList,
                    "netList.length", netList.length)

        networkListView.forceLayout()

//        mainPage.updateAll()
    }

    ComboBoxPopupItem
    {
        id: comboBoxPopup
        visible: false

        onConfirm:
        {
            mainPage.updateAll()
        }
    }

    TextEditPopupItem
    {
        id: textEditPopup
        visible: false

        onConfirm:
        {
            mainPage.updateAll()
        }
    }

    WarningPopupItem
    {
        id: warningPopup
        visible: false

        onSave:
        {
            console.log("warningPopup", "onSave")
            edited = false

            configWorker.saveAllChanges()
            logicMainApp.requestToService("DapNodeRestart");
        }
        onReset:
        {
            console.log("warningPopup", "onReset")
            edited = false

            configWorker.resetAllChanges()

            mainPage.updateAll()
        }
        onClosed:
        {
            console.log("warningPopup", "onClosed")
            edited = true
        }
    }

    Flickable
    {
        id: flickElement
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentWidth: parent.width
        contentHeight: mainLayout.height
        interactive: true
        clip: true

        ColumnLayout
        {
            id: mainLayout
            width: parent.width - 32
            x: 16
//            anchors.leftMargin: 16
//            anchors.rightMargin: 16

            spacing: 0

            HeaderItem
            {
                headerName: qsTr("Node config")
            }

            SettingsCheckBoxItem
            {
                mainTextMessage: qsTr("Auto online")
                secondTextMessage: qsTr("Bring up links automatically and go to the online network state")
                checked: true
                node: true
                groupName: "general"
                valueName: "auto_online"
                defaultValue: true
            }

            SettingsCheckBoxItem
            {
                mainTextMessage: qsTr("Debug mode or logs")
                checked: true
                node: true
                groupName: "general"
                valueName: "debug_mode"
                defaultValue: false
            }

            SettingsCheckBoxItem
            {
                mainTextMessage: qsTr("Accept connections")
                checked: true
                node: true
                groupName: "server"
                valueName: "enabled"
                defaultValue: false
            }

            SettingsArrowItem
            {
                mainTextMessage: qsTr("Server address to listen on")

                node: true
                groupName: "server"
                valueName: "listen_address"
                defaultValue: "0.0.0.0"

                onClicked:
                {
                    textEditPopup.parameterName = qsTr("Server address")
                    textEditPopup.parameterValue = secondTextMessage
                    textEditPopup.node = node
                    textEditPopup.groupName = groupName
                    textEditPopup.valueName = valueName

                    dapBottomPopup.show(textEditPopup)
                }
            }

            SettingsArrowItem
            {
                mainTextMessage: qsTr("Server port to listen on")

                node: true
                groupName: "server"
                valueName: "listen_port_tcp"
                defaultValue: "8079"

                onClicked:
                {
                    textEditPopup.parameterName = qsTr("Server port")
                    textEditPopup.parameterValue = secondTextMessage
                    textEditPopup.node = node
                    textEditPopup.groupName = groupName
                    textEditPopup.valueName = valueName

                    dapBottomPopup.show(textEditPopup)
                }
            }

            SettingsArrowItem
            {
                mainTextMessage: qsTr("Notify server address to listen on")

                node: true
                groupName: "notify_server"
                valueName: "listen_address"
                defaultValue: "127.0.0.1"

                onClicked:
                {
                    textEditPopup.parameterName = qsTr("Notify server address")
                    textEditPopup.parameterValue = secondTextMessage
                    textEditPopup.node = node
                    textEditPopup.groupName = groupName
                    textEditPopup.valueName = valueName

                    dapBottomPopup.show(textEditPopup)
                }
            }

            SettingsArrowItem
            {
                mainTextMessage: qsTr("Notify server port to listen on")

                node: true
                groupName: "notify_server"
                valueName: "listen_port"
                defaultValue: "8080"

                onClicked:
                {
                    textEditPopup.parameterName = qsTr("Notify server port")
                    textEditPopup.parameterValue = secondTextMessage
                    textEditPopup.node = node
                    textEditPopup.groupName = groupName
                    textEditPopup.valueName = valueName

                    dapBottomPopup.show(textEditPopup)
                }
            }

            SettingsCheckBoxItem
            {
                mainTextMessage: qsTr("Python plugins")
                secondTextMessage: qsTr("Enable Python plugins")
                checked: true
                node: true
                groupName: "plugins"
                valueName: "py_load"
                defaultValue: false
            }

            ResetUpdateButtons
            {
                Layout.topMargin: 10

                resetVisible: edited
                updateVisible: updateAvailable && edited

                Component.onCompleted:
                {
                    updateAvailable = configWorker.checkUpdate(true, "")

                    console.log("ResetUpdateButtons", "checkUpdate",
                                updateAvailable)
                }

                onResetClicked:
                {
                    mainPage.reset(true, "")
                    mainPage.updateAll()
                }

                onUpdateClicked:
                {
                    configWorker.updateFile(true, "")

                    updateAvailable = false
                    mainPage.updateAll()
                }
            }

            ListView
            {
                id: networkListView

                interactive: false
                clip: true

                Layout.fillWidth: true
                Layout.minimumHeight: contentHeight
//                height: networkModel.count * 200

                model: networkModel

                delegate: networkDelegate
            }

            Item
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

    }

    ColumnLayout
    {
        Layout.fillWidth: true
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.topMargin: 12
        Layout.bottomMargin: 12

        height: 108

        DapButton
        {
            Layout.fillWidth: true

            Layout.minimumHeight: 36
            Layout.maximumHeight: 36
            hoverEnabled: true

            textButton: edited ? qsTr("Save node settings") :
                                 qsTr("Edit node settings")

            implicitHeight: 36
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked:
            {
                if (edited)
                {
                    dapBottomPopup.show(warningPopup)
                }
                else
                {
                    edited = true
                }
            }
        }

    }

    Component
    {
        id: networkDelegate

        ColumnLayout
        {
            width: networkListView.width
//            height: 200

            spacing: 0

            HeaderItem
            {
                Layout.topMargin: 30
                headerName: name + qsTr(" network")
            }

            SettingsCheckBoxItem
            {
                id: networkStatusItem
                mainTextMessage: name + qsTr(": Enable network")
                secondTextMessage: qsTr("Enable network auto load on start")
                checked: true
                node: false
                networkStatus: true
                networkName: network
                defaultValue: true
            }

            SettingsArrowItem
            {
                id: networkNodeRoleItem
                mainTextMessage: name + qsTr(" node role")
//                secondTextMessage: "Archive"

                node: false
                networkName: network
                groupName: "general"
                valueName: "node-role"
                defaultValue: "full"

                onClicked:
                {
                    comboBoxPopup.networkFullName = name
                    comboBoxPopup.networkName = network
                    comboBoxPopup.networkRole = secondTextMessage
                    comboBoxPopup.node = node
                    comboBoxPopup.groupName = groupName
                    comboBoxPopup.valueName = valueName

                    dapBottomPopup.show(comboBoxPopup)
                }
            }

            ResetUpdateButtons
            {
                Layout.topMargin: 10

                resetVisible: edited
                updateVisible: updateAvailable && edited

                Component.onCompleted:
                {
                    updateAvailable = configWorker.checkUpdate(false, network)

                    console.log("ResetUpdateButtons", "checkUpdate", network,
                                updateAvailable)
                }

                onResetClicked:
                {
                    mainPage.reset(false, network)
                    mainPage.updateAll()
                }

                onUpdateClicked:
                {
                    configWorker.updateFile(false, network)

                    updateAvailable = false
                    mainPage.updateAll()
                }
            }

        }
    }

    function capitalizeFirstLetter(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }
}

import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import "../../controls"
import "qrc:/widgets"

import "qrc:/screen"

ColumnLayout
{
    id:control
    anchors.fill: parent

    spacing: 0

    ListModel{
        id: langModel
        ListElement{name:"English"}
        ListElement{name:"Chinese"}
        ListElement{name:"Czech"}
        ListElement{name:"Dutch"}
        ListElement{name:"Portuguese"}
    }
    ListModel{
        id: themeModel
        ListElement{name:"Dark Theme"}
        ListElement{name:"White Theme"}
    }

    ListModel{
        id: selectModeModel
        ListElement{name:"Local"}
        ListElement{name:"Remote"}
    }

    Item
    {
        Layout.fillWidth: true
        height: 42

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.bold14
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("General settings")
        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        height: 30
        color: currTheme.mainBackground

        visible: false

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Language")
        }
    }

    Item {
        height: 60
        Layout.fillWidth: true

        visible: false

        DapCustomComboBox
        {
            id: comboBoxCurrentLanguage

            model: langModel

            anchors.centerIn: parent
            anchors.fill: parent
            anchors.margins: 10
            anchors.bottomMargin: 0
            anchors.topMargin: 5
            anchors.leftMargin: 10
            backgroundColorShow: currTheme.secondaryBackground

            font: mainFont.dapFont.regular16

            defaultText: qsTr("Language")

        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        Layout.topMargin: 8
//        Layout.bottomMargin: 1
        height: 30
        color: currTheme.mainBackground

        visible: false

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Theme")
        }
    }
    ButtonGroup
    {
        id: buttonGroup
    }


    ListView{
        id: themeView
        visible: false
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: contentHeight
        clip: true

        model: themeModel

        delegate:
        Item {
            width: themeView.width
            height: 50
            onHeightChanged: themeView.contentHeight = height

            RowLayout
            {
                anchors.fill: parent

                Text
                {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.leftMargin: 24

                    font: mainFont.dapFont.regular16
                    color: currTheme.white
                    verticalAlignment: Qt.AlignVCenter
                    text: name
                }

                DapRadioButton
                {
                    id: radioBut

                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.preferredHeight: 46
                    Layout.preferredWidth: 46
                    Layout.rightMargin: 11

                    ButtonGroup.group: buttonGroup

                    indicatorInnerSize: 46
                    implicitHeight: indicatorInnerSize
                    nameRadioButton: ""

                    checked: name === "Dark Theme"
                }
            }
            Rectangle
            {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: currTheme.mainBackground
            }

            MouseArea{
                anchors.fill: parent
                onClicked: radioBut.checked = true
            }
        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        height: 30
        color: currTheme.mainBackground

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Node connect mode")
        }
    }

    //--------------custom switch---------------------//
    Rectangle{
        property int selectedItem: app.getNodeMode()

        id: customModeSwitch
        Layout.fillWidth: true
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.bottomMargin: 16
        Layout.topMargin: 12
        height: 32

        border.color: currTheme.input
        color: currTheme.mainBackground
        radius: height * 0.5

        Rectangle
        {
            id: firstItem
            x: 4
            anchors.verticalCenter: parent.verticalCenter
            z: 1
            color: parent.selectedItem ? "transparent"
                                       : currTheme.mainButtonColorNormal1
            radius: height * 0.5
            width: parent.width / 2
            height: parent.height - 8

            Text
            {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: firstItem.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: currTheme.white
                font: mainFont.dapFont.medium14
                text: qsTr("Local")
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    customModeSwitch.selectedItem = 0
                    customModeSwitch.clickSwitchMode()
                }
            }
        }

        Rectangle
        {
            id: secondItem
            x: 4 + firstItem.width
            anchors.verticalCenter: parent.verticalCenter
            z: 1
            color: !parent.selectedItem ? "transparent"
                                        : currTheme.mainButtonColorNormal0
            radius: height * 0.5
            width: parent.width / 2 - 8
            height: parent.height - 8

            Text
            {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: secondItem.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: currTheme.white
                font: mainFont.dapFont.medium14
                text: qsTr("Remote")
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    customModeSwitch.selectedItem = 1
                    customModeSwitch.clickSwitchMode()
                }
            }
        }

        function clickSwitchMode()
        {
            if(app.getNodeMode() !== customModeSwitch.selectedItem)
            {
                app.setNodeMode(customModeSwitch.selectedItem)
                Qt.exit(RESTART_CODE)
            }
        }
    }
    //--------------custom switch---------------------//

    Rectangle
    {
        visible: app.getNodeMode()
        Layout.fillWidth: true
        height: 30
        color: currTheme.mainBackground

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("RPC node address")
        }
    }

    Item
    {
        visible: app.getNodeMode()
        height: 70
        Layout.fillWidth: true

        DapTextField
        {
            id: inputRpcAddress
            anchors.fill: parent
            anchors.margins: 16
            placeholderText: "http://..."
            text: app.getRPCAddress()
            font: mainFont.dapFont.regular14
            horizontalAlignment: Text.AlignLeft
            borderWidth: 1
            borderRadius: 4
            selectByMouse: true

            DapContextMenu{}
        }
    }

    RowLayout
    {
        Layout.fillWidth: true
        Layout.margins: 16
        Layout.topMargin: 0
        height: 40
        visible: app.getNodeMode()
        spacing: 16

        DapButton
        {
            id: setAddress

            focus: false

            Layout.fillWidth: true

            Layout.minimumHeight: 26
            Layout.maximumHeight: 26

//            Layout.leftMargin: 16
//            Layout.rightMargin: 16
//            Layout.topMargin: 10
//            Layout.bottomMargin: 20
            enabled: app.getRPCAddress() !== inputRpcAddress.text

            textButton: qsTr("Set")

            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked:
            {
                app.setRPCAddress(inputRpcAddress.text)
                resetAddress.enabled = app.getRPCAddress() !== "rpc.cellframe.net"
                enabled = app.getRPCAddress() !== inputRpcAddress.text

                dapMainWindow.infoItem.showInfo(
                                            235, 0,
                                            dapMainWindow.width * 0.5,
                                            8,
                                            qsTr("Address setting successful"),
                                            "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")

//                Qt.exit(RESTART_CODE)
            }
        }

        DapButton
        {
            id: resetAddress

            focus: false

            Layout.fillWidth: true

            Layout.minimumHeight: 26
            Layout.maximumHeight: 26

            enabled: app.getRPCAddress() !== "rpc.cellframe.net"

            textButton: qsTr("Reset")

            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked: {
                app.resetRPCAddress()
                inputRpcAddress.text = app.getRPCAddress()
                resetAddress.enabled = app.getRPCAddress() !== "rpc.cellframe.net"

                dapMainWindow.infoItem.showInfo(
                                            230, 0,
                                            dapMainWindow.width * 0.5,
                                            8,
                                            qsTr("Address reset successful"),
                                            "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")

//                Qt.exit(RESTART_CODE)
            }
        }
    }

    Rectangle
    {
        visible: !app.getNodeMode()
        Layout.fillWidth: true
        height: 30
        color: currTheme.mainBackground

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Node service")
        }
    }

    Item
    {
        visible: !app.getNodeMode()
        height: 60
        Layout.fillWidth: true
        RowLayout
        {
            anchors.fill: parent
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 16
            anchors.rightMargin: 16

            Text
            {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true

                font: mainFont.dapFont.regular14
                color: currTheme.white
                verticalAlignment: Qt.AlignVCenter
                 text: qsTr("Node service enable")
            }
            DapSwitch
            {
                id: switchTab
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.preferredHeight: 26
                Layout.preferredWidth: 46

                indicatorSize: 30

                backgroundColor: currTheme.mainBackground
                borderColor: currTheme.reflectionLight
                shadowColor: currTheme.shadowColor

                checked: cellframeNodeWrapper.nodeServiceLoaded

                function toggle() {
                    if(cellframeNodeWrapper.nodeServiceLoaded)
                        cellframeNodeWrapper.disableNodeService()
                    else
                        cellframeNodeWrapper.enableNodeService()
                }

                Connections
                {
                    target: cellframeNodeWrapper
                    function onSignalServiceLoadedChange()
                    {
                        if(switchTab.checked !== cellframeNodeWrapper.nodeServiceLoaded)
                        {
                            switchTab.checked = cellframeNodeWrapper.nodeServiceLoaded

                            if (switchTab.state == "on" && !switchTab.checked)
                            {
                                switchTab.state = "off";
                            }
                            else if(switchTab.state == "off" && switchTab.checked)
                            {
                                switchTab.state = "on";
                            }
                        }
                    }
                }
            }
        }
    }

    DapButton
    {
        id: startStopNode

        focus: false

        Layout.fillWidth: true

        Layout.minimumHeight: 26
        Layout.maximumHeight: 26

        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.topMargin: 10
        Layout.bottomMargin: 20

        visible: !app.getNodeMode() ? switchTab.checked && (CURRENT_OS !== "macos") : false

        textButton:
        {
            if(app.getNodeMode() === 0)
                return cellframeNodeWrapper.nodeRunning ? qsTr("Stop Node") : qsTr("Start Node")
            return ""
        }

        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter

        onClicked: {
            if(cellframeNodeWrapper.nodeRunning)
                cellframeNodeWrapper.stopNode()
            else
                cellframeNodeWrapper.startNode()
        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        height: 30
        color: currTheme.mainBackground
        visible: false

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Skin")
        }
    }

    Settings
    {
        id: skinSettings
        property string project_skin: ""

        Component.onCompleted:
        {
            if(project_skin == "wallet")
            {
                skinSwitcher.setSelected("second")
            }
            else
            {
                skinSwitcher.setSelected("first")
            }
        }
    }

    DapSelectorSwitch
    {
        visible: false

        id: skinSwitcher
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.topMargin: 10
        Layout.bottomMargin: 20
        height: 35
        firstName: qsTr("Dashboard")
        secondName: qsTr("Wallet")
        firstColor: currTheme.green
        secondColor: currTheme.red
        itemHorisontalBorder: 16

        onToggled:
        {
            var walletSkin = secondSelected
            if (walletSkin)
            {
                skinSettings.setValue("project_skin", "wallet")
                Qt.exit(RESTART_CODE)
            }
            else
            {
                skinSettings.setValue("project_skin", "dashboard")
                Qt.exit(RESTART_CODE)
            }
        }
    }

    Connections
    {
        target: settingsModule

        function onResultNodeRequest(messaage)
        {
            dapMainWindow.infoItem.showInfo(
                        200,0,
                        dapMainWindow.width*0.5,
                        8,
                        messaage,
                        "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
        }

        function errorNodeRequest(messaage)
        {
            dapMainWindow.infoItem.showInfo(
                        200,0,
                        dapMainWindow.width*0.5,
                        8,
                        messaage,
                        "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")
        }
    }


}

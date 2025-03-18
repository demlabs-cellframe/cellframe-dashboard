import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{
    property string mainTextMessage: ""
    property string secondTextMessage: ""

    property bool node: true
    property bool networkStatus: false
    property string networkName: ""
    property string groupName: ""
    property string valueName: ""

    property bool defaultValue: true

    property bool editable: mainPage.edited

    property alias checked: checkBox.checked

    height: 80
    Layout.fillWidth: true

    Component.onCompleted:
    {
        updateAll()
    }

    Connections{
        target: mainPage
        function onUpdateAll()
        {
            updateAll()
        }

        function onReset(node_flag, network_name)
        {
            if (node_flag === node && network_name === networkName)
            {
                console.log("SettingsCheckBoxItem onReset", node_flag, network_name)
                console.log(node, networkName, groupName, valueName)

                writeValue(defaultValue)
            }
        }
    }

    ColumnLayout
    {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: checkBox.visible ? checkBox.left : textState.left
        anchors.bottom: separator.top
        anchors.leftMargin: 16
        anchors.rightMargin: 10

        spacing: 0

        Item
        {
            Layout.fillHeight: true
        }

        Text
        {
            id: mainText
            Layout.fillWidth: true
            Layout.bottomMargin: 5

            text: mainTextMessage
            color: currTheme.white
            font: mainFont.dapFont.regular14

            verticalAlignment: Text.AlignVCenter
        }

        Text
        {
            id: secondText
            visible: secondTextMessage != ""

            Layout.fillWidth: true
            Layout.margins: 0

            text: secondTextMessage
            color: currTheme.gray
            font: mainFont.dapFont.regular12

            wrapMode: Text.WordWrap

            verticalAlignment: Text.AlignVCenter
        }

        Item
        {
            Layout.fillHeight: true
        }
    }

    DapCheckBox
    {
        id: checkBox

        visible: editable

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
//        anchors.rightMargin: 16
        width: 46
        height: 46

        indicatorInnerSize: width

        onClicked:
        {
            writeValue(checked)
        }
    }

    Text
    {
        id: textState

        visible: !editable

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 16

        text: checked ? qsTr("Enabled") : qsTr("Disabled")
        color: currTheme.white
        font: mainFont.dapFont.regular14

        verticalAlignment: Text.AlignVCenter
    }

    Rectangle
    {
        id: separator
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1

        color: currTheme.mainBackground
    }

    function updateAll()
    {
        console.log("onUpdateAll",
                    node,
                    groupName, valueName,
                    networkStatus, networkName)

        if (node)
            checkBox.checked =
                    configWorker.readNodeValue(
                        groupName, valueName) === "true"
        else
        {
            if (networkStatus)
                checkBox.checked =
                        configWorker.getNetworkStatus(networkName)
            else
                checkBox.checked =
                        configWorker.readConfigValue(networkName,
                            groupName, valueName) === "true"
        }
    }

    function writeValue(flag)
    {
        var value = "false"

        if (flag)
            value = "true"

        if (node)
        {
            configWorker.writeNodeValue(
                groupName, valueName, value)

            if (valueName === "py_load")
                configWorker.writeNodePyhonPath()
        }
        else
        {
            if (networkStatus)
                configWorker.setNetworkStatus(networkName,
                    flag)
            else
                configWorker.writeConfigValue(networkName,
                    groupName, valueName, value)
        }
    }

}

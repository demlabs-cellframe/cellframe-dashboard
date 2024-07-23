import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
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
            text: qsTr("Node")
        }
    }

    Item
    {
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

                checked: nodeConfigToolController.statusServiceNode

                function toggle() {
                    if(nodeConfigToolController.statusServiceNode)
                        nodeConfigToolController.swithServiceEnabled(false)
                    else
                        nodeConfigToolController.swithServiceEnabled(true)
                }

                Connections
                {
                    target: nodeConfigToolController
                    function onStatusServiceNodeChanged()
                    {
                        if(switchTab.checked !== nodeConfigToolController.statusServiceNode)
                        {
                            switchTab.checked = nodeConfigToolController.statusServiceNode

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

        visible: switchTab.checked

        textButton: nodeConfigToolController.statusProcessNode ? qsTr("Stop Node") : qsTr("Start Node")

        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter

        onClicked: {
            if(nodeConfigToolController.statusProcessNode)
                nodeConfigToolController.stopNode()
            else
                nodeConfigToolController.startNode()
        }

//        Connections
//        {
//            target: nodeConfigToolController
//            function onStatusProcessNodeChanged()
//            {
//                startStopNode.textButton = nodeConfigToolController.statusProcessNode ? qsTr("Stop Node") : qsTr("Start Node")
//            }
//        }
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

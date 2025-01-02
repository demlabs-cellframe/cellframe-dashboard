import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{
    id: mainItem

    property string mainTextMessage: ""
    property alias secondTextMessage: secondText.text

    property bool node: true
    property string networkName: ""
    property string groupName: ""
    property string valueName: ""

    property string defaultValue: ""

    property bool editable: mainPage.edited

    signal clicked()

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
                console.log("SettingsArrowItem onReset", node_flag, network_name)
                console.log(node, networkName, groupName, valueName)

                if (node)
                    configWorker.writeNodeValue(
                        groupName, valueName, defaultValue)
                else
                    configWorker.writeConfigValue(networkName,
                        groupName, valueName, defaultValue)
            }
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            if (editable)
                mainItem.clicked()
        }
    }

    ColumnLayout
    {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: arrowItem.left
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

//            text: secondTextMessage
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

    Image {
        id: arrowItem

        visible: editable

        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/Resources/" + pathTheme + "/icons/other/icon_rightChevron.svg"

        sourceSize: Qt.size( img.sourceSize.width, img.sourceSize.height )
    //    mipmap: true
    //    smooth: false

        Image {
            id: img
            source: parent.source
            width: 0
            height: 0
        }
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
        if (node)
            secondTextMessage =
                    configWorker.readNodeValue(
                        groupName, valueName)
        else
            secondTextMessage =
                    configWorker.readConfigValue(networkName,
                        groupName, valueName)
    }
}

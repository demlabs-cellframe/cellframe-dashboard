import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../controls"

Page
{
    title: qsTr("Settings")
    background: Rectangle {color: currTheme.mainBackground }
    hoverEnabled: true

    property string currentBlock:qsTr("General")

    ListModel{
        id: blockTabs
        ListElement{
            name: qsTr("General")
            url: "qrc:/walletSkin/forms/Settings/MenuBlocks/GeneralBlock.qml"
        }
//        ListElement{
//            name: "dApps"
//            url: "qrc:/walletSkin/forms/Settings/MenuBlocks/ExtensionsBlock.qml"
//        }
        ListElement{
            name: qsTr("Requests")
            url: "qrc:/walletSkin/forms/Settings/MenuBlocks/RequestsBlock.qml"
        }
        ListElement{
            name: qsTr("Node")
            url: "qrc:/walletSkin/forms/Settings/NodeSettings/NodeBlock.qml"
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.topMargin: 20

        spacing: 30

        ListView {

            clip: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            orientation: ListView.Horizontal
            Layout.fillWidth: true
            height: 31
            interactive: true

            model: blockTabs
            currentIndex: logicMainApp.currentNetwork

            spacing: 48

            delegate:
            ColumnLayout
            {
                spacing: 0

                Label {
                    Layout.minimumHeight: 15
                    Layout.maximumHeight: 15
                    elide: Text.ElideMiddle
                    text: name
                    font: mainFont.dapFont.medium13
                    horizontalAlignment: Text.AlignHCenter
                    color: name === currentBlock ? currTheme.lime : currTheme.white

                    Rectangle{

                        x: parent.width + 4
                        height: 16
                        width: value.implicitWidth > 8 ? value.implicitWidth + 12  : 16
                        radius: 16
                        visible: logicMainApp.requestsMessageCounter > 0 && name === "Requests"

                        color: currTheme.lime

                        Text{
                            id: value
                            anchors.fill: parent
                            text: logicMainApp.requestsMessageCounter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: currTheme.mainBackground
                            font: mainFont.dapFont.regular11
                        }
                    }
                }

                Rectangle
                {
                    Layout.topMargin: 11
                    Layout.alignment: Qt.AlignCenter
                    Layout.minimumHeight: 3
                    Layout.maximumHeight: 3
                    width: 20
                    radius: 2
                    color: name === currentBlock ? currTheme.lime : currTheme.white
                }

                MouseArea
                {
                    id: area
                    width: parent.width
                    height: parent.height

                    onClicked:
                    {
                        currentBlock = name
                        blockStack.setInitialItem(url)
                    }
                }

                Connections
                {
                    target: dapMainWindow
                    function onOpenRequests(){
                        if(name === "Requests")
                        {
                            currentBlock = name
                            blockStack.setInitialItem(url)
                        }
                    }
                }
            }
        }

        StackView {
            property string currPage: blockTabs.get(0).url
            id: blockStack
            Layout.fillHeight: true
            Layout.fillWidth: true

            initialItem: blockTabs.get(0).url

            function clearAll()
            {
                blockStack.clear()
                blockStack.push(initialItem)
            }

            function setInitialItem(item)
            {
                blockStack.initialItem = item
                blockStack.clearAll()
                currPage = item
            }
        }
    }
}

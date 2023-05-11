import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../../controls"

ColumnLayout {
    anchors.fill: parent

    spacing: 0

    ListModel{id: nodeListModel}

    function updateModel(){
        var obj = JSON.parse(diagnostic.nodeList)

        nodeListModel.clear()
        nodeListModel.append(obj)

    }

    Component.onCompleted: updateModel()

    Connections{
        target: diagnostic
        function onNodeListChanged(){
            updateModel()
        }
    }

    RowLayout{
        id: header
        Layout.leftMargin: 16
        Layout.fillWidth: true
        Layout.preferredHeight: 42
        spacing: 0

        Text{
            font: mainFont.dapFont.bold14
            color: currTheme.white
            text: qsTr("All nodes ")
            verticalAlignment: Text.AlignVCenter
        }
        Text{
            font: mainFont.dapFont.bold14
            color: currTheme.gray
            text: "("+nodeListModel.count+")"
            verticalAlignment: Text.AlignVCenter
        }
        Item{Layout.fillWidth: true}
    }

    RowLayout{
        id: rowLay
        Layout.fillWidth: true
        spacing: 10
        Layout.preferredHeight: 40
        Layout.leftMargin: 16
        Layout.rightMargin: 16

        // Frame icon search
        Image
        {
            id: frameIconSearch

            mipmap: true

            source: "qrc:/Resources/"+ pathTheme +"/icons/other/search.svg"
        }

        SearchInputBox{
            Layout.fillWidth: true
            height: 30

            bottomLineVisible: false

            backgroundColor: "transparent"
            placeholderColor: currTheme.gray
            font: mainFont.dapFont.regular14

            placeholderText: qsTr("Search node by mac address")


            onEditingFinished: {
                filtering.clear()
//                root.findHandler(text)
            }

            filtering.waitInputInterval: 100
            filtering.minimumSymbol: 0
            filtering.onAwaitingFinished: {
//                root.findHandler(text)
            }

        }
    }

    Rectangle {
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.fillWidth: true
//        Layout.topMargin: -2
        height: 1
        color: currTheme.gray //currTheme.borderColor
    }

    ListView{
        id: view
        Layout.topMargin: 20
        Layout.fillHeight: true
        Layout.fillWidth: true
        clip: true
        model: nodeListModel

        delegate:Item{
            width: view.width
            height: 50

            Rectangle{
                anchors.fill: parent
                color: area.containsMouse? currTheme.rowHover:"transparent"
            }

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true

                MouseArea{
                    id: childArea
                    width: rectImg.width
                    height: rectImg.height
                    x: rectImg.x
                    y: rectImg.y
                    hoverEnabled: true
                    onClicked: diagnostic.addNodeToList(mac)

                }
            }

            Rectangle{
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: currTheme.mainBackground
            }

            Text{
                anchors.fill: parent
                anchors.leftMargin: 16
                font: mainFont.dapFont.regular14
                color: currTheme.white
                text: mac
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }

            Rectangle{
                id: rectImg
                visible: area.containsMouse
                width: 32
                height: 32
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                color: childArea.containsMouse ? currTheme.lime
                                               : currTheme.mainBackground
                radius: 4

                Image{
                    source: childArea.containsMouse ? "qrc:/Resources/"+ pathTheme +"/icons/other/icon_arrow_hover.svg"
                                                    : "qrc:/Resources/"+ pathTheme +"/icons/other/icon_arrow.svg"
                    mipmap: true
                    anchors.centerIn: parent
                }
            }
        }
    }
}

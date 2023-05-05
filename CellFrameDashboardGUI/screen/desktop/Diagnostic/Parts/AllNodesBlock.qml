import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../../controls"

ColumnLayout {

    property string filtr:""
    anchors.fill: parent

    spacing: 0

    ListModel{id: nodeListModel}

    function updateModel(data){
        var obj;

        if(data)
            obj = JSON.parse(data)
        else
            obj = JSON.parse(diagnostic.nodeList)

        nodeListModel.clear()
        nodeListModel.append(obj)
    }

    Component.onCompleted: updateModel()

    Connections{
        target: diagnostic
        function onNodeListChanged(){
            updateModel()
            if(filtr != "")
                diagnostic.searchAllNodes(filtr)
        }
        function onFiltrAllNodesDone(data){
            updateModel(data)
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
            color: currTheme.textColor
            text: qsTr("All nodes ")
            verticalAlignment: Text.AlignVCenter
        }
        Text{
            font: mainFont.dapFont.bold14
            color: currTheme.textColorGray
            text: "("+(diagnostic? diagnostic.allNodesCount : 0)+")"
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
            placeholderColor: currTheme.textColorGrayTwo
            font: mainFont.dapFont.regular14

            placeholderText: qsTr("Search node by mac address")


            onEditingFinished: {
                filtering.clear()
                diagnostic.searchAllNodes(text)
                filtr = text
//                root.findHandler(text)
            }

            filtering.waitInputInterval: 100
            filtering.minimumSymbol: 0
            filtering.onAwaitingFinished: {
                diagnostic.searchAllNodes(text)
                filtr = text
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
        color: "#757184" //currTheme.borderColor
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
                color: area.containsMouse? "#474B53":"transparent"
            }

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true
            }

            Rectangle{
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: currTheme.backgroundMainScreen
            }

            Text{
                anchors.fill: parent
                anchors.leftMargin: 16
                font: mainFont.dapFont.regular14
                color: currTheme.textColor
                text: mac
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }

            Rectangle{
                visible: area.containsMouse
                width: 32
                height: 32
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                color: currTheme.backgroundMainScreen
                radius: 4

                Image{
                    source: "qrc:/Resources/"+ pathTheme +"/icons/other/icon_arrow.svg"
                    mipmap: true
                    anchors.centerIn: parent
                    MouseArea{
                        anchors.fill: parent
                        onClicked: diagnostic.addNodeToList(mac)
                    }
                }
            }
        }
    }
}

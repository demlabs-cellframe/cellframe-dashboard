import QtQuick 2.8
import QtQuick.Controls 1.4
import QtQuick.Window 2.1


ApplicationWindow {
    id:tableWindow
    visible: true
    width: 600
    height: 400
    title: qsTr("ChainTable")

    Component{
        id: default_head_property
        Rectangle{
            height: 20
            border.color: "#aeaeae"
            color: "#e6e6e6"
            border.width: 1
            Text {
                text: styleData.value
                width: parent.width
                height: parent.height
                font.pointSize: 18
                minimumPointSize: 3
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    Loader{
        id: pageLoader
    }
    Component
    {
        id: columnComponent
        TableViewColumn{}
    }
    property int row: 0

    TableView{
        id: chainTable
        anchors.fill: parent
        model:TableModel
        // anchors.fill: parent
        // anchors.margins: 20
        selectionMode: SelectionMode.NoSelection

        resources:
        {
            var roleList = TableModel.getPropertyRole
            var titleList = TableModel.getPropertyTitle
            var widthList = TableModel.getPropertyWidth
            var temp = []
            for(var i=0; i<roleList.length; i++)
            {
                var role  = roleList[i]
                temp.push(columnComponent.createObject(chainTable, {"role": role, "title": titleList[i],"width":widthList[i]}))
            }
            return temp
        }

        headerDelegate:Loader{
            id:headerLoad
            source: "HeadTableDefault.qml"
        }

        property int activeCellRow:      0
        property int activeCellColumn:   1
        property int tmpCellRow:         0
        property int tmpCellColumn:      1

        itemDelegate: Loader{
            id:itemLoad
            source: "ItemTableDefault.qml"
        }
    }
    Button {
        id: button
        x: parent.width - 140
        y: parent.height - 50
        width: 97
        height: 25
        text: "Setting"
        onClicked: {
            pageLoader.source = "SettingWidget.qml"
        }
    }

    signal send()
    onSend: console.log("Send clicked")

    Button {
        id: button1
        x: 277
        y: 350
        text: qsTr("Delete")
        onClicked: {
            //  TableModel.insertColumns(3,3)
        }
    }
}

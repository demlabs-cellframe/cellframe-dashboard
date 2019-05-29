import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import KelvinDashboard 1.0

Page {
    id: dapUiQmlWidgetChainNodeLogs
    title: "Logs"
    
    ListModel
    {
        id: nodeModel

        ListElement
        {
            name: "Node 1"
        }

//        ListElement
//        {
//            name: "Node 2"
//        }

//        ListElement
//        {
//            name: "Node 3"
//        }
    }

        TabView
        {
            id: tabViewLogs
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            Repeater {
                anchors.fill: parent
            model: nodeModel
            delegate:
                Tab{
                
                
                
                title: qsTr(name)
                
                    TableView {
                        id: tableViewLogs
//                        anchors.top: parent.top
//                        anchors.bottom: parent.bottom
//                        anchors.left: parent.left
//                        anchors.right: parent.right
                        model: dapLogModel
                clip: true
                
                        TableViewColumn {
                            id: columnType
                            role: "type"
                            title: "Type"
                            
                             delegate:
                                 Item{
                                 Text {
                                     anchors.centerIn: parent
                                     renderType: Text.NativeRendering
                                     text: styleData.value
                                 }
//                                     Image {
//                                         anchors.centerIn: parent
//                                         source: styleData.value
//                                         width: 14
//                                         height: 14
//                                     }
                             }
                        }
                        TableViewColumn {
                            id: columnTime
                            role: "timestamp"
                            title: "Timestamp"
                            delegate: Item {
                                        Text {
                                            anchors.centerIn: parent
                                            renderType: Text.NativeRendering
                                            text: styleData.value
                                        }
                                    }
                        }
                        TableViewColumn {
                            id: columnFile
                            role: "file"
                            title: "File"
                            delegate: Item {
                                        Text {
                                            anchors.centerIn: parent
                                            renderType: Text.NativeRendering
                                            text: styleData.value
                                        }
                                    }
                        }
                        TableViewColumn {
                            id: columnMessage
                            role: "message"
                            title: "Message"
                            delegate: Item {
                                        Text {
                                            renderType: Text.NativeRendering
                                            text: styleData.value
                                        }
                                    }
                        }


                        headerDelegate: Rectangle {
                            height: 20
                            color: "orange"
                        
                            Text {
                                text: styleData.value
                                color: "#FFF"
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
            }
        }
   
//        TabView
//        {
//            id: tabViewLogs
//            anchors.top: parent.top
//            anchors.bottom: parent.bottom
//            anchors.left: parent.left
//            anchors.right: parent.right
//            Repeater {
//                anchors.fill: parent
//            model: dapUiQmlWidgetModel
//            delegate:
//                Tab{
                
                
                
//                title: qsTr(name)
                
//                    TableView {
//                        id: tableViewLogs
//                        model: dataModel
//                clip: true
                
//                        TableViewColumn {
//                            id: columnType
//                            role: "type"
//                            title: "Type"
//                             delegate:
//                                 Item
//                                 {
//                                     height: parent.height
//                                     width: parent.height
//                                     Rectangle {
//                                         anchors.fill: parent
//                                         color: "transparent"
//                                             Image {
//                                                 id: names
//                                                 height: parent.height
//                                                 width: parent.height
////                                                 source: model.type
//                                                 anchors.centerIn: parent
//                                             }
//                                     }
//                                 }
//                        }
//                        TableViewColumn {
//                            id: columnDate
//                            role: "name"
//                            title: "Date"
//                        }
//                        TableViewColumn {
//                            id: columnTime
//                            role: "cost"
//                            title: "Time"
//                        }
//                        TableViewColumn {
//                            id: columnFile
//                            role: "file"
//                            title: "File"
//                        }
//                        TableViewColumn {
//                            id: columnMessage
//                            role: "Message"
//                            title: "Message"
//                        }
//                        itemDelegate: Item {
//                                    Text {
//                                        anchors.centerIn: parent
//                                        renderType: Text.NativeRendering
//                                        text: styleData.value
//                                    }
//                                }
//                        headerDelegate: Rectangle {
//                            height: 20
//                            color: "#29333f"
                            
//                            Text {
//                                text: styleData.value
//                                color: "#FFF"
//                                width: parent.width
//                                height: parent.height
//                                font.pointSize: 24
//                                minimumPointSize: 3
//                                font.family: "Roboto"
//                                fontSizeMode: Text.Fit
//                                horizontalAlignment: Text.AlignHCenter
//                                verticalAlignment: Text.AlignVCenter
//                            }
//                        }

//                    }
//            }
//            }
//        }
    }
}

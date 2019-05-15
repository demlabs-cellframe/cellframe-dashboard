import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import KelvinDashboard 1.0

Page {
    id: dapUiQmlWidgetChainNodeLogs
    title: "Logs"
    
    
    ListModel {
            id: dataModel
    
            ListElement {
                    name: "Apple"
                    cost: 2.45
//                    type: ":/Resources/Icons/dialogquestion.png"
                }
                ListElement {
                    name: "Orange"
                    cost: 3.25
//                    type: ":/Resources/Icons/dialogwarning.png"
                }
                ListElement {
                    name: "Banana"
                    cost: 1.95
//                    type: ":/Resources/Icons/dialoinformation.png"
                }
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
            model: dapUiQmlWidgetModel
            delegate:
                Tab{
                
                
                
                title: qsTr(name)
                
                    TableView {
                        id: tableViewLogs
                        model: dataModel
                clip: true
                
                        TableViewColumn {
                            id: columnType
                            role: "type"
                            title: "Type"
                             delegate:
                                 Item
                                 {
                                     height: parent.height
                                     width: parent.height
                                     Rectangle {
                                         anchors.fill: parent
                                         color: "transparent"
                                             Image {
                                                 id: names
                                                 height: parent.height
                                                 width: parent.height
//                                                 source: model.type
                                                 anchors.centerIn: parent
                                             }
                                     }
                                 }
                        }
                        TableViewColumn {
                            id: columnDate
                            role: "name"
                            title: "Date"
                        }
                        TableViewColumn {
                            id: columnTime
                            role: "cost"
                            title: "Time"
                        }
                        TableViewColumn {
                            id: columnFile
                            role: "file"
                            title: "File"
                        }
                        TableViewColumn {
                            id: columnMessage
                            role: "Message"
                            title: "Message"
                        }
                        itemDelegate: Item {
                                    Text {
                                        anchors.centerIn: parent
                                        renderType: Text.NativeRendering
                                        text: styleData.value
                                    }
                                }
                        headerDelegate: Rectangle {
                            height: 20
                            color: "#29333f"
                            
                            Text {
                                text: styleData.value
                                color: "#FFF"
                                width: parent.width
                                height: parent.height
                                font.pointSize: 24
                                minimumPointSize: 3
                                font.family: "Roboto"
                                fontSizeMode: Text.Fit
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                    }
            }
        }
    }
}

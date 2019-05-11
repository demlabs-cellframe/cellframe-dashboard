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
                }
                ListElement {
                    name: "Orange"
                    cost: 3.25
                }
                ListElement {
                    name: "Banana"
                    cost: 1.95
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
//                        anchors.top: parent.top
//                        anchors.bottom: parent.bottom
//                        anchors.left: parent.left
//                        anchors.right: parent.right
                        model: dataModel
                clip: true
                
                        TableViewColumn {
                            id: columnType
                            role: "type"
                            title: "Type"
                            
                             delegate:
                                         Image {
                                             id: names
                                             source: "qrc:/Resources/Icons/icon.png"
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
                            color: "red"
                        
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
    }
    

    
                
    
}

import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import KelvinDashboard 1.0

Page {
    id: dapUiQmlWidgetChainNodeLogs
    title: "Logs"
    
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
                        model: dapLogModel
                clip: true
                
                        TableViewColumn {
                            id: columnType
//                            role: "type"
                            title: "Type"
                            
                             delegate:
                                 Item{
                                         Image {
                                             id: names
                                             anchors.centerIn: parent
                                             source: "qrc:/Resources/Icons/dialog.png"
                                             width: 14
                                             height: 14
                                         }
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

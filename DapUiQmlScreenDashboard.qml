import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

Page {
    id: dapUiQmlScreenDashboard
    title: qsTr("General")
        ListView {
            id: listViewTabs
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: dapUiQmlScreenDashboard.width/5
            model: listModelTabs
            
            ListModel {
                id: listModelTabs
                
                ListElement {
                    name:  qsTr("Login")
                    page: "DapUiQmlScreenLogin.ui.qml"
                }
                ListElement {
                    name:  qsTr("Dashboard")
                    page: "DapUiQmlScreenDialog.qml"
                }
            }
            
            
            
            delegate: 
                Component {
                    id: componentTab
                    Item {
                        width: listViewTabs.width 
                        height: textTab.height + 10
                        Rectangle {
                            id: canvas
                            border.color: "whitesmoke"
                            color: "Transparent"
                            anchors.fill: parent
                            Row {
                                anchors.margins: 5
                                anchors.fill: parent
                                
                                Text 
                                { 
                                    id: textTab
                                    text: qsTr(name)
                                }
                            }
                        }
                        
                        MouseArea {
                               anchors.fill: parent
                               onClicked: 
                               {
                                   listViewTabs.currentIndex = index
                                   stackViewScreenDashboard.setSource(Qt.resolvedUrl(page))
                               }
                           }
                        }
                    }
            
            highlight: Rectangle { color: "aliceblue"; radius: 1 }
            focus: true
        }
        Rectangle {    
            anchors.left: listViewTabs.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            border.color: "whitesmoke"
            Loader {
                id: stackViewScreenDashboard
                anchors.fill: parent
                anchors.margins: 1
                source: "DapUiQmlScreenLogin.ui.qml"
            }
        }
}

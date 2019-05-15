import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

Page {
    id: dapUiQmlScreenDashboard
    title: qsTr("General")
    Rectangle {
        id: rectangleTabs
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 70
        color: "#353841"
        ListView {
            id: listViewTabs
            anchors.fill: parent
            model: listModelTabs

            ListModel {
                id: listModelTabs
                
                ListElement {
                    name:  qsTr("Home")
                    page: "DapUiQmlScreenDialog.qml"
                    source: "qrc:/Resources/Icons/home.png"
                }
                ListElement {
                    name:  qsTr("Settings")
                    page: "DapQmlScreenAbout.qml"
                    source: "qrc:/Resources/Icons/settings.png"
                }
                ListElement {
                    name:  qsTr("About")
                    page: "DapQmlScreenAbout.qml"
                    source: "qrc:/Resources/Icons/about.png"
                }
            }
            
            
            
            delegate: 
                Component {
                    id: componentTab
                    Item {
                        id: componentItem
                        width: listViewTabs.width 
                        height: 64
                        Column
                        {
                            anchors.centerIn: parent
                            Image 
                            { 
                                id: imageMenu
                                source: model.source
                                height: 36
                                width: 36
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text
                            {
                                text: qsTr(name)
                                color: "#BBBEBF"
                                anchors.horizontalCenter: parent.horizontalCenter
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
            
//            highlight: Rectangle { color: "aliceblue"; radius: 1 }
            highlight: 
                Component 
                {
                    Rectangle {
                        id: rectangleMenu
                        color: "#121B28"
                        Rectangle 
                        { 
                            height: rectangleMenu.height
                            width: 4
                            color: "#EE5321"
                        }
                    }
                }
            focus: true
        }
    }
        Rectangle {    
            anchors.left: rectangleTabs.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            border.color: "whitesmoke"
            Loader {
                id: stackViewScreenDashboard
                anchors.fill: parent
                anchors.margins: 1
                source: "DapUiQmlScreenDialog.qml"
            }
        }
}

import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.3
import QtQuick.Controls.Styles 1.4
import Qt.labs.platform 1.0
import KelvinDashboard 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480

    onClosing: {
        console.log("Close")
        window.hide()
    }
    
    Connections {
        target: dapServiceController
        
        onActivateWindow: {
            if(window.visibility === Window.Hidden) {
                window.show()
                window.raise()
                window.requestActivate()
            } else {
                window.hide()
            }
        }
        
//        onErrorConnect: {
//            imageNetwork.visible = false
//            if(imageErrorNetwork.visible)
//                imageErrorNetwork.visible = false
//            else
//                imageErrorNetwork.visible = true
//        }
        
//        onConnectedToService: {
//            imageNetwork.visible = true
//            imageErrorNetwork.visible = false
//            console.log("Connected")
//        }
    }
    
    
    header:
    Column
    {
        ToolBar
        {
            width: parent.width
            height: buttomMenu.implicitHeight
            contentItem: Item {
                anchors.fill: parent
                Rectangle
                {
                    anchors.fill: parent
                    color: "#353841"
                }

            }

            ToolButton {
                id: buttomMenu

                contentItem: Item {
                    anchors.fill: parent
                    Rectangle
                    {
                        anchors.fill: parent
                        color: "#353841"

                        Text {
                            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
                            font.pixelSize: Qt.application.font.pixelSize * 2
                            anchors.centerIn: parent
                            color: "#A5A7AA"
                        }
                    }

                }

                onClicked: {
                    if (stackView.depth > 1) {
                        stackView.pop()
                    } else {
                        drawerMenu.open()
                    }
                }
            }

            Label {
                id: labelTitleWidget
                text: stackView.currentItem.title
                anchors.centerIn: parent
                color: "white"
            }

            Image {
                id: imageNetwork
                source: "qrc:/Resources/Icons/iconNetwork.png"
                scale: 0.7
                visible: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.left
            }

            Image {
                id: imageErrorNetwork
                source: "qrc:/Resources/Icons/iconErrorNetwork.png"
                scale: 0.7
                visible: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }
        }
        Rectangle
        {
            height: 1
            width: parent.width
            color: "green"
        }
    }
    
    Drawer {
        id: drawerMenu
        width: window.width * 0.25
        height: window.height
        
        ListView {
            id: listViewMenu
            anchors.fill: parent
            model: dapUiQmlWidgetModel

            delegate: 
                Component {
                    id: listViewItemMenu
                    Item {
                        id: itemMenu
                        
                        width: listViewMenu.width 
                        height: textItemMenu.height + 10
                        
                        Row {
                            anchors.margins: 5
                            anchors.fill: parent
                            
                            Text 
                            { 
                                id: textItemMenu
                                text: qsTr(name)
                            }
                        }
                        
                        MouseArea {
                               anchors.fill: parent
                               onClicked: 
                               {
                                   listViewMenu.currentIndex = index
                                   stackView.push(Qt.resolvedUrl(URLpage), StackView.Immediate)
                                   drawerMenu.close()
                               }
                           }
                        }
                    }
            
            highlight: Rectangle { color: "aliceblue"; radius: 5 }
            focus: true
        }
    }

    StackView {
        id: stackView
        initialItem: "DapUiQmlScreenDashboard.qml"
        anchors.fill: parent
    }
}

import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.4
import Qt.labs.platform 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    
    onClosing: {
        window.hide()
    }
    
    Connections {
        target: dapClient
        
        onActivateWindow: {
            if(window.visibility === Window.Hidden) {
                window.show()
                window.raise()
                window.requestActivate()
            } else {
                window.hide()
            }
        }
        
        onErrorConnect: {
            imageNetwork.visible = false
            if(imageErrorNetwork.visible)
                imageErrorNetwork.visible = false
            else
                imageErrorNetwork.visible = true
        }
        
        onConnectedToService: {
            imageNetwork.visible = true
            imageErrorNetwork.visible = false
            console.log("Connected")
        }
    }
    
    
    header: ToolBar {
        contentHeight: buttomMenu.implicitHeight
        spacing: 20
        ToolButton {
            id: buttomMenu
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
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
        }
        
        Image {
            id: imageNetwork
            source: "qrc:/Resources/Icons/iconNetwork.png"
            scale: 0.7
            visible: false
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: labelBalance.left
        }
        
        Image {
            id: imageErrorNetwork
            source: "qrc:/Resources/Icons/iconErrorNetwork.png"
            scale: 0.7
            visible: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: labelBalance.left
        }
        
        Text {
            id: labelBalance
            text: "$0"
            font.pointSize: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
        }
    }
    
    Drawer {
        id: drawerMenu
        width: window.width * 0.25
        height: window.height
        
        ListView {
            id: listViewMenu
            anchors.fill: parent
            model: listModelMenu
            
            DapUiQmlListModelWidgets {
                id: listModelMenu
            }

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
                                   stackView.push(Qt.resolvedUrl(page), StackView.Immediate)
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

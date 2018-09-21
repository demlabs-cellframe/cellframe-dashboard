import QtQuick 2.9
import QtQuick.Controls 2.4

Page {
    id: dapUiQmlScreenDialog
    title: qsTr("Dashboard")
    anchors.fill: parent
    
    Rectangle {
        color: "white"
        anchors.fill: parent
        
        GridView {
            id: gridViewDashboard
            anchors.fill: parent
            cellWidth: width/3; cellHeight: height/2
            focus: true
            model: DapUiQmlListModelWidgets {}
    
            highlight: Rectangle { width: gridViewDashboard.cellWidth; height: gridViewDashboard.cellHeight; radius: width/50; color: "aliceblue" }
    
            delegate: Item {
                width: gridViewDashboard.cellWidth
                height: gridViewDashboard.cellHeight
    Rectangle {
        anchors.fill: parent
        border.color: "grey"
        color: "transparent"
        radius: width/50
        anchors.margins: 5
        clip: true
        
        Column {
            width: parent.width
            anchors.centerIn: parent
            spacing: width / 10
            anchors.margins: width / 10
                Image {
                    id: iconWidget
                    source: "qrc:/Resources/Icons/add.png"
                    width: parent.width * 2/3
                    height: width
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: name
                    color: "darkgrey"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
        }
    }
                MouseArea {
                    anchors.fill: parent
                    onClicked: 
                    {
                        parent.GridView.view.currentIndex = index;
                        stackView.push(Qt.resolvedUrl(page), StackView.Immediate);
                    }
                }
            }
        }
    }
}

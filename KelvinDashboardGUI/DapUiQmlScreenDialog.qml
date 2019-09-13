import QtQuick 2.9
import QtQuick.Controls 2.2
import KelvinDashboard 1.0

Page {
    id: dapUiQmlScreenDialog
    title: qsTr("Dashboard")
    anchors.fill: parent
    
    DapUiQmlScreenChangeWidget {
            id: listViewDapWidgets
        }
    
    DapScreenDialog {
                    id: widgetModel
                }
    
    Rectangle {

        anchors.fill: parent
        
        GridView {
            id: gridViewDashboard
            
            signal pressAndHold(int index) 
            
            anchors.fill: parent
            cellWidth: width/3; cellHeight: height/2
            focus: true
            model: widgetModel.ProxyModel
    
            highlight: Rectangle { width: gridViewDashboard.cellWidth; height: gridViewDashboard.cellHeight; radius: width/50; color: "aliceblue" }
    
            delegate: DapUiQmlWidgetDelegateForm {
                width: gridViewDashboard.cellWidth
                height: gridViewDashboard.cellHeight
    
                MouseArea {
                    anchors.fill: parent
                    onClicked: 
                    {
                        parent.GridView.view.currentIndex = index;
                        stackView.push(Qt.resolvedUrl(URLpage), StackView.Immediate);
                    }
                }
            }
        }
    }
    
    RoundButton {
           text: qsTr("+")
           highlighted: true
           anchors.margins: 10
           anchors.right: parent.right
           anchors.bottom: parent.bottom
           onClicked: {
                       listViewDapWidgets.addWidget()
                   }
       }

    DapUiQmlWidgetLastActions {}
}

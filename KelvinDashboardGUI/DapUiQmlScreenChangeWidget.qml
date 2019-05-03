import QtQuick 2.9
import QtQml 2.11
import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtQml.Models 2.2 
import KelvinDashboard 1.0

Dialog {
    id: dialogChangeWidget
    
    function addWidget() {
            dialogChangeWidget.open();
        }
    
    width: parent.width/1.5
    height: parent.width/1.5 
    
    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2
        
    focus: true
    modal: true
    title: qsTr("Change widget...")
    
    contentItem: 
        
        Rectangle {
        id: b
        width: dialogChangeWidget.width
        height: dialogChangeWidget.height
        border.color: "gray"
        clip: true
        
        DapScreenDialogChangeWidget {
        id: widgetModel
    }
        
//            DelegateModel {
//                id: delegateModel
                
//                model: widgetModel.ProxyModel
                
//                groups: [
//                            DelegateModelGroup { 
//                        id: group
//                        name: "selected" 
//                    }
//                        ]
                
//                delegate: 
//        Rectangle {
//                    id: item
//                    height: text.height+10
//                    width: listViewDapWidgets.width
//                    RowLayout {
//                        anchors.fill: parent
                        
//                        Text {
//                            id: text
//                            text: name
//                            Layout.alignment: Qt.AlignVCenter
//                            Layout.leftMargin: 10
//                        }
//                    }
//                    MouseArea {
//                        anchors.fill: parent
//                        onClicked: 
//                        {
//                            item.DelegateModel.inSelected = !item.DelegateModel.inSelected
                            
//                            if (item.DelegateModel.inSelected)
//                            {
//                                item.color = "aliceblue"
//                            }
//                            else
//                            {
//                                item.color = "transparent"
//                            }
//                        }
//                    }
//                }
//            }
        
//        ListView {
            
//            id: listViewDapWidgets
            
//            anchors.fill: parent
            
//            anchors.margins: 1
            
//            model: delegateModel
            
//            ScrollBar.vertical: ScrollBar { }
//        }
        ListView {
            
            id: listViewDapWidgets
            
            anchors.fill: parent
            
            anchors.margins: 1
            
            model: dapUiQmlWidgetModel
            
            clip: true
            
            delegate:         
                Rectangle {
                id: itemWidget
                height: checkBoxWidget.height+10
                width: listViewDapWidgets.width
                Row {
                    anchors.fill: parent
                        
                        CheckBox {
                            id: checkBoxWidget
                            checkable: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 10
                        }

                        Text 
                        { 
                            id: textWidget
                            text: qsTr(name)
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    MouseArea {
                           anchors.fill: parent
                           onClicked: 
                           {
                               listViewDapWidgets.currentIndex = index
                               var item = DapUiQmlWidgetModel.get(index)
                               dapUiQmlWidgetModel.set(index, dapUiQmlWidgetModel.get(index).name, dapUiQmlWidgetModel.get(index).URLpage, dapUiQmlWidgetModel.get(index).image, !item.visible)
                               console.log("I: " +index + " : " + dapUiQmlWidgetModel.get(index) + " value = " + !item.visible)
                               
                               if(checkBoxWidget.checked)
                               {
                                    checkBoxWidget.checkState = Qt.Unchecked
                               }
                               else
                               {
                                   checkBoxWidget.checkState = Qt.Checked
                               }
                           }
                       }
                }
                
            ScrollBar.vertical: ScrollBar { }
            
            highlight: Rectangle { color: "aliceblue"; radius: 5 }
            
            focus: true
        }
    }
}

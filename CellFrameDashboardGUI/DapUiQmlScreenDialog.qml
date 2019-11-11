import QtQuick 2.9
import QtQuick.Controls 2.2
import CellFrameDashboard 1.0
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Page {
    id: dapUiQmlScreenDialog
    title: qsTr("Dashboard")
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 20 * pt
        anchors.leftMargin: 24 * pt
        anchors.rightMargin: 24 * pt
        spacing: 20 * pt

        Rectangle {
            Layout.fillWidth: true
            height: 36 * pt

            Text {
                anchors.fill: parent
                font.pixelSize: 20 * pt
                font.family: fontRobotoRegular.name
                verticalAlignment: Qt.AlignVCenter
                text: "My first wallet"
            }

            Button {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                text: "New payment"
            }
        }

        ListView {
            id: listViewToken
            Layout.fillWidth: true
            Layout.fillHeight: true

            section.delegate: Rectangle {
                width: listViewToken.width
                height: 36 * pt

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 16 * pt
                }
            }
        }
    }


    
//    DapUiQmlScreenChangeWidget {
//            id: listViewDapWidgets
//        }
    
//    DapScreenDialog {
//                    id: widgetModel
//                }
    
//    Rectangle {

//        anchors.fill: parent
        
//        GridView {
//            id: gridViewDashboard
            
//            signal pressAndHold(int index)
            
//            anchors.fill: parent
//            cellWidth: width/3; cellHeight: height/2
//            focus: true
//            model: widgetModel.ProxyModel
    
//            highlight: Rectangle { width: gridViewDashboard.cellWidth; height: gridViewDashboard.cellHeight; radius: width/50; color: "aliceblue" }
    
//            delegate: DapUiQmlWidgetDelegateForm {
//                width: gridViewDashboard.cellWidth
//                height: gridViewDashboard.cellHeight
    
//                MouseArea {
//                    anchors.fill: parent
//                    onClicked:
//                    {
//                        parent.GridView.view.currentIndex = index;
//                        stackView.push(Qt.resolvedUrl(URLpage), StackView.Immediate);
//                    }
//                }
//            }
//        }
//    }
    
//    RoundButton {
//           text: qsTr("+")
//           highlighted: true
//           anchors.margins: 10
//           anchors.right: parent.right
//           anchors.bottom: parent.bottom
//           onClicked: {
//                       listViewDapWidgets.addWidget()
//                   }
//       }

//    DapUiQmlWidgetLastActions {
//        viewModel: dapHistoryModel
//        viewDelegate: DapUiQmlWidgetLastActionsDelegateForm {}
//        viewSection.property: "date"
//        viewSection.criteria: ViewSection.FullString
//        viewSection.delegate: DapUiQmlWidgetLastActionsSectionForm {
//            width:  parent.width
//            height: 30 * pt
//        }
//    }
}

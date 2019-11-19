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
            model: dapWalletModel
            section.property: "networkDisplayRole"
            section.criteria: ViewSection.FullString
            section.delegate: Rectangle {
                width: parent.width
                height: 30 * pt
                color: "#908D9D"

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 16 * pt
                    font.family: fontRobotoRegular.name
                    font.pixelSize: 12 * pt
                    color: "#FFFFFF"
                    verticalAlignment: Qt.AlignVCenter
                    text: section
                }
            }


            clip: true

            delegate: Component {

                ListView
                {
                    width: listViewToken.width
                    height: contentItem.height
                    leftMargin: 16 * pt
                    interactive: false
                    section.property: "modelData.wallet"
                    section.delegate: Component{
                        Rectangle {
                            width: parent.width
                            height: 36 * pt

                            Row {
                                anchors.fill: parent
                                spacing: 36 * pt

                                Text {
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    verticalAlignment: Qt.AlignVCenter
                                    font.family: fontRobotoRegular.name
                                    font.pixelSize: 12 * pt
                                    color: "#908D9D"

                                    text: "Wallet address:"
                                }

                                Text {
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    width: 180 * pt
                                    verticalAlignment: Qt.AlignVCenter
                                    elide: Text.ElideRight
                                    font.family: fontRobotoRegular.name
                                    font.pixelSize: 10 * pt
                                    color: "#757184"
                                    text: section
                                }
                            }
                        }
                    }


                    model: walletTokenListDisplayRole
                    delegate: Component
                    {

                        Rectangle {
                            width: parent.width
                            height: 62 * pt
                            color: "#E3E2E6"

                            Rectangle {
                                anchors.fill: parent
                                anchors.topMargin: 1

                                RowLayout {
                                    anchors.fill: parent
                                    alignment: Qt.AlignLeft
                                    spacing: 16 * pt

                                    Label {
                                        verticalAlignment: Qt.AlignVCenter
                                        background: Rectangle {
                                            border.width: 1
                                            border.color: "#000000"
                                        }

                                        text: model.modelData.name
                                    }

                                    Label {
                                        verticalAlignment: Qt.AlignVCenter
                                        text: model.modelData.balance
                                        background: Rectangle {
                                            border.width: 1
                                            border.color: "#000000"
                                        }
                                    }

                                    Label {
                                        verticalAlignment: Qt.AlignVCenter
                                        text: model.modelData.balance
                                        background: Rectangle {
                                            border.width: 1
                                            border.color: "#000000"
                                        }
                                    }
                                }

                            }
                        }
                    }



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

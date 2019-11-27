import QtQuick 2.9
import QtQuick.Controls 2.2
import CellFrameDashboard 1.0

Page {
    property alias rightPanelLoaderSource: rightPanelLoader.source

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

    Button {
        id: newPaymentButton
        x: 390
        y: 40
        width: 132
        height: 36

        MouseArea {
            id: newPaymentMouseArea
            anchors.fill: newPaymentButton
            hoverEnabled: true

            onPressed: newPaymentBackground.color = "#FFFFFF"
        }

        background: Rectangle {
            id: newPaymentBackground
            anchors.fill: parent
            color: newPaymentMouseArea.containsMouse ? "#FFFFFF" : "#E3E5E8"
            border.color: "#5F5F63"
            border.width: 1 * pt
        }

        Image {
            id: iconImage
            width: 24
            height: 24
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            source: "Resources/Icons/defaul_icon.png"
        }

        Text {
            id: newPaymentText
            text: qsTr("New payment")
            font.family: "Roboto"
            font.pointSize: 16
            anchors.left: iconImage.right
            anchors.leftMargin: 6
            anchors.verticalCenterOffset: 0
            anchors.verticalCenter: parent.verticalCenter
            color: "#505559"
        }
    }

    Rectangle {
        id: rightPanel
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.right: parent.right
        width: 400 * pt

        Loader {
            id: rightPanelLoader
            clip: true
            anchors.fill: parent
            source: "DapUiQmlWidgetLastActions.qml"
        }

        Connections {
            target: rectangleStatusBar
            onAddWalletPressedChanged: rightPanelLoader.source = "DapUiQmlScreenDialogAddWalletForm.ui.qml"
        }

        Connections {
            target: newPaymentMouseArea
            onClicked: rightPanelLoader.source = "DapUiQmlNewPayment.qml"
        }

        Connections {
            target: rightPanelLoader.item
            onPressedSendButtonChanged: rightPanelLoader.source = "DapUiQmlStatusNewPaymentForm.ui.qml"
            onPressedCloseNewPaymentStatusButtonChanged: rightPanelLoader.source = "DapUiQmlWidgetLastActions.qml"
            onPressedDoneNewPaymentButtonChanged: rightPanelLoader.source = "DapUiQmlWidgetLastActions.qml"
        }

        Connections {
            target: rightPanelLoader.item
            onPressedCloseAddWalletChanged: rightPanelLoader.source = "DapUiQmlWidgetLastActions.qml"
            onPressedDoneCreateWalletChanged: rightPanelLoader.source = "DapUiQmlWidgetLastActions.qml"
            onPressedNextButtonChanged: {
                if(rightPanelLoader.item.isWordsRecoveryMethodChecked) rightPanelLoader.source = "DapUiQmlRecoveryNotesForm.ui.qml";
                else if(rightPanelLoader.item.isQRCodeRecoveryMethodChecked) rightPanelLoader.source = "DapUiQmlRecoveryQrForm.ui.qml";
                else if(rightPanelLoader.item.isExportToFileRecoveryMethodChecked) console.debug("Export to file"); /*TODO: create dialog select file to export */
                else rightPanelLoader.source = "DapUiQmlWalletCreatedForm.ui.qml"
            }
            onPressedBackButtonChanged: rightPanelLoader.source = "DapUiQmlScreenDialogAddWalletForm.ui.qml"
            onPressedNextButtonForCreateWalletChanged: rightPanelLoader.source = "DapUiQmlWalletCreatedForm.ui.qml"
        }
    }
}





/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

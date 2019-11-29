import QtQuick 2.9
import QtQuick.Controls 2.2
import CellFrameDashboard 1.0
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12


Page {
    //  TODO: Don't delete it
//    sproperty alias rightPanelLoaderSource: rightPanelLoader.ource

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
                anchors.left: parent
                font.pixelSize: 20 * pt
                font.family: fontRobotoRegular.name
                verticalAlignment: Qt.AlignVCenter
                text: "My first wallet"
            }

            Button {
                anchors.top: parent.top
                width: 132 * pt
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                text: "New payment"
                font.family: fontRobotoRegular.name
                font.pixelSize: 12 * pt
                highlighted: true

                background: Rectangle {
                    color: "#3E3853"
                }

                icon.width: 20 * pt
                icon.height: 20 * pt
                icon.source: "qrc:/Resources/Icons/new-payment_icon.png"
                icon.color: "#FFFFFF"
            }
        }


        ListView {
            id: listViewToken
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: dapWalletFilterModel
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

                    model: walletTokenListDisplayRole
                    section.property: "modelData.wallet"
                    section.delegate: Component{
                        Rectangle {
                            width: parent.width
                            height: 36 * pt

                            Row {
                                anchors.fill: parent

                                Text {
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    verticalAlignment: Qt.AlignVCenter
                                    font.family: fontRobotoRegular.name
                                    font.pixelSize: 12 * pt
                                    color: "#908D9D"

                                    text: "Wallet address:"
                                }

                                Item {
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    width: 36 * pt
                                }

                                Text {
                                    id: titleWalletAddress
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

                                Item {
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    width: 4 * pt
                                }

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    width: 16 * pt

                                    Image {
                                        id: imageButton
                                        anchors.centerIn: parent
                                        width: 16 * pt
                                        height: 16 * pt
                                        source: "qrc:/Resources/Icons/ic_copy.png"
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true

                                        onEntered: imageButton.source = "qrc:/Resources/Icons/ic_copy_hover.png"
                                        onExited: imageButton.source = "qrc:/Resources/Icons/ic_copy.png"
                                        onClicked: clipboard.setText(titleWalletAddress.text);
                                    }
                                }
                            }
                        }
                    }

                    delegate: Component
                    {

                        Rectangle {
                            width: parent.width - 16 * pt
                            height: 62 * pt
                            color: "#E3E2E6"

                            Rectangle {
                                anchors.fill: parent
                                anchors.topMargin: 1

                                Label {
                                    anchors.left: parent.left
                                    verticalAlignment: Qt.AlignVCenter
                                    height: parent.height
                                    font.family: fontRobotoRegular.name
                                    font.pixelSize: 18 * pt
                                    color: "#070023"
                                    text: model.modelData.name
                                }

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: 1
                                    height: parent.height
                                    verticalAlignment: Qt.AlignVCenter
                                    font.family: fontRobotoRegular.name
                                    font.pixelSize: 12 * pt
                                    color: "#070023"
                                    text: model.modelData.balance + " " + model.modelData.name
                                }

                                Label {
                                    anchors.right: parent.right
                                    height: parent.height
                                    verticalAlignment: Qt.AlignVCenter
                                    horizontalAlignment: Qt.AlignRight
                                    font.family: fontRobotoRegular.name
                                    font.pixelSize: 12 * pt
                                    color: "#757184"
                                    text: "$ " + model.modelData.balance + " USD"
                                }

                            }
                        }
                    }



                }

            }
        }
    }

    Button {
        id: newPaymentButton
        x: 390
        y: 40
        width: 140
        height: 36
        hoverEnabled: true

        background: Rectangle {
            id: newPaymentBackground
            anchors.fill: parent
            color: newPaymentButton.hovered ? "#FFFFFF" : "#E3E5E8"
            border.color: "#5F5F63"
            border.width: 1 * pt
        }

        onPressed: newPaymentBackground.color = "#FFFFFF"

    //  TODO: Don't delete it
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

        contentItem: Rectangle {
            anchors.fill: parent
            color: newPaymentBackground.color
            border.color: newPaymentBackground.border.color
            border.width: newPaymentBackground.border.width

            Image {
                id: iconImage
                width: 24
                height: 24
                anchors.left: parent.left
                anchors.leftMargin: 6 * pt
                anchors.verticalCenter: parent.verticalCenter
                source: "Resources/Icons/defaul_icon.png"
            }

            Text {
                id: newPaymentText
                text: qsTr("New payment")
                font.family: "Roboto"
                font.pointSize: 12
                anchors.left: iconImage.right
                anchors.leftMargin: 6
                anchors.verticalCenterOffset: 0
                anchors.verticalCenter: parent.verticalCenter
                color: "#505559"
            }
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
            target: newPaymentButton
            onClicked: rightPanelLoader.source = "DapUiQmlNewPayment.qml"
        }

        Connections {
            target: rightPanelLoader.item
            onPressedSendButtonChanged: rightPanelLoader.source = "DapUiQmlStatusNewPaymentForm.ui.qml"
            onPressedCloseButtonChanged: rightPanelLoader.source = "DapUiQmlWidgetLastActions.qml"
            onPressedDoneNewPaymentButtonChanged: {
                newPaymentBackground.color = "#E3E5E8"
                rightPanelLoader.source = "DapUiQmlWidgetLastActions.qml"
            }
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

//        Connections {
//            target: rightPanelLoader.item
//            onPressedCloseAddWalletChanged: rightPanelLoader.source = "DapUiQmlWidgetLastActions.qml"
//            onPressedDoneCreateWalletChanged: rightPanelLoader.source = "DapUiQmlWidgetLastActions.qml"
//            onPressedNextButtonChanged: {
//                if(rightPanelLoader.item.isWordsRecoveryMethodChecked) rightPanelLoader.source = "DapUiQmlRecoveryNotesForm.ui.qml";
//                else if(rightPanelLoader.item.isQRCodeRecoveryMethodChecked) rightPanelLoader.source = "DapUiQmlRecoveryQrForm.ui.qml";
//                else if(rightPanelLoader.item.isExportToFileRecoveryMethodChecked) console.debug("Export to file"); /*TODO: create dialog select file to export */
//                else rightPanelLoader.source = "DapUiQmlWalletCreatedForm.ui.qml"
//            }
//            onPressedBackButtonChanged: rightPanelLoader.source = "DapUiQmlScreenDialogAddWalletForm.ui.qml"
//            onPressedNextButtonForCreateWalletChanged: rightPanelLoader.source = "DapUiQmlWalletCreatedForm.ui.qml"
//        }
//    }
}





/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

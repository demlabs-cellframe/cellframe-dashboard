import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import "../"
import "../LastAction"

DapUiQmlScreen {
    id: dapUiQmlScreenDialog
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
                anchors.left: parent.left
                font.pixelSize: 20 * pt
                font.family: fontRobotoRegular.name
                verticalAlignment: Qt.AlignVCenter
                text: "My first wallet"
            }

            Button {
                id: newPaymentButton
                anchors.top: parent.top
                width: 140 * pt
                height: 36 * pt
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                highlighted: true
                hoverEnabled: true

                contentItem: Rectangle {
                    id: backgroundButton
                    anchors.fill: parent
                    color: newPaymentButton.hovered ? "#FFFFFF" : "#E3E5E8"
                    border.color: "#5F5F63"
                    border.width: 1 * pt

                    Text {
                        text: "New payment"
                        color: "#505559"
                        font.family: fontRobotoRegular.name
                        font.pixelSize: 12 * pt
                        anchors.fill: parent
                        verticalAlignment: Qt.AlignVCenter
                        horizontalAlignment: Qt.AlignRight
                        anchors.rightMargin: 12 * pt
                    }

                    Image {
                        id: iconNewWallet
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10 * pt
                        source: "qrc:/res/icons/new-payment_icon.png"
                        width: 24 * pt
                        height: 24 * pt
                    }
                }

                onClicked: {
                    rightPanel.header.push("qrc:/screen/LastAction/DapUiQmlNewPaymentHeader.qml", {"rightPanel": rightPanel});
                    rightPanel.content.push("qrc:/screen/LastAction/DapUiQmlNewPayment.qml", {"rightPanel": rightPanel});
                    backgroundButton.color = "#FFFFFF"
                }

                Connections {
                    target: rightPanel.content.currentItem
                    onPressedSendButtonChanged: backgroundButton.color = "#E3E5E8"
                }

                Connections {
                    target: rightPanel.header.currentItem
                    onPressedCloseChanged: backgroundButton.color = "#E3E5E8"
                }
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
                                        source: "qrc:/res/icons/ic_copy.png"
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true

                                        onEntered: imageButton.source = "qrc:/res/icons/ic_copy_hover.png"
                                        onExited: imageButton.source = "qrc:/res/icons/ic_copy.png"
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
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

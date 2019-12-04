import QtQuick 2.9
import QtQuick.Controls 2.2
import CellFrameDashboard 1.0
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12


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
}

import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

import DapTransactionHistory 1.0

DapUiQmlScreenHistoryForm {
    id: dapUiQmlScreenHistory

    Component {
        id: delegateDate
        Rectangle {
            width:  dapListView.width
            height: 30 * pt
            color: "#DFE1E6"

            Text {
                anchors.fill: parent
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: "#5F5F63"
                text: section
                font.family: "Regular"
                font.pixelSize: 12 * pt
                leftPadding: 30 * pt
            }
        }
    }


    Component {
        id: delegateConetnet

        Column {
            Rectangle {
                id: dapDelegateContent
                height: 65 * pt
                width: 1124 * pt

                RowLayout {
                    anchors.fill: parent

                    //  Spacing
                    Rectangle {
                        width: 30 * pt
                        height: parent.height
                    }

                    //  Image
                    Rectangle {
                        id: dapToken
                        border.color: "#000000"
                        border.width: 1
                        width: 30 * pt
                        height: 30 * pt
                        Layout.alignment: Qt.AlignVCenter

                        Image {
                            id: dapPicToken
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    //  Spacing
                    Rectangle {
                        width: 14 * pt
                        height: parent.height
                    }

                    // Token name
                    Rectangle {
                        id: dapTokenNameContainer
                        width: 246 * pt
                        Layout.maximumWidth: width
                        height: dapTokenName.contentHeight
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            id: dapTokenName
                            anchors.fill: parent
                            text: tokenName
                            color: "#4F5357"
                            font.family: "Regular"
                            font.pixelSize: 16 * pt
                        }
                    }

                    //  Spacing
                    Rectangle {
                        width: 30 * pt
                        height: parent.height
                    }

                    // Wallet number
                    Rectangle {
                        width: 330 * pt
                        Layout.maximumWidth: width
                        height: dapNumberWallet.contentHeight
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            id: dapNumberWallet
//                            width: parent.width / 2
                            anchors.fill: parent
                            color: "#4F5357"
                            text: numberWallet
                            font.family: "Regular"
                            font.pixelSize: 14 * pt
                            clip: true
                            elide: Text.ElideRight

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true

                                onMouseXChanged: {
                                    tipTokenName.x = mouse.x;
                                }

                                onMouseYChanged: {
                                    tipTokenName.y = mouse.y;
                                }

                                onEntered: {
                                    tipTokenName.visible = true;
                                }

                                onExited: {
                                    tipTokenName.visible = false;
                                }
                            }
                        }
                    }


                    //  Spacing
                    Rectangle {
                        width: 30 * pt
                        height: parent.height
                    }

                    //  Status
                    Rectangle {
                        width: 100 * pt
                        height: dapStatus.contentHeight
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            id: dapStatus
                            anchors.fill: parent
                            text: txStatus
                            color: statusColor
                            font.family: "Regular"
                            font.pixelSize: 14 * pt
                        }
                    }

                    //  Spacing
                    Rectangle {
                        width: 30 * pt
                    }

                    //  Money
                    Rectangle {
                        width: 264 * pt
                        height: parent.height
                        Layout.alignment: Qt.AlignVCenter

                        Column {
                            anchors.fill: parent
                            spacing: 0

                            //  Spacing
                            Rectangle {
                                width: parent.width
                                height: 15 * pt
                            }

                            //  Token currency
                            Label {
                                id: dapCurrency
                                width: parent.width
                                horizontalAlignment: Qt.AlignRight
                                text: cryptocurrency
                                color: "#4F5357"
                                font.family: "Regular"
                                font.pixelSize: 16 * pt
                            }

                            //  Spacing
                            Rectangle {
                                width: parent.width
                                height: 5 * pt
                            }

                            //  Equivalent currency
                            Label {
                                width: parent.width
                                horizontalAlignment: Qt.AlignRight
                                text: currency
                                color: "#C2CAD1"
                                font.family: "Regular"
                                font.pixelSize: 12 * pt
                            }
                        }
                    }

                    //  Spacing
                    Rectangle {
                        id: dapEndItem
                        width: 20 * pt
                        height: parent.height
                    }
                }
            }


            //  Number wallet tip
            Rectangle {
                id: tipTokenName
                color: "#FFFFFF";
                width: contentChildren.width
                height: contentChildren.height
                visible: false

                Text {
                    text: dapNumberWallet.text
                    color: "#4F5357"
                    font.family: "Regular"
                    font.pixelSize: 14 * pt
                }
            }

            //  Underline
            Rectangle {
                x: dapTokenNameContainer.x
                width: 1056 * pt
                height: 1
                color: "#C2CAD1"
            }
        }
    }


}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

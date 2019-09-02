import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Component {
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
                    id: imageTokenContainer
                    border.color: "#000000"
                    border.width: 1
                    width: 30 * pt
                    height: 30 * pt
                    Layout.alignment: Qt.AlignVCenter

                    Image {
                        id: imageToken
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
//                       source:
                    }
                }

                //  Spacing
                Rectangle {
                    width: 14 * pt
                    height: parent.height
                }

                // Token name
                Rectangle {
                    id: tokenNameContainer
                    width: 246 * pt
                    Layout.maximumWidth: width
                    height: tokenNameText.contentHeight
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        id: tokenNameText
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
                    id: walletNumberContainer
                    width: 330 * pt
                    Layout.maximumWidth: width
                    height: walletNumberText.contentHeight
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        id: walletNumberText
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
                                tipTokenNameContainer.x = mouse.x;
                            }

                            onMouseYChanged: {
                                tipTokenNameContainer.y = mouse.y;
                            }

                            onEntered: {
                                tipTokenNameContainer.visible = true;
                            }

                            onExited: {
                                tipTokenNameContainer.visible = false;
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
                    id: statusContainer
                    width: 100 * pt
                    height: statusText.contentHeight
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        id: statusText
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
                            id: currencyValueText
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
                            id: currencyAltValueText
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
            id: tipTokenNameContainer
            color: "#FFFFFF";
            width: contentChildren.width
            height: contentChildren.height
            visible: false

            Text {
                text: walletNumberText.text
                color: "#4F5357"
                font.family: "Regular"
                font.pixelSize: 14 * pt
            }
        }

        //  Underline
        Rectangle {
            x: tokenNameContainer.x
            width: 1056 * pt
            height: 1
            color: "#C2CAD1"
        }
    }
}

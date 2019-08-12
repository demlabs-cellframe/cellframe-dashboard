import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Page {
    ListView {
        id: dapListView
        anchors.fill: parent
        model: dapHistoryModel
        delegate: dapDelegate
        section.property: "date"
        section.criteria: ViewSection.FullString
        section.delegate: dapDate
    }

    Component {
        id: dapDate
        Rectangle {
            width:  dapListView.width
            height: childrenRect.height
            color: "#DFE1E6"

            Text {
                color: "#5F5F63"
                text: section
                font.family: "Regular"
                font.pointSize: 12
                leftPadding: 30
            }
        }
    }

    Component {
        id: dapDelegate

        Column {
            Rectangle {
                id: dapDelegateContent
                height: 60
                width: dapListView.width
                anchors.leftMargin: 30
                anchors.rightMargin: 20

                RowLayout {
                    anchors.fill: parent
                    spacing: 30

                    Rectangle {
                        width: 30
                    }

                    RowLayout {
                        spacing: 14

                        Rectangle {
                            id: dapToken
                            border.color: "#000000"
                            border.width: 1
                            width: 30
                            height: 30
                            anchors.topMargin: 15
                            anchors.bottomMargin: 15

                            Image {
                                id: dapPicToken
//                                anchors.left: parent.right
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Rectangle {
                            width: 246
                            height: dapTokenName.contentHeight
                            anchors.topMargin: 24
                            anchors.bottomMargin: 24

                            Text {
                                id: dapTokenName
                                anchors.fill: parent
                                text: tokenName
                                color: "#4F5357"
                                font.family: "Regular"
                                font.pointSize: 12
                            }
                        }
                    }

                    Rectangle {
                        width: 330
                        height: dapNumberWallet.contentHeight
                        anchors.topMargin: 24
                        anchors.bottomMargin: 24

                        Text {
                            id: dapNumberWallet
                            anchors.fill: parent
                            text: numberWallet
                            color: "#4F5357"
                            font.family: "Regular"
                            font.pointSize: 12
                        }
                    }


                    Rectangle {
                        width: 100
                        height: dapStatus.contentHeight
                        anchors.topMargin: 24
                        anchors.bottomMargin: 24

                        Text {
                            id: dapStatus
                            anchors.fill: parent
                            text: txStatus
                            color: "#4F5357"
                            font.family: "Regular"
                            font.pointSize: 12
                        }
                    }

                    Rectangle {
                        width: 264
                        height: parent.height

                        Column {
                            anchors.fill: parent
                            spacing: 9

                            Rectangle {
                                width: parent.width
                                height: 6
                            }


                            Text {
                                id: dapCurrency
                                width: parent.width
                                height: font.pointSize
                                horizontalAlignment: Qt.AlignRight
                                text: qsTr("KLV 123156315")
                                color: "#4F5357"
                                font.family: "Regular"
                                font.pointSize: 12
                            }


                            Text {
                                width: parent.width
                                height: font.pointSize
                                horizontalAlignment: Qt.AlignRight
                                text: qsTr("$ 122125455568868")
                                color: "#C2CAD1"
                                font.family: "Regular"
                                font.pointSize: 11
                            }

                            Rectangle {
                                width: parent.width
                                height: 6
                            }
                        }
                    }
                }

            }

            Rectangle {
//                anchors.left: dapToken.left
                width: parent.width
                height: 1
                color: "#C2CAD1"
            }
        }
    }
}

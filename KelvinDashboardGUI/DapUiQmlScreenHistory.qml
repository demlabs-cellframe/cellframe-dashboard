import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Page {
//    ListModel {
//        id: modeListView

//        ListElement { nameToken: "token1"; numberWallet: "123"; txStatus: "Error"; date: "today" }
//        ListElement { nameToken: "token2"; numberWallet: "234"; txStatus: "Sent"; date: "tomorrow" }
//    }

    ListView {
        id: dapListView
        anchors.fill: parent
//        model: modeListView
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

        Rectangle {
            id: dapDelegateContent
            border.color: "#000000"
            border.width: 1
            height: 60
            width: dapListView.width
            anchors.leftMargin: 30
            anchors.rightMargin: 20

            RowLayout {
                anchors.fill: parent
                spacing: 30

                Rectangle {
                    id: dapToken
                    border.color: "#000000"
                    border.width: 1
                    width: 60
                    height: parent.height

                    Image {
                        id: dapPicToken
                        width: 30
                        height: 30
                        anchors.topMargin: 15
                        anchors.bottomMargin: 15
                        anchors.left: parent.right
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
                        text: tokenName
                        color: "#4F5357"
                        font.family: "Regular"
                        font.pointSize: 12
                    }

                }

                Rectangle {
                    width: 330
                    height: dapNumberWallet.contentHeight
                    anchors.topMargin: 24
                    anchors.bottomMargin: 24

                    Text {
                        id: dapNumberWallet
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
                        text: txStatus
                        color: "#4F5357"
                        font.family: "Regular"
                        font.pointSize: 12
                    }
                }
            }
        }
    }
}

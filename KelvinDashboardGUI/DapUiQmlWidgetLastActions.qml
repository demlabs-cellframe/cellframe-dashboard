import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

import DapTransactionHistory 1.0

Rectangle {
    width: 400 * pt
    border.color: "#B5B5B5"
    border.width: 1 * pt
    color: "#EDEFF2"

    anchors {
        top: parent.top
        right: parent.right
        bottom: parent.bottom
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true

        onEntered: {
            buttonListScroll.visible = true;
        }

        onExited: {
            buttonListScroll.visible = false;
        }
    }

    Rectangle {
        id: dapHeader
        width: parent.width
        height: 36 * pt
        color: "#EDEFF2"

        Item {
            width: childrenRect.width
            height: childrenRect.height
            anchors.top: parent.top
            anchors.left: parent.left

            anchors.leftMargin: 16 * pt
            anchors.topMargin: 13

            Text {
                text: qsTr("Last actions")
                font.family: "Roboto"
                font.pixelSize: 12 * pt
                color: "#5F5F63"
            }
        }
    }

    ListView {
        id: dapListView
        anchors.top: dapHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true

        model: dapHistoryModel
        delegate: dapDelegate
        section.property: "date"
        section.criteria: ViewSection.FullString
        section.delegate: dapDate

        Component {
            id: dapDate
            Rectangle {
                width:  dapListView.width
                height: 30 * pt
                color: "#C2CAD1"

                Text {
                    anchors.fill: parent
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignLeft
                    color: "#797979"
                    text: section
                    font.family: "Roboto"
                    font.pixelSize: 12 * pt
                    leftPadding: 16 * pt
                }
            }
        }

        Component {
            id: dapDelegate

            Rectangle {
                id: dapContentDelegate
                width: parent.width
                height: 50 * pt
                color: "transparent"

                border.color: "#C2CAD1"
                border.width: 1 * pt

                Rectangle {
                    id: dapData
                    width: childrenRect.width
                    height: childrenRect.height
                    Layout.alignment: Qt.AlignVCenter
                    anchors.left: dapContentDelegate.left
                    anchors.leftMargin: 16 * pt
                    anchors.top: parent.top
                    anchors.topMargin: 13

                    Column {
                        anchors.fill: parent
                        spacing: 2

                        Text {
                            text: tokenName
                            color: "#5F5F63"
                            font.family: "Roboto Regular"
                            font.pixelSize: 14 * pt
                        }

                        Text {
                            text: txStatus
                            color: "#A7A7A7"
                            font.family: "Roboto"
                            font.pixelSize: 12 * pt
                        }
                    }
                }

                Text {
                    anchors.left: dapData.right
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 20 * pt

                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                    color: "#505559"
                    text: cryptocurrency;
                    font.family: "Roboto"
                    font.pixelSize: 14 * pt
                }

                Rectangle {
                    width: parent.width
                    height: 1 * pt
                    color: "#C7C9CC"
                    anchors.bottom: parent.bottom
                }
            }
        }

        Item {
            id: buttonListScroll

            property bool listDown: true

            width: 36 * pt
            height: width
            anchors.right: dapListView.right
            anchors.bottom: dapListView.bottom
            anchors.bottomMargin: 10 * pt
            anchors.topMargin: 10 * pt
            anchors.rightMargin: 10 * pt
            visible: false

            Image {
                id: imageButton
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "qrc:/Resources/Icons/ic_scroll-down.png"
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true


                onEntered: {
                    if(buttonListScroll.listDown)
                        imageButton.source = "qrc:/Resources/Icons/ic_scroll-down_hover.png";
                    else
                        imageButton.source = "qrc:/Resources/Icons/ic_scroll-up_hover.png";
                }

                onExited: {
                    if(buttonListScroll.listDown)
                        imageButton.source = "qrc:/Resources/Icons/ic_scroll-down.png";
                    else
                        imageButton.source = "qrc:/Resources/Icons/ic_scroll-up.png";
                }

                onPressed: {
                    //  TODO: scroll list


                    buttonListScroll.listDown = !buttonListScroll.listDown;
                    if(buttonListScroll.listDown) {
                        buttonListScroll.anchors.top = undefined;
                        buttonListScroll.anchors.bottom = dapListView.bottom;
                    }
                    else {
                        buttonListScroll.anchors.bottom = undefined;
                        buttonListScroll.anchors.top = dapListView.top;
                    }

                    exited();
                }
            }
        }

    }


}

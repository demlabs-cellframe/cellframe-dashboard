import QtQuick 2.13
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12
import NodeNetworkExplorer 1.0

Page {
    Rectangle {
        anchors.fill: parent;
        color: "#3b3353";
    }

    RowLayout {
        anchors.fill: parent
        spacing: 2

        Flickable {
            id: dapExplorer
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: dapGraphWidget.width * dapGraphWidget.scale
            contentHeight: dapGraphWidget.height * dapGraphWidget.scale
            contentY: dapGraphWidget.height / 2
            contentX: dapGraphWidget.width / 2

            DapUiQmlWidgetNodeNetwork {
                id: dapGraphWidget
                scale: 0.6
                transformOrigin: Item.TopLeft
                model: dapNodeNetworkModel
                colorOffline: "#eb4d4b"
                colorOnline: "#6ab04c"
                colorFocused: "#ff7979"
                colorSelect: "#686de0"
                onSelectNode: {
                    dapNodeNetworkMenu.x = getSelectedNodePosX();
                    dapNodeNetworkMenu.y = getSelectedNodePosY();

                    if(dapNodeNetworkModel.isNodeOnline(getSelectedNodeAddress()))
                        dapRadioButtonOnline.checked = true;
                    else
                        dapRadioButtonOffline.checked = true;

                    dapMenuItemStatus.enabled = isCurrentNode;
                    dapNodeNetworkMenu.visible = true;
                }
                onSelectNodeChanged: {
                    dapNodeNetworkDescription.visible = false;
                }

                Menu {
                    id: dapNodeNetworkMenu
                    MenuItem {
                        id: dapMenuItemDetails
                        text: qsTr("Show detalies")
                        onTriggered: {
                            dapNodeNetworkDescription.visible = true;
                            dapDescriptionModel.get(0).name = dapGraphWidget.getSelectedNodeAddress();
                            dapDescriptionModel.get(1).name = dapGraphWidget.getSelectedNodeAlias();
                            dapDescriptionModel.get(2).name = dapGraphWidget.getSelectedNodeIpv4();
                        }
                    }

                    MenuItem {
                        id: dapMenuItemStatus
                        text: qsTr("Set status")
                        onTriggered: {
                            dapWidgetNodeStatus.visible = true;
                        }
                    }
                }
            }
        }


        Rectangle {
            id: dapNodeNetworkDescription
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: false
            color: "#eaecef"

            ListModel {
                id: dapDescriptionModel
                ListElement { name: ""; category: "Address"; }
                ListElement { name: ""; category: "Alias"; }
                ListElement { name: ""; category: "Ipv4"; }
            }

            ListView {
                anchors.fill: parent
                model: dapDescriptionModel
                delegate: Text {text: name; font.pixelSize: 18 }
                section.property: "category"
                section.criteria: ViewSection.FullString
                section.delegate: dapCategory

                header: Rectangle {
                    width: parent.width
                    height: rowContent.height
                    RowLayout {
                        id: rowContent
                        Button {
                            text: "X"
                        }

                        Text {
                            Layout.rowSpan: 1
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("Description")
                        }
                    }

                }
            }


            Component {
                id: dapCategory
                Rectangle {
                    width: dapNodeNetworkDescription.width
                    height: childrenRect.height
                    color: "#0000FF"

                    Text {
                        color: "#FFFFFF"
                        text: section
                        font.bold: true
                        font.pixelSize: 20
                    }
                }
            }
        }
    }

    Rectangle
    {
        id: dapWidgetNodeStatus
        anchors.fill: parent
        visible: false
        color: "#B3B2B1"
        opacity: 0.6
    }

    Rectangle {
        anchors.centerIn: parent
        visible: dapWidgetNodeStatus.visible
        width: contentLayout.width
        height: contentLayout.height
        border.color: "#F3F2F1"
        border.width: 1

        ColumnLayout {
            id: contentLayout

            Text {
                Layout.fillWidth: true
                leftPadding: 30
                rightPadding: 30
                topPadding: 15
                font.pointSize: 16
                text: qsTr("Choose status")
            }

            RadioButton {
                id: dapRadioButtonOffline
                Layout.alignment: Qt.AlignCenter
                text: qsTr("Offline")
                onToggled: {
                    dapNodeNetworkModel.setStatusNode(false);
                }
            }

            RadioButton {
                id: dapRadioButtonOnline
                Layout.alignment: Qt.AlignCenter
                text: qsTr("Online")
                onToggled: {
                    dapNodeNetworkModel.setStatusNode(true);
                }
            }

            Button {
                Layout.fillWidth: true
                text: qsTr("Ok")

                onClicked: {
                    dapWidgetNodeStatus.visible = false;
                }
            }
        }
    }

}

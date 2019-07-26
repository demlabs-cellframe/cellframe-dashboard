import QtQuick 2.13
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12
import NodeNetworkExplorer 1.0

Page {
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
                onSelectNode: {
                    dapNodeNetworkMenu.x = posX;
                    dapNodeNetworkMenu.y = posY;
                    dapNodeNetworkMenu.visible = true;

                    dapDescriptionAddress.text = address;
                    dapDescriptionAlias.text = alias;
                    dapDescriptionIpv4.text = ipv4;
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
                        }
                    }

                    MenuItem {
                        id: dapMenuItemStatus
                        text: qsTr("Set status")
                        onTriggered: {

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
            border.color: "#F3F2F1"
            border.width: 1

             Column {
                 anchors.fill: parent

                 Text {
                     anchors.horizontalCenter: parent.horizontalCenter
                     topPadding: 20
                     bottomPadding: 30
//                     Layout.fillWidth: true
//                     Layout.alignment: Qt.AlignTop
//                     horizontalAlignment: Text.AlignHCenter
//                     verticalAlignment: Text.AlignVCenter
                     font.pointSize: 24
                     text: qsTr("Description")
                 }

                 Column {
//                     Layout.columnSpan: 0
                     leftPadding: 30

                     Text {
                         text: qsTr("Address")
                         font.pointSize: 13
                     }

                     Text {
                         id: dapDescriptionAddress
                         font.pointSize: 8
                     }
                 }


                 Column {
//                     Layout.columnSpan: 0
                     leftPadding: 30

                     Text {
                         text: qsTr("Alias")
                         font.pointSize: 13
                     }

                     Text {
                         id: dapDescriptionAlias
                         font.pointSize: 8
                     }
                 }

                 Column {
//                     Layout.columnSpan: 0
                     leftPadding: 30

                     Text {
                         text: qsTr("Ipv4")
                         font.pointSize: 13
                     }

                     Text {
                         id:dapDescriptionIpv4
                         font.pointSize: 8
                     }
                 }
             }
        }
    }
}

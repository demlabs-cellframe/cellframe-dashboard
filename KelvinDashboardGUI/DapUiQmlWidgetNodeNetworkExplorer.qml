import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import NodeNetworkExplorer 1.0

Page {
    Row {
        anchors.fill: parent

        Flickable {
            id: dapExplorer
            anchors.fill: parent
            contentWidth: dapGraphWidget.width * dapGraphWidget.scale
            contentHeight: dapGraphWidget.height * dapGraphWidget.scale
            contentY: dapGraphWidget.height / 2 - height / 2
            contentX: dapGraphWidget.width / 2 - width / 2

            DapUiQmlWidgetNodeNetwork {
                id: dapGraphWidget
                scale: 0.6
                transformOrigin: Item.TopLeft
                model: dapNodeNetworkModel

                Menu {
                    id: dapNodeNetworkMenu
                    MenuItem {
                        id: dapMenuItemDetails
                        text: "Show detalies"
                        onTriggered: {
                            dapNodeNetworkDescription.visible = true;
                        }
                    }

                    MenuItem {
                        id: dapMenuItemStatus
                        text: "Set status"
                        onTriggered: {

                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent;
                    acceptedButtons: Qt.RightButton
                    onReleased: {
                        dapNodeNetworkMenu.x = mouseX;
                        dapNodeNetworkMenu.y = mouseY;
                        dapNodeNetworkMenu.visible = true;
                    }
                }
            }
        }


        Rectangle {
            id: dapNodeNetworkDescription
            width: 300
//            anchors.top: parent.top
//            anchors.right: parent.right
//            anchors.bottom: parent.bottom
            visible: false
        }

    }
}

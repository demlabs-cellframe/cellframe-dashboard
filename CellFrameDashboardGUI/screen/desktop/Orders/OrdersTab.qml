import QtQuick 2.9
import VpnOrdersModel 1.0
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    color: "transparent"    

    // Qt Rectangle have a bug with radius rectangle clipping, so we must use opacityMask
    Rectangle {
        id: listViewBorder
        clip: true
        x: (root.width - width) / 2 * pt
        y: 24 * pt
        height: root.height - y - 24 * pt
        width: 350 * pt
        border.color: "#E2E1E6"
        border.width: 1 * pt
        radius: 10 * pt
        color: "transparent"


        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width:  listViewBorder.width
                height: listViewBorder.height
                Rectangle {
                    anchors.centerIn: parent
                    width:  listViewBorder.width
                    height: listViewBorder.height
                    radius: listViewBorder.radius
                }
            }
        }

        OrdersListView {
            id: listView
            model: VpnOrdersModel
            anchors.fill: parent
            anchors.margins: 2
            Component.onCompleted: model.sortByRegion()
        }
    }
}

import QtQuick 2.7

GridView {
    id: control

    property int delegateMargin
    property int delegateWidth: 300 * pt
    property int delegateHeight: 164 * pt
    property int delegateContentMargin: 16 * pt

    signal orderDetailsShow(var index)

    model: dapModelOrders

    cellWidth: delegateMargin * 2 + delegateWidth
    cellHeight: delegateMargin * 2 + delegateHeight

    clip: true
    currentIndex: -1
    focus: true

    delegate: Item {
        id: cell

        width: control.cellWidth
        height: control.cellHeight

        GridView.onRemove: {
            if (GridView.isCurrentItem) {
                control.currentIndex = -1;
            }
        }

        Rectangle {
            id: contentFrame

            x: control.delegateMargin
            y: control.delegateMargin
            width: parent.width - x * 2
            height: parent.height - y * 2

            color: "#00000000"
            border.width: pt
            border.color: "#E2E1E6"
            radius: 8 * pt
            focus: true

            Rectangle {
                id: headerFrame

                width: parent.width
                height: 30 * pt
                color: cell.GridView.isCurrentItem ? "#D51F5D" : "#3E3853"
                radius: 8 * pt

                Rectangle {
                    y: parent.height - height
                    width: parent.width
                    height: 8 * pt
                    color: parent.color
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: control.delegateContentMargin
                    anchors.right: orderIcon.right
                    font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                    elide: Text.ElideRight
                    color: "#FFFFFF"
                    text: "VPN Order " + model.index
                }

                Image {
                    id: orderIcon
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: (control.delegateContentMargin / 2) * pt  // / 2 - ic_info_order.svg have space right
                    sourceSize: Qt.size(parent.height, parent.height)
                    source: "qrc:/resources/icons/ic_info_order.svg"
                }
            }

            Item {
                id: infoFrame

                anchors { left: parent.left; top: headerFrame.bottom; right: parent.right; bottom: parent.bottom }
                anchors.margins: control.delegateContentMargin

                Column {
                    spacing: 12 * pt

                    DapVPNOrderInfoLine {
                        width: infoFrame.width
                        name: qsTr("Location ")
                        value: model.location
                        visible: model.location === "None-None" ? false : true
                    }
                    DapVPNOrderInfoLine {
                        width: infoFrame.width
                        name: qsTr("Network")
                        value: model.network
                    }
                    DapVPNOrderInfoLine {
                        width: infoFrame.width
                        name: qsTr("Node Addr")
                        value: model.node_addr
                        visible: model.node_addr === "" ? false : true

                    }
                    DapVPNOrderInfoLine {
                        width: infoFrame.width
                        name: qsTr("Price")
                        value: model.price
                    }
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    cell.forceActiveFocus();
                    control.currentIndex = index-1;
                    orderDetailsShow(model.index)
                }
            }
        }
    }
}

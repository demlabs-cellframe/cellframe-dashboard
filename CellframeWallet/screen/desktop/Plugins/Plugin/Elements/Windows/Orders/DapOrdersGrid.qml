import QtQuick 2.7
import QtGraphicalEffects 1.0

GridView {
    id: control

    property int delegateMargin
    property int delegateWidth: 285 
    property int delegateHeight: 164 
    property int delegateContentMargin: 16 

    model: dapModelOrders

    cellWidth: delegateMargin * 2 + delegateWidth
    cellHeight: delegateMargin * 2 + delegateHeight

    clip: true
    currentIndex: -1
//    focus: true

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

            color: "#2E3138"
            border.width: pt
            border.color: "#292929"
            radius: 20 
//            focus: true

            Rectangle {
                id: headerFrame

                width: parent.width
                height: 30 
//                color: cell.GridView.isCurrentItem ? "#D01E67" : "#2D3037"
                radius: parent.radius
                LinearGradient
                {
                    anchors.fill: parent
                    source: parent
                    start: Qt.point(0,parent.height/2)
                    end: Qt.point(parent.width,parent.height/2)
                    gradient:
                        Gradient {
                            GradientStop
                            {
                                position: 0;
                                color: cell.GridView.isCurrentItem ? "#7930DE" : "#2D3037"
                            }
                            GradientStop
                            {
                                position: 1;
                                color: cell.GridView.isCurrentItem ? "#7F65FF" : "#2D3037"
                            }
                        }
                }

                Rectangle {
                    y: parent.height - height
                    width: parent.width
                    height: parent.radius - 2 
                    color: parent.color
                    LinearGradient
                    {
                        anchors.fill: parent
                        source: parent
                        start: Qt.point(0,parent.height/2)
                        end: Qt.point(parent.width,parent.height/2)
                        gradient:
                            Gradient {
                                GradientStop
                                {
                                    position: 0;
                                    color: cell.GridView.isCurrentItem ? "#7930DE" : "#2D3037"
                                }
                                GradientStop
                                {
                                    position: 1;
                                    color: cell.GridView.isCurrentItem ? "#7F65FF" : "#2D3037"
                                }
                            }
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: control.delegateContentMargin
                    anchors.right: parent.right
                    font.family: "Quicksand"
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    color: "#ffffff"
                    text: qsTr("VPN Order ") + model.index
                }
                Rectangle
                {
                    anchors.top: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1 
                    color: "#292929"
                }
            }

            Item {
                id: infoFrame

                anchors { left: parent.left; top: headerFrame.bottom; right: parent.right; bottom: parent.bottom }
                anchors.margins: control.delegateContentMargin

                Column {
                    spacing: 12 

                    DapOrdersInfo {
                        width: infoFrame.width
                        name: qsTr("Location ")
                        value: model.location
                        visible: model.location === "None-None" ? false : true
                    }
                    DapOrdersInfo {
                        width: infoFrame.width
                        name: qsTr("Network")
                        value: model.network
                    }
                    DapOrdersInfo {
                        width: infoFrame.width
                        name: qsTr("Node Addr")
                        value: model.node_addr
                        visible: model.node_addr === "" ? false : true

                    }
                    DapOrdersInfo {
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
                }
            }
        }
    }
}

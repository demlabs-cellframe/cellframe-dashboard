import QtQuick 2.7
import QtGraphicalEffects 1.0
import "qrc:/widgets"

GridView {
    id: control

    property int delegateMargin
    property int delegateWidth: 300 
    property int delegateHeight: 164 
    property int delegateContentMargin: 16 
//    property alias currentIndex_ : currentIndex

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

        DapRectangleLitAndShaded {
            id: contentFrame

            x: control.delegateMargin
            y: control.delegateMargin
            width: parent.width - x * 2
            height: parent.height - y * 2

            color: currTheme.mainBackground
            radius: currTheme.frameRadius
            shadowColor: currTheme.reflectionLight
            lightColor: currTheme.shadowColor

            focus: true

            contentData:
                Item {
                anchors.fill: parent

                    Rectangle {
                        id: headerFrame

                        width: parent.width
                        height: 30 

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
                                        color: cell.GridView.isCurrentItem ? currTheme.mainButtonColorHover0 :
                                                                   currTheme.border
                                    }
                                    GradientStop
                                    {
                                        position: 1;
                                        color: cell.GridView.isCurrentItem ? currTheme.mainButtonColorHover1 :
                                                                   currTheme.border

                                    }
                                }
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: control.delegateContentMargin
                            anchors.right: orderIcon.right
                            font:  mainFont.dapFont.medium12
                            elide: Text.ElideRight
                            color: currTheme.white
                            text: qsTr("VPN Order ") + model.index
                        }

                        Image {
                            id: orderIcon
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: (control.delegateContentMargin / 2)   // / 2 - ic_info_order.svg have space right
                            mipmap: true
                            sourceSize: Qt.size(16, 16)
                            source: cell.GridView.isCurrentItem ? "qrc:/Resources/"+ pathTheme +"/icons/other/ic_info_hover.svg":
                                                                  "qrc:/Resources/"+ pathTheme +"/icons/other/ic_info.svg"
                        }
                        Rectangle
                        {
                            anchors.top: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 1 
                            color: currTheme.border
                        }
                    }

                    Item {
                        id: infoFrame

                        anchors { left: parent.left; top: headerFrame.bottom; right: parent.right; bottom: parent.bottom }
                        anchors.margins: control.delegateContentMargin

                        Column {
                            spacing: 12 

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
}

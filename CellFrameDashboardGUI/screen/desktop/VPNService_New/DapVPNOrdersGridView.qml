import QtQuick 2.7
import QtGraphicalEffects 1.0

GridView {
    id: control

    property int delegateMargin
    property int delegateWidth: 300 * pt
    property int delegateHeight: 164 * pt
    property int delegateContentMargin: 16 * pt
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

        Rectangle {
            id: contentFrame

            x: control.delegateMargin
            y: control.delegateMargin
            width: parent.width - x * 2
            height: parent.height - y * 2

            color: currTheme.backgroundMainScreen
            border.width: pt
            border.color: currTheme.lineSeparatorColor
            radius: currTheme.radiusRectangle
            focus: true

            Rectangle {
                id: headerFrame

                width: parent.width
                height: 30 * pt
//                color: cell.GridView.isCurrentItem ? currTheme.buttonColorNormal : currTheme.backgroundPanel
//                color: cell.GridView.isCurrentItem ? "#D51F5D" : "gray"
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
                                color: cell.GridView.isCurrentItem ? currTheme.buttonColorNormalPosition0 :
                                                         currTheme.buttonNetworkColorNoActive
                            }
                            GradientStop
                            {
                                position: 1;
                                color: cell.GridView.isCurrentItem ? currTheme.buttonColorNormalPosition1 :
                                                         currTheme.buttonNetworkColorNoActive
                            }
                        }
                }

                Rectangle {
                    y: parent.height - height
                    width: parent.width
                    height: parent.radius - 2 * pt
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
                                    color: cell.GridView.isCurrentItem ? currTheme.buttonColorNormalPosition0 :
                                                             currTheme.buttonNetworkColorNoActive
                                }
                                GradientStop
                                {
                                    position: 1;
                                    color: cell.GridView.isCurrentItem ? currTheme.buttonColorNormalPosition1 :
                                                             currTheme.buttonNetworkColorNoActive
                                }
                            }
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: control.delegateContentMargin
                    anchors.right: orderIcon.right
                    font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                    elide: Text.ElideRight
                    color: currTheme.textColor
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
                Rectangle
                {
                    anchors.top: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1 * pt
                    color: currTheme.lineSeparatorColor
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

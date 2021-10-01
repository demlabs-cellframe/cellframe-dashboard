import QtQuick 2.4
import QtQuick.Layouts 1.2
import "qrc:/widgets"
import "../../"
import "../../desktop/VPNService_New"

DapAbstractScreen {
    id:dapVPNCientScreen

    dapFrame.color: "#FFFFFF"
    anchors.fill: parent
    anchors.leftMargin: 24 * pt
    anchors.rightMargin: 24 * pt

    property alias dapAddOrderButton: addOrderButton
    property alias dapOrderCreateFrame: orderCreateFrame
    property alias dapGridViewOrder: gridViewOrder

    Rectangle
    {
        id: orderCreateFrame
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        Column
        {
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle
            {
                height: 82.79 * pt
                width: parent.width
            }
            Image
            {
                id: iconCreateOrder
                sourceSize: Qt.size(500 * pt, 261 * pt)
                source: "qrc:/resources/illustrations/illustration_vpn-service.svg"
//                    width: 500 * pt
//                    height: 300 * pt
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: 45 * pt
                width: parent.width
            }
            Text
            {
                id: titleTextOrderCreate
                font.family: "Quiksand"
                font.pixelSize: 26 * pt
                color: "#070023"
                text: qsTr("Create your first VPN order")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: 21 * pt
                width: parent.width
            }
            DapButton
            {
                id: addOrderButton

                implicitWidth: 180 * pt
                implicitHeight: 36 * pt
                radius: 4 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                heightImageButton: 21 * pt
                widthImageButton: 22 * pt
                textButton: "New VPN order"
//                    normalImageButton: "qrc:/resources/icons/new-wallet_icon_dark.svg"
//                    hoverImageButton: "qrc:/resources/icons/new-wallet_icon_dark_hover.svg"
                indentImageLeftButton: 41 * pt
                colorBackgroundNormal: "#070023"
                colorBackgroundHover: "#D51F5D"
                colorButtonTextNormal: "#FFFFFF"
                colorButtonTextHover: "#FFFFFF"
                indentTextRight: 37 * pt
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                borderColorButton: "#000000"
                borderWidthButton: 0
                horizontalAligmentText:Qt.AlignRight
                colorTextButton: "#FFFFFF"

            }
            Rectangle
            {
                height: Layout.fillHeight
                width: parent.width
            }
        }
    }
    GridView{
        id: gridViewOrder

        property int delegateMargin
        property int delegateWidth: 326 * pt
        property int delegateHeight: 190 * pt
        property int delegateContentMargin: 16 * pt

        model: vpnTest.ordersModel

        cellWidth: delegateMargin * 2 + delegateWidth
        cellHeight: delegateMargin * 2 + delegateHeight

        clip: true
        currentIndex: -1
        focus: true

        delegate: Item {
            id: cell

            width: gridViewOrder.cellWidth
            height: gridViewOrder.cellHeight

            GridView.onRemove: {
                if (GridView.isCurrentItem) {
                    gridViewOrder.currentIndex = -1;
                }
            }

            Rectangle {
                id: contentFrame

                x: gridViewOrder.delegateMargin
                y: gridViewOrder.delegateMargin
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
                        anchors.leftMargin: gridViewOrder.delegateContentMargin
                        anchors.right: orderIcon.right
                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                        elide: Text.ElideRight
                        color: "#FFFFFF"
                        text: model.name
                    }

                    Image {
                        id: orderIcon
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: (gridViewOrder.delegateContentMargin / 2) * pt  // / 2 - ic_info_order.svg have space right
                        sourceSize: Qt.size(parent.height, parent.height)
                        source: "qrc:/resources/icons/ic_info_order.svg"
                    }
                }

                Item {
                    id: infoFrame

                    anchors { left: parent.left; top: headerFrame.bottom; right: parent.right; bottom: parent.bottom }
                    anchors.margins: gridViewOrder.delegateContentMargin

                    Column {
                        spacing: 12 * pt

                        DapVPNOrderInfoLine {
                            width: infoFrame.width
                            name: qsTr("Date created")
                            value: model.dateCreated
                        }
                        DapVPNOrderInfoLine {
                            width: infoFrame.width
                            name: qsTr("Units")
                            value: model.units
                        }
                        DapVPNOrderInfoLine {
                            width: infoFrame.width
                            name: qsTr("Units type")
                            value: model.unitsType
                        }
                        DapVPNOrderInfoLine {
                            width: infoFrame.width
                            name: qsTr("Value")
                            value: model.value
                        }
                        DapVPNOrderInfoLine {
                            width: infoFrame.width
                            name: qsTr("Token")
                            value: model.token
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        cell.forceActiveFocus();
                        gridViewOrder.currentIndex = index;
                    }
                }
            }
        }
    }

}

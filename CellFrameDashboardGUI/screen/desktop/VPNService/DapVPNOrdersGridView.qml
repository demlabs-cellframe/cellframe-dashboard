import QtQuick 2.7

GridView {
    id: control

    property int delegateMargin
    property int delegateWidth: 326 * pt
    property int delegateHeight: 190 * pt
    property int delegateContentMargin: 16 * pt

    model: vpnTest.ordersModel

    cellWidth: delegateMargin * 2 + delegateWidth
    cellHeight: delegateMargin * 2 + delegateHeight

    clip: true
    currentIndex: -1

    delegate: Item {
        id: cell

        width: control.cellWidth
        height: control.cellHeight

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

            Rectangle {
                id: headerFrame

                width: parent.width
                height: 30 * pt
                color: control.currentIndex == index ? "#D51F5D" : "#3E3853"
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
                    font: quicksandFonts.medium12
                    elide: Text.ElideRight
                    color: "#FFFFFF"
                    text: model.name
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
                    control.currentIndex = index;
                }
            }
        }
    }
}
